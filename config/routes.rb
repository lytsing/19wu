NineteenWu::Application.routes.draw do
  get "autocomplete/users"

  resources :courses, except: [:destroy] do
    member do
      post 'join'
      post 'quit'
      post 'follow'
      post 'unfollow'
      get 'followers'
    end
    resources :participants , :only => [:index] do
      collection do
        get :checkin
        post :update
        get :export
      end
    end
    resources :collaborators, :only => [:index, :create, :destroy]
    resources :topics       , :only => [:new, :create, :show] do
      resource :reply       , :only => [:create]                  , :controller => 'topic_reply'
    end
    resources :export       , :only => [:index]
    resources :changes      , :only => [:index, :new, :create]    , :controller => 'course_changes'
    resources :tickets      , :controller => 'course_tickets'
    resources :orders       , :only => [:create, :index]          , :controller => 'course_orders' do
      collection do
        get 'status/:status', :to => 'course_orders#index', :as => :filter
      end
      member do
        post "refund/submit", to: 'order_refunds#submit'
      end
    end
  end

  get "courses/:course_id/summary", to: "course_summaries#new", as: :new_course_summary
  post "courses/:course_id/summary", to: "course_summaries#create", as: :create_course_summary
  patch "courses/:course_id/summary", to: "course_summaries#update"

  get ":slug" => "group#course", :constraints => SlugConstraint, :as => :slug_course
  get ":slug/followers" => "group#followers"
  get 'ordered_courses', to: "courses#ordered"
  post '/photos', to: "photo#create"
  post "/content/preview/" => "home#content_preview"

  authenticated :user do
    root to: "home#page", as: :authenticated_root
  end
  as :user do
    root to: 'home#page'
    get 'cohort' => 'users#cohort'
    get 'invitations' => 'invitations#index'

    get "refunds" => 'order_refunds#index'
    get "refunds/archive" => 'order_refunds#archive'
    post "refunds/alipay_notify" => 'order_refunds#alipay_notify'

    get 'admin_orders' => 'admin_orders#index'
    get 'admin_courses' => 'admin_courses#index'
    
    patch 'admin_orders/:id/pay' => 'admin_orders#pay', :as => :admin_orders_pay

    patch '/invitations/:id/mail' => 'invitations#mail', :as => :mail_invitation
    get 'invitations/upgrade' => 'invitations#upgrade', :as => :upgrade_invitation
    patch 'invitations/:id/upgrade_invite' => 'invitations#upgrade_invite', :as => :upgrade_invite_invitation

    resource :user_phone, only: [:edit, :update], format: false do
      post 'send_code'
    end
    resources :user_orders, only: [:index], format: false do
      member do
        get 'pay'

        put 'cancel'
        put 'request_refund'

        get 'alipay_done'
        post 'alipay_notify'
      end
    end
  end
  scope 'settings' do
    resource :profile, :only => [:show, :update]
    as :user do
      get 'account' => 'registrations#edit', :as => 'account'
    end
  end
  devise_for :users, :controllers => { :sessions => "sessions", :registrations => "registrations", :invitations => 'invitations', :omniauth_callbacks => 'authentications' }

  namespace :api, defaults: {format: 'json'} do
    get '/courses/:id/participants', to: "courses#participants"
  end

  namespace :admin do
    resources :fulfillments, only: [:index, :create], controller: 'order_fulfillments'
  end

  mount ChinaCity::Engine => '/china_city'
  mount MailsViewer::Engine => '/delivered_mails' if defined?(MailsViewer)
  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)

  # Fallback for /:login when user login is conflict with other routes
  #
  # Do not add :edit action or any other collection actions, the whole path is
  # preserved for any possible login name.
  resources :users, :path => '/u', :only => [:show]
  get ':id(.:format)' => 'users#show'

  get 'mockup/:action(.:format)', :controller => 'mockup'
end

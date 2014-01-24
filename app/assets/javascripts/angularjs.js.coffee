#= require angular
#= require angular-resource
#= require angular-strap.min
#= require_self
#= require_tree ./angularjs

@app = angular.module('shinebox', ['$strap.directives'])
@app.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

## shinebox

这里是 [shinebox.cn](http://shinebox.cn) 网站源代码.

## 系统要求

* Ruby 2.0.0 (or 1.9.3)
* PostgreSQL (or MySQL, SQLite)
* ImageMagick

## 安装步骤

### 测试环境

```bash
git clone https://github.com/lytsing/shinebox.git
cd shinebox
bundle install --without pg mysql2
rake setup
guard
```

### 生产环境部署 (MySQL)

安装Rails 请参考 [在 Ubuntu 12.04 Server 上安装部署 Ruby on Rails 应用](http://ruby-china.org/wiki/install-rails-on-ubuntu-12-04-server)

创建生产环境的数据库：

CREATE DATABASE `shinebox_production  ` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

```bash
bundle install --without sqlite3 pg
rake db:migrate RAILS_ENV=production
rake db:seed RAILS_ENV=production
RAILS_ENV=production bundle exec rake assets:precompile
```

## License

[The MIT License](https://github.com/lytsing/shinebox/blob/master/LICENSE)

Project is a member of the [OSS Manifesto](http://ossmanifesto.org).


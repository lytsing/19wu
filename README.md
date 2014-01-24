## shinebox

这里是 [shinebox.cn](http://shinebox.cn) 网站源代码.

## 系统要求

* Ruby 2.0.0 (or 1.9.3)
* PostgreSQL (or MySQL, SQLite)
* ImageMagick

## 安装步骤

```bash
git clone git://github.com/shinebox/shinebox.git
cd shinebox
bundle install --without pg mysql2
rake setup
guard
```
## License

[The MIT License](https://github.com/shinebox/shinebox/blob/master/LICENSE)

Project is a member of the [OSS Manifesto](http://ossmanifesto.org).


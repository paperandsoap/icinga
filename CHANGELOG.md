# CHANGELOG for icinga

This file is used to list changes made in each version of icinga.

## 0.1.75:

* Support redis services via check_mk agent
* Fixed mk_mysql agent with new version
* Fixed mk_jolokia agent
* Removed dependency with apt cookbook

## 0.1.67:

* Initial support for notifications, please check the README.md for usage and to adjust your data bag items for your users.
* Fixing permissions on htpasswd file for Check_MK
* Fixing permissions on notification log directory
* Moved hosts file into WATO for easier debugging
* Made WATO configurable via node attribute (False or True)

## 0.1.66:

* Added support for environments in the group data bag
* Moved users into WATO configuration
* Updated spec file

## 0.1.65:

* Fixing Gemfile to require Chef <11.0.0 for now

## 0.1.64:

* Updated to latest innovation release 1.2.1i5

## 0.1.40:

* Initial release of icinga

- - - 
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.

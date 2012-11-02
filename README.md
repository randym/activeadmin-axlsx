Active Admin Axlsx: Office Open XML Spreadsheet Export for Active Admin
====================================

If you are using this for comercial purposes, or just want to show your
appreciation for the gem, please don't hesitate to make a donation.

[![Click here to lend your support to: axlsx and make a donation at www.pledgie.com !](http://www.pledgie.com/campaigns/17814.png?skin_name=chrome)](http://www.pledgie.com/campaigns/17814)

**IRC**:[irc.freenode.net / #axlsx](irc://irc.freenode.net/axlsx)

**Git**:[http://github.com/randym/activeadmin-axlsx](http://github.com/randym/activeadmin-axlsx)

**Twitter**: [https://twitter.com/#!/morgan_randy](https://twitter.com/#!/morgan_randy)

**Google Group**: [https://groups.google.com/forum/?fromgroups#!forum/axlsx](https://groups.google.com/forum/?fromgroups#!forum/axlsx)

**Author**:  Randy Morgan

**Copyright**:    2012

**License**: MIT License

**Latest Version**: 1.0.0

**Ruby Version**: 1.9.2, 1.9.3

**JRuby Version**: 1.9 mode

**Rubinius Version**: rubinius 2.0.0dev * lower versions may run, this gem always tests against head.

**Release Date**: TBA

Synopsis
--------

This gem provides automatic OOXML (xlsx) downloads for Active Admin
resources. It lets you harness the full power of Axlsx when you want to
but for the most part just stays out of your way and adds a link next to 
the csv download for xlsx (Excel/numbers/Libre Office/Google Docs)


![Screen 1](https://github.com/randym/activeadmin-axlsx/raw/master/screen_capture.png)

Usage example:
Simple add the following to your gemfile and you are good to go.
All resource index views will now include a link for download directly
to xlsx.

```
gem 'activeadmin-axlsx'
```

Cool Toys
---------

Here are a few quick examples of things you can easily tweak.
Axlsx supports A LOT of the specification so if you are looking to do 
something adventurous please ping me on irc. (freenode#axlsx)

##localize column headers

```ruby
#app/admin/posts.rb
ActiveAdmin.register Posts do
  config.xlsx_builder.i18n_scope [:active_record, :models, :posts]
end
```

##Use blocks for adding computed fields

```ruby
#app/admin/posts.rb
ActiveAdmin.register Posts do
  config.xlsx_builder.column('author_name') do |resource|
    resource.author.name 
  end
end
```

##Change the column header style

```ruby
#app/admin/posts.rb
ActiveAdmin.register Posts do
  config.xlsx_builder.header_style = { :bg_color => 'FF0000',
                                       :fg_color => 'FF' }
end
```

#Specs
------
Running specs for this gem requires that you construct a rails application.
To execute the specs, navigate to the gem directory, 
run bundle install and run these to rake tasks:

```
bundle exec rake setup
```

```
bundle exec rake
```

#Copyright and License
----------

activeadmin-axlsx &copy; 2012 by [Randy Morgan](mailto:digial.ipseity@gmail.com).

activeadmin-axlsx is licensed under the MIT license. Please see the LICENSE document for more information.

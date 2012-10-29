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

Usage example:
Simple add the following to your gemfile and you are good to go.
All resource index views will now include a link for download directly
to xlsx.

```
gem 'activeadmin-axlsx'
```

#Specs
------
This gem (will have) has 100% test coverage. To execute the specs simply
navigate to the gem directory, do a bit of bundle install magic and run
these to rake tasks:

```
bundle exec rake setup
```

```
bundle exec rake
```

Please note that running setup will populate a rails application in the
active admin spec directory for testing purposes.

#Copyright and License
----------

activeadmin-axlsx &copy; 2012 by [Randy Morgan](mailto:digial.ipseity@gmail.com).

activeadmin-axlsx is licensed under the MIT license. Please see the LICENSE document for more information.

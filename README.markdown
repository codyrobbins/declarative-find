Declarative Find for Rails
=======================

This Rails plugin makes a `find` method available at the class level in `ApplicationController` which takes the name of an ActiveRecord model. Using this method creates a before filter which finds an ActiveRecord instance and assigns it to an appropriately named instance variable in the controller. The name of the model passed to `find` is used for both the key in `params` assumed to contain the ID of the record to find as well as the name of the instance variable to assign it to. An 404 HTTP code will be returned and the corresponding error page rendered for non-existent records via the [`http-error` gem](http://codyrobbins.com/software/http-error).

Full documentation is at [RubyDoc.info](http://rubydoc.info/gems/declarative-find).

Examples
--------

The following examples assume the request for the `delete` action has an `:id` or `:user` param passed to it with the ID of the user to delete.

### All actions

    class UserController < ApplicationController
      find(:user)

      def delete
        @user.destroy
      end
    end

### Options

The find can be restricted to specific actions the same way a typical before filter can be—in fact, any options passed to `find` are simply passed through to `before_filter`.

    class UserController < ApplicationController
      find(:user, :only => :delete)

      def delete
        @user.destroy
      end

      def something_else
        render(:text => 'Something else.')
      end
    end

Colophon
--------

### See also

If you like this gem, you may also want to check out [Declarative Find](http://codyrobbins.com/software/declarative-find), [Create New](http://codyrobbins.com/software/create-new), and  [HTTP Error](http://codyrobbins.com/software/http-error).

### Tested with

* Rails 3.0.5 — 20 May 2011

### Contributing

* [Source](https://github.com/codyrobbins/declarative-find)
* [Bug reports](https://github.com/codyrobbins/declarative-find/issues)

To send patches, please fork on GitHub and submit a pull request.

### Credits

© 2011 [Cody Robbins](http://codyrobbins.com/). See LICENSE for details.

* [Homepage](http://codyrobbins.com/software/declarative-find)
* [My other gems](https://rubygems.org/profiles/50409)
* [Follow me on Twitter](http://twitter.com/codyrobbins)
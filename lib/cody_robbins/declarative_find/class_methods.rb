# encoding: UTF-8

module CodyRobbins
  module DeclarativeFind
    module ClassMethods
      # Creates a before filter on the controller that finds an ActiveRecord instance and assigns it to an instance variable.
      #
      # * You pass the name of the model to look up to the method.
      # * The key in `params` assumed to contain the ID of the record to find is either `:id` or, if `:id` is not present, then extrapolated from the model name. For example, if the model is `User` then this key would be `:user`. Preference is given to `:id` to prevent conflicts in situations such as edit actions, where a record is looked up but new values for its attributes are passed via a key in `params` sharing the name of the model. For example, if the model is `User` then `params[:user]` would contain the attributes for the user from the form, and `:id` would have to be used to specify the ID of the user in question.
      # * The instance variable that the record is assigned to will be named according to the model—. For example
      #
      # An 404 HTTP code will be returned and the corresponding error page rendered for non-existent records via the [`http-error` gem](http://codyrobbins.com/software/http-error).
      #
      # @param name [Symbol, String] The name of the model to look up.
      # @param filter_options [Hash] Options to pass through to the underlying `before_filter`. For example, you could limit the lookup to a specific action by using the `:only` option.
      #
      # @example The following examples assume the request for the `delete` action has an `:id` or `:user` param passed to it with the ID of the user to delete.
      #    class UserController < ApplicationController
      #      find(:user)
      #
      #      def delete
      #        @user.destroy
      #      end
      #    end
      # @example Restricting the find to specific actions.
      #    class UserController < ApplicationController
      #      find(:user, :only => :delete)
      #
      #      def delete
      #        @user.destroy
      #      end
      #
      #      def something_else
      #        render(:text => 'Something else.')
      #      end
      #    end
      def find(name, filter_options = {})
        before_filter(filter_options) do
          model = name.classifyize
          id = params[:id] || params[name]
          object = model.find_by_id(id)

          if object
            set_instance_variable(name, object)
          else
            http_error(404)
          end
        end
      end
    end
  end
end

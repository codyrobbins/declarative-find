# encoding: UTF-8

module CodyRobbins
  module DeclarativeFind
    module ClassMethods
      # Creates a before filter on the controller that finds an ActiveRecord instance and assigns it to an instance variable.
      #
      # * You pass the name of the model to look up to the method.
      # * By default the key in `params` assumed to contain the ID of the record to find is either `:id` or, if `:id` is not present, then extrapolated from the model name. For example, if the model is `User` then this key would be `:user`. Preference is given to `:id` to prevent conflicts in situations such as edit actions, where a record is looked up but new values for its attributes are passed via a key in `params` sharing the name of the model. For example, if the model is `User` then `params[:user]` would contain the attributes for the user from the form, and `:id` would have to be used to specify the ID of the user in question.
      # * By default the instance variable that the record is assigned to will be named according to the model. For example, if the model is `User` then the instance variable will be `@user`.
      # * This behavior can be customized any which way via different combinations of options.
      #
      # An 404 HTTP code will be returned and the corresponding error page rendered for non-existent records via the [`http-error` gem](http://codyrobbins.com/software/http-error).
      #
      # @param name [Symbol, String] The name of the model to look up.
      # @param options [Hash] Any options not specifically used by the plugin method are simply passed through to the underlying `before_filter`. For example, you could limit the lookup to a specific action by including the `:only` option.
      # @option options [String, Symbol] :param The key used to look up the record’s ID in the `params` hash. It defaults to the name of the model. For example, if the model is `User` then this option will default to `:user`.
      # @option options [String, Symbol] :variable The name of the instance variable to assign the looked up object to. It defaults to the name of the model. For example, if the model is `User` then this option will default to `:user`.
      # @option options [String, Symbol, Proc] :using If this option is string or symbol, it represents the name of a method on the controller that will be invoked in order to perform the look up. If it’s a `Proc`, then the proc is invoked to perform the look up. In either case, the return value should be the object to assign to the instance variable. This option can be used when custom logic needs to be provided to find a record beyond simply looking up by its ID. This option defaults to `:find_` prepended to the name of the model. For example, if the model is `User` then this option will default to `:find_user`.
      #
      # @example Straight-forward lookup. This example assumes the request for the `delete` action has an `:id` or `:user` param passed to it containing the ID of the user to delete.
      #    class UserController < ApplicationController
      #      find(:user)
      #
      #      def delete
      #        @user.destroy
      #      end
      #    end
      # @example Overriding the name of the parameter containing the ID of the model. This example assumes the request for the `delete` action has a `:user_id` param passed to it containing the ID of the user to delete.
      #    class UserController < ApplicationController
      #      find(:user, :param => :user_id)
      #
      #      def delete
      #        @user.destroy
      #      end
      #    end
      # @example Overriding the name of the instance variable used to store the record. This example assumes the request for the `delete` action has an `:id` or `:user` param passed to it containing the ID of the user to delete.
      #    class UserController < ApplicationController
      #      find(:user, :variable => :user_to_delete)
      #
      #      def delete
      #        @user_to_delete.destroy
      #      end
      #    end
      # @example Using a method to provide custom logic for the lookup of the model.
      #    class UserController < ApplicationController
      #      find(:user)
      #
      #      def delete
      #        @user.destroy
      #      end
      #
      #      protected
      #
      #      def find_user
      #        User.find_by_email(params[:email])
      #      end
      #    end
      # @example Using a custom-named method to provide the logic for the lookup of the model.
      #    class UserController < ApplicationController
      #      find(:user, :using => :find_user_by_email)
      #
      #      def delete
      #        @user.destroy
      #      end
      #
      #      protected
      #
      #      def find_user_by_email
      #        User.find_by_email(params[:email])
      #      end
      #    end
      # @example Using a `Proc` to provide custom logic for the lookup of the model.
      #    class UserController < ApplicationController
      #      find(:user, :using => proc { User.find_by_email(params[:email]) })
      #
      #      def delete
      #        @user.destroy
      #      end
      #
      #      protected
      #
      #      def find_user_by_email
      #        User.find_by_email(params[:email])
      #      end
      #    end
      # @example Using a block to provide custom logic for the lookup of the model.
      #    class UserController < ApplicationController
      #      find(:user) { User.find_by_email(params[:email]) }
      #
      #      def delete
      #        @user.destroy
      #      end
      #    end
      # @example Restricting the lookup to specific actions.
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
      def find(name, options = {}, &block)
        options.reverse_merge!(:param    => name,
                               :variable => name,
                               :using    => "find_#{name}")

        model         = name.to_class
        param_name    = options.delete(:param)
        variable_name = options.delete(:variable)
        lookup_method = options.delete(:using)

        before_filter(options) do
          object = if block_given?
                     yield
                   elsif lookup_method.is_a?(Proc)
                     lookup_method.call
                   elsif lookup_method.respond_to?(:to_s) && respond_to?(lookup_method.to_s)
                     send(lookup_method.to_s)
                   else
                     id = params[:id] || params[param_name]
                     model.find_by_id(id)
                   end

          if object
            set_instance_variable(variable_name, object)
          else
            http_error(404)
          end
        end
      end
    end
  end
end

module CodyRobbins
  module LookupRecord
    class Railtie < Rails::Railtie
      initializer('cody_robbins.lookup_record') do
        ActiveSupport.on_load(:action_controller) do
          ApplicationController.send(:extend, ClassMethods)
        end
      end
    end
  end
end

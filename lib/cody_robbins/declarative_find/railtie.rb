module CodyRobbins
  module DeclarativeFind
    class Railtie < Rails::Railtie
      initializer('cody_robbins.declarative_find') do
        ActiveSupport.on_load(:action_controller) do
          extend(ClassMethods)
        end
      end
    end
  end
end

module CodyRobbins
  module LookupRecord
    module ClassMethods
      def lookup_record(name, filter_options = {})
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

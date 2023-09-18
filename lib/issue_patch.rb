require_dependency 'issue'

module IssuePatch

  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
    end
  end

	module InstanceMethods
		def estimated_internal
			use = Setting[SETTINGS_NAME]['estimated_field_use'] 
			if (use.nil? || use == false)
				return estimated_hours
			end

			@custom_field_estimated_id ||= CustomField.find(Setting[SETTINGS_NAME]['estimated_field']).id
			@estimated_internal ||= custom_field_values.select{|item| item.custom_field_id == @custom_field_estimated_id}.shift
			@estimated_internal.nil? ? 0.to_f : @estimated_internal.value.to_f
		end

		def estimated_internal=(value)
			@estimated_internal.value = value.to_f if !@estimated_internal.nil?
		end
  end
end


Issue.send(:include, IssuePatch)

require_dependency 'time_entry'

module TimeEntryPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      validate :check_and_correct_hours
    end
  end

  module InstanceMethods
    protected

    def check_and_correct_hours
      if new_record?
        correct_hours
      else
        correct_hours if changed? && changed.include?('hours')
      end
    end

    def correct_hours
      if (issue.estimated_hours.nil? || issue.estimated_hours == 0)
        errors.add :base, l('can_not_be_noted', {
          hours: hours.round(2),
          limit: 0
        })
      else 
        max_ratio = 1.0 
        available_limit = issue.estimated_hours * max_ratio - (issue.total_spent_hours - (hours_was||0))

        time_left = (available_limit - hours).round(2)
        if (time_left) < 0
          errors.add :base, l('can_not_be_noted', {
            hours: hours.round(2),
            limit: available_limit.round(2)
          })
        end
      end
    end
  end
end

TimeEntry.send(:include, TimeEntryPatch)

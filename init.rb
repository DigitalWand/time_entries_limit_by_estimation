Redmine::Plugin.register :time_entries_limit_by_estimation do
  name 'Time entries limit by estimation'
  author 'DigitalWand'
  description 'This plugin restricts user to spend more time for a task then specifien in task\'s estimation'
  version '1.0.0'
  url 'https://github.com/DigitalWand/time_entries_limit_by_estimation'
  author_url 'https://github.com/DigitalWand'
  

  ActiveSupport::Reloader.to_prepare do
    require_dependency 'time_entry_patch'
  end
end

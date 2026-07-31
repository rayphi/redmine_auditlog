require 'redmine_auditlog'

Redmine::Plugin.register :redmine_auditlog do
  name 'Redmine Auditlog'
  author 'Alex Stanev'
  description 'Tracks changes to a single, configurable custom field (based on https://github.com/RealEnder/redmine_auditlog).'
  version '0.0.7'
  url 'https://github.com/RealEnder/redmine_auditlog'
  author_url 'https://www.stanev.org'
  requires_redmine :version_or_higher => '3.0.0'
  Audited.current_user_method = :find_current_user

  settings default: { 'billable_custom_field_id' => '' }, partial: 'settings/redmine_auditlog_settings'

  Rails.configuration.to_prepare do
    CustomValue.send(:include, RedmineAuditlog::AuditlogPatchCustomValue)
  end
end

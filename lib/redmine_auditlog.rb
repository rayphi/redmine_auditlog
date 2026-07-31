module RedmineAuditlog

  module AuditlogPatch
    def self.included(base)
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
        audited
      end
    end
  end

  module AuditlogPatchUser
    def self.included(base)
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
        audited except: [:salt, :hashed_password]
      end
    end
  end

  module AuditlogPatchToken
    def self.included(base)
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
        audited except: :value
      end
    end
  end

  module AuditlogPatchAuthSource
    def self.included(base)
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
        audited except: :account_password
      end
    end
  end

  module AuditlogPatchRepository
    def self.included(base)
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
        audited except: :password
      end
    end
  end
  
  # Special patch for entities with custom values
  module AuditlogPatchWithCustomValues
    def self.included(base)
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
        audited
        
        # Store custom values in audits
        before_audit do |record, audit|
          if record.respond_to?(:custom_values) && record.custom_values.any?
            # Get custom field changes
            custom_changes = {}
            record.custom_values.each do |cv|
              next unless cv.changed?
              
              # Get custom field name
              field_name = cv.custom_field.name rescue "custom_field_#{cv.custom_field_id}"
              if cv.value_was != cv.value
                custom_changes["cf_#{cv.custom_field_id}_#{field_name}"] = [cv.value_was, cv.value]
              end
            end
            
            # Merge custom changes with regular changes
            audit.audited_changes ||= {}
            audit.audited_changes.merge!(custom_changes) if custom_changes.present?
          end
        end
      end
    end
  end

  # Audits only the custom field configured via the plugin settings
  module AuditlogPatchCustomValue
    def self.included(base)
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
        audited if: :tracked_custom_value?, max_audits: 4, on: [:update]

        def tracked_custom_value?
          tracked_id = Setting.plugin_redmine_auditlog['billable_custom_field_id']
          tracked_id.present? && custom_field_id.to_s == tracked_id.to_s
        end
      end
    end
  end

end

class InstallAudited < ActiveRecord::Migration[6.1]
  def self.up
    # Skip if the table already exists
    return if table_exists?(:audits)

    # Use Rails generator to create the audited tables
    Rails.application.load_tasks
    generator_args = []
    if connection.adapter_name.downcase.include?('postgresql')
      generator_args << '--audited-changes-column-type' << 'jsonb'
    end
    
    Rails::Generators.invoke('audited:install', generator_args, behavior: :invoke, destination_root: Rails.root)
    
    # The generator creates a migration in db/migrate, we need to run it manually since
    # we're already in a migration
    migration_file = nil
    Dir.glob("#{Rails.root}/db/migrate/*_install_audited.rb").each do |file|
      if File.read(file).include?('CreateAudits')
        migration_file = file
        break
      end
    end
    
    if migration_file
      require migration_file
        # The class name will be something like InstallAudited20250523104500
      # We extract the class from the file content
      migration_class = nil
      File.read(migration_file).scan(/class\s+([A-Za-z0-9_]+)\s+</).each do |match|
        begin
          migration_class = match.first.constantize
          break if migration_class < ActiveRecord::Migration
        rescue
          next
        end
      end
      
      if migration_class
        migration_class.new.up
        # Delete the migration file after we've run it to avoid duplicates
        File.delete(migration_file)
      end
    end
  end
  
  def self.down
    # We don't drop the audits table on plugin uninstall to preserve audit history
    # Users can manually drop the table if needed
  end
  
  private
  
  def self.table_exists?(table_name)
    ActiveRecord::Base.connection.table_exists?(table_name)
  end
end

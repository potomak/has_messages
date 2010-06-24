class HasMessagesGenerator < Rails::Generator::Base
  default_options :skip_migration => false
  
  def manifest
    record do |m|
      m.class_collisions "message"
      
      m.directory 'app/models'
      m.directory 'spec/models'
      m.directory 'db/migrate'

      if options[:email]
        m.directory 'app/views/message_mailer'
        m.template 'message_with_email.rb', File.join('app/models', "message.rb")
        m.template 'message_mailer.rb', File.join('app/models', "message_mailer.rb")
        m.file 'message_notification.html.erb', File.join('app/views/message_mailer', "message_notification.html.erb"), :collision => :overwrite
      else
        m.template 'message.rb', File.join('app/models', "message.rb")
      end

      unless options[:skip_migration]
        m.migration_template 'migration.rb', 'db/migrate', :assigns => {
          :migration_name => "CreateMessages"
        }, :migration_file_name => "create_messages"
      end
    end
  end


  protected
  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--skip-migration",
      "Don't generate a migration file for this model") { |v| options[:skip_migration] = v }
    opt.on("--email", 
      "Generate email notification system") { |v| options[:email] = v }
  end
  
end

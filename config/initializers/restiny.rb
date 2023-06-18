require "restiny"

Restiny.api_key = Rails.application.credentials.bungie.api_key
Restiny.oauth_client_id = Rails.application.credentials.bungie.oauth_client_id

Rails.application.config.after_initialize do
    if defined?(::Rails::Server) # only gets mainfest when booting server
        puts "Getting Destiny manifest..."
        DESTINY_MANIFEST = Restiny.download_manifest()
        puts "DESTINY_MANIFEST set up"
    end 
end
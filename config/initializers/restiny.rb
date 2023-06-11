require "restiny"

Restiny.api_key = Rails.application.credentials.bungie.api_key
Restiny.oauth_client_id = Rails.application.credentials.bungie.oauth_client_id
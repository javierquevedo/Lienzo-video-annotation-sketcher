# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_videoannotations_session',
  :secret      => '4953753cb5931a227f36edfa05c878c56500b7336338d8ba78f1fa0ee59bee737f0c229269e7050d14e7419b4e0f54e8da0bfe9297fe589e094dd420ab647ad1'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

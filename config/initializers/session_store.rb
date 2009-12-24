# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_benyehuda_session',
  :secret      => '70f2faa94ce2786f4964f4098179948a9bb08f3536545b7f9b4dd22a68c61dd9d8ff440854cb22883aa6d10230ad44c29dcdd146f550cfc1411810ff5672d6b3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

ActionController::Dispatcher.middleware.insert_before(
  ActionController::Session::CookieStore,
  FlashSessionCookieMiddleware,
  ActionController::Base.session_options[:key]
)
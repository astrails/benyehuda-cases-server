module Astrails
  module Auth
    class Mailer < ActionMailer::Base

      def password_reset_instructions(user)
        subject       "#{domain}: Password Reset Instructions"
        from          "Password Reset <noreply@#{domain}>"
        recipients    user.email
        sent_on       Time.now
        body          :domain => domain, :user => user, :edit_password_url => edit_password_url(user.perishable_token)
      end

      def password_reset_confirmation(user)
        subject       "#{domain}: Password Reset Notification"
        from          "Password Reset <noreply@#{domain}>"
        recipients    user.email
        sent_on       Time.now
        body          :domain => domain, :user => user, :login_url => login_url
      end

      def activation_instructions(user)
        subject       "#{domain}: Account Activation Instructions"
        from          "Activation <noreply@#{domain}>"
        recipients    user.email
        sent_on       Time.now
        body          :domain => domain, :user => user, :account_activation_url => activate_url(user.perishable_token)
      end

      def activation_confirmation(user)
        subject       "Welcome to #{domain}"
        from          "Activation <noreply@#{domain}>"
        recipients    user.email
        sent_on       Time.now
        body          :domain => domain, :user => user, :login_url => login_url
      end

      protected

      def domain
        @domain ||= default_url_options[:host] = GlobalPreference.get(:domain)
      end

    end
  end
end

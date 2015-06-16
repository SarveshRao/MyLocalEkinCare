class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @customer = Customer.find_for_oauth(request.env["omniauth.auth"], session[:current_online_customer])

        if @customer
          sign_in_and_redirect @customer, event: :authentication
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
        else
          puts "***********************************8"
          puts env["omniauth.auth"]
          puts "***********************************8"
          session["devise.#{provider}_data"] = request.env["omniauth.auth"]
          redirect_to new_online_customer_registration_url
        end
      end
    }
  end

  [:twitter, :facebook, :google_oauth2].each do |provider|
    provides_callback_for provider
  end
end

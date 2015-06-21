require 'devise/version'

module DeviseInvitable
  module Mailer

    # Deliver an invitation email
    def invitation_instructions_parexel(record, token, opts={})
      @token = token
      devise_mail(record, :invitation_instructions_parexel, opts)
    end
  end
end

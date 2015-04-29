# Rake task to migrate existing customer steps to new steps

namespace :eKincare do
  task wizard_step_change: :environment do
    # :contact_details, :life_style, :family_history, :current_complaints, :records_submission
    Customer.all.each do |customer|
      step = customer.current_state
      step = 'thank_you_page' if ['welcome_page'].include? step
      step = 'your_health' if ['contact_details', 'life_style', 'family_history'].include? step
      step = 'upload_documents' if ['records_submission'].include? step
      customer.status = step
      if customer.save
        puts "#{customer.name} status has changed to #{step}"
      end
    end
  end
end
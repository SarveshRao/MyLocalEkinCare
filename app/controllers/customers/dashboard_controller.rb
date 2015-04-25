class Customers::DashboardController < CustomerAppController
  add_breadcrumb 'Home', :customers_dashboard_show_path

  def show
    current_online_customer = Customer.find_by(id: "2")
    customer = current_online_customer
    @diabetic_score=customer.diabetic_score
    @hypertension_score=customer.hypertension_score(1).round(3)
    @hypertension_percentage=(@hypertension_score*100).round
    @medical_conditions=MedicalCondition.all
  end

  def inbox
    render partial: '/customers/dashboard/inbox'
  end

  def appointments
    render partial: '/customers/dashboard/appointments'
  end
end

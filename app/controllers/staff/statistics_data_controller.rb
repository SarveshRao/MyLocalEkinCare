class Staff::StatisticsDataController < ApplicationController
  include ApplicationHelper
  def index
    @total_customers=Customer.all.count
    @one_week=Hash.new
    from=Time.now
    to=1.week.ago
    tmp = from
    while tmp > to do
      temp1=formatted_date(tmp)
      @one_week[temp1]=(Customer.where(created_at:(tmp.beginning_of_day..tmp.end_of_day)).count)
      tmp -= 1.day
    end
    @one_week_customers_data=Hash[@one_week.to_a.reverse]
    render json: {data:@one_week_customers_data}
  end

  def customers_vital_data
    obese=Array.new
    weights=Array.new
    under_weights=Array.new
    healthy=Array.new
    @customers=Customer.all
    @customers.each do |customer|
        case customer.obesity_overweight_checkup
          when 1;under_weights.push(customer)
          when 2;healthy.push(customer)
          when 3;weights.push(customer)
          when 4;obese.push(customer)
        end
    end
    @number_of_customers_who_are_obese=obese.count()
    @over_weight=weights.count
    @healthy_customers=healthy.count

    render json: {obese:@number_of_customers_who_are_obese,over_weight:@over_weight,healthy_count:@healthy_customers}
  end

  def document_upload_status_data
    @customers=Customer.all
    uploaded_customers=Array.new
    @customers.each do |customer|
      if(customer.is_uploaded_documents==false)
        uploaded_customers.push(customer)
      end
    end
    @uploaded_customers_count=uploaded_customers.count()
    @not_uploaded_customers=Customer.all.count-@uploaded_customers_count

    render json: {uploaded_customers: @uploaded_customers_count, not_uploaded_customers: @not_uploaded_customers}
  end

end
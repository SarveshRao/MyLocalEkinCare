class Staff::CompanyLoginController < StaffController
  before_action :staff_authenticated, :dashboard_active
  layout 'staff'

  def show
    @current_staff = current_staff
    @total_customers = Customer.where(sponsor: @current_staff.admin_id).count
    # @weight_overweight = Customer.where(sponsor: @current_staff.admin_id, is_over_weight: 'OverWeight').count
    # @weight_obese = Customer.where(sponsor: @current_staff.admin_id, is_obese: 'Obese').count
    # @weight_healthy = @total_customers-@weight_overweight-@weight_obese
    # @is_hypertensive = Customer.where(sponsor: @current_staff.admin_id, is_hypertensive: 'Hypertensive').count
    # @hypertensive_healthy = @total_customers-@is_hypertensive
    # @is_diabetic = Customer.where(sponsor: @current_staff.admin_id, diabetic: 'Diabetic').count
    # @diabetic_healthy = @total_customers-@is_diabetic
  end

  def weight_filter
    gender=params[:gender]
    range1=params[:range1]
    range2=params[:range2]
    @current_staff = current_staff

    query =''
    if gender!="All"
      query = query+" and gender='#{gender.to_s}'"
    end
    if range1!="All"
      query = query+" and date_part('year',age(date_of_birth)) between '#{range1}' and '#{range2}'"
    end

    @customers=Customer.where("sponsor = #{@current_staff.admin_id} #{query}").count
    @customers_overweight=Customer.where("sponsor = #{@current_staff.admin_id} #{query} and is_over_weight='OverWeight'").count
    @customers_obese=Customer.where("sponsor = #{@current_staff.admin_id} #{query} and is_obese='Obese'").count
    @customers_healthy = @customers-@customers_overweight-@customers_obese

    render json: {total_customers: @customers, Overweight: @customers_overweight, Obese: @customers_obese, Healthy: @customers_healthy}
  end

  def hypertension_filter
    gender=params[:gender]
    range1=params[:range1]
    range2=params[:range2]
    @current_staff = current_staff
    query =''
    if gender!="All"
      query = query+" and gender='#{gender.to_s}'"
    end
    if range1!="All"
      query = query+" and date_part('year',age(date_of_birth)) between '#{range1}' and '#{range2}'"
    end

    @customers=Customer.where("sponsor = #{@current_staff.admin_id}#{query}").count
    @customers_hypertensive=Customer.where("sponsor = #{@current_staff.admin_id}#{query} and is_hypertensive='Hypertensive'").count
    @customers_pre_hypertensive=Customer.where("sponsor = #{@current_staff.admin_id}#{query} and is_hypertensive='Pre Hypertensive'").count
    @customers_healthy = @customers-@customers_hypertensive-@customers_pre_hypertensive

    render json: {total_customers: @customers, Hypertension: @customers_hypertensive, pre_hypertensive: @customers_pre_hypertensive, Healthy: @customers_healthy}
  end

  def diabetic_filter
    gender=params[:gender]
    range1=params[:range1]
    range2=params[:range2]
    @current_staff = current_staff
    query =''
    if gender!="All"
      query = query+" and gender='#{gender.to_s}'"
    end
    if range1!="All"
      query = query+" and date_part('year',age(date_of_birth)) between '#{range1}' and '#{range2}'"
    end
    @customers=Customer.where("sponsor = #{@current_staff.admin_id} #{query}").count
    @customers_diabetic=Customer.where("sponsor = #{@current_staff.admin_id} #{query} and diabetic='Diabetic'").count
    @customers_pre_diabetic=Customer.where("sponsor = #{@current_staff.admin_id} #{query} and diabetic='Pre Diabetic'").count
    @customers_healthy = @customers-@customers_diabetic

    render json: {total_customers: @customers, Diabetic: @customers_diabetic, pre_diabetic: @customers_pre_diabetic, Healthy: @customers_healthy}
  end

  def getanalysis
    @current_staff = current_staff
    options = params[:options]
    query = ''
    weight_healthy=''
    weight_overweight=''
    weight_obese=''
    hypertensive_healthy =''
    hypertensive=''
    diabetic_healthy=''
    diabetic=''

    unless options.nil?
      options.each do |element|
        if element == "weight_healthy"
          weight_healthy = "weight_healthy"
        elsif element == "weight_overweight"
          weight_overweight = "weight_overweight"
        elsif element == "weight_obese"
          weight_obese = "weight_obese"
        elsif element == "hypertensive_healthy"
          hypertensive_healthy = "hypertensive_healthy"
        # elsif element == "prehypertensive"
        #   query = query + " and is_hypertensive='Pre Hypertensive'"
        elsif element == "hypertensive"
          hypertensive = "hypertensive"
        elsif element == "diabetic_healthy"
          diabetic_healthy = "diabetic_healthy"
        # elsif element == "prediabetic"
        #   query = query + " and diabetic='Pre Diabetic'"
        elsif element == "diabetic"
          diabetic = "diabetic"
        end
      end
      if weight_healthy!='' and hypertensive!='' and diabetic!='' and weight_overweight!='' and weight_obese!='' and hypertensive_healthy!='' and diabetic_healthy!=''
        query = ''
      elsif weight_healthy!='' and hypertensive!='' and diabetic!=''
        query = " and (is_over_weight='No' and is_obese='No' and is_under_weight='No') and (is_hypertensive='Hypertensive' or diabetic='Diabetic')"
      elsif weight_overweight!='' and hypertensive!='' and diabetic!=''
        query = " and is_over_weight='OverWeight' and (is_hypertensive='Hypertensive' or diabetic='Diabetic')"
      elsif weight_obese!='' and hypertensive!='' and diabetic!=''
        query = " and is_obese='Obese' and (is_hypertensive='Hypertensive' or diabetic='Diabetic')"
      elsif weight_healthy!='' and weight_overweight!='' and weight_obese!=''
        query = " and (is_over_weight='No' and is_obese='No' and is_under_weight='No') or is_over_weight='OverWeight' or is_obese='Obese'"
      elsif weight_healthy!='' and weight_overweight!=''
        query = " and (is_over_weight='No' and is_obese='No' and is_under_weight='No') or is_over_weight='OverWeight'"
      elsif weight_healthy!='' and weight_obese!=''
        query = " and (is_over_weight='No' and is_obese='No' and is_under_weight='No') or is_obese='Obese'"
      elsif weight_overweight!='' and weight_obese!=''
        query = " and is_over_weight='OverWeight' or is_obese='Obese'"
      elsif hypertensive!='' and hypertensive_healthy!=''
        query = " and (is_hypertensive='Hypertensive' or is_hypertensive='No')"
      elsif diabetic_healthy!='' and diabetic!=''
        query = " and (diabetic='Diabetic' or diabetic='No')"
      elsif weight_healthy!='' and hypertensive!=''
        query = " and (is_over_weight='No' and is_obese='No' and is_under_weight='No') and is_hypertensive='Hypertensive'"
      elsif weight_healthy!='' and diabetic!=''
        query = " and (is_over_weight='No' and is_obese='No' and is_under_weight='No') and diabetic='Diabetic'"
      elsif weight_healthy!='' and hypertensive_healthy!='' and diabetic_healthy!=''
        query = " and (is_over_weight='No' and is_obese='No' and is_under_weight='No') and is_hypertensive='No' and diabetic='No'"
      elsif weight_healthy!='' and hypertensive_healthy!=''
        query = " and (is_over_weight='No' and is_obese='No' and is_under_weight='No') and is_hypertensive='No'"
      elsif weight_healthy!='' and diabetic_healthy!=''
        query = " and (is_over_weight='No' and is_obese='No' and is_under_weight='No') and diabetic='No'"
      elsif weight_overweight!='' and hypertensive!=''
        query = " and is_over_weight='OverWeight' and is_hypertensive='Hypertensive'"
      elsif weight_overweight!='' and diabetic!=''
        query = " and is_over_weight='OverWeight' and diabetic='Diabetic'"
      elsif weight_overweight!='' and hypertensive_healthy!='' and diabetic_healthy!=''
        query = " and is_over_weight='OverWeight' and is_hypertensive='No' and diabetic='No'"
      elsif weight_overweight!='' and hypertensive_healthy!=''
        query = " and is_over_weight='OverWeight' and is_hypertensive='No'"
      elsif weight_overweight!='' and diabetic_healthy!=''
        query = " and is_over_weight='OverWeight' and diabetic='No'"
      elsif weight_obese!='' and hypertensive!=''
        query = " and is_obese='Obese' and is_hypertensive='Hypertensive'"
      elsif weight_obese!='' and diabetic!=''
        query = " and is_obese='Obese' and diabetic='Diabetic'"
      elsif weight_obese!='' and hypertensive_healthy!='' and diabetic_healthy!=''
        query = " and is_obese='Obese' and is_hypertensive='No' and diabetic='No'"
      elsif weight_obese!='' and hypertensive_healthy!=''
        query = " and is_obese='Obese' and is_hypertensive='No'"
      elsif weight_obese!='' and diabetic_healthy!=''
        query = " and is_obese='Obese' and diabetic='No'"
      elsif hypertensive_healthy!='' and diabetic_healthy!=''
        query = " and is_hypertensive='No' and diabetic='No'"
      elsif hypertensive_healthy!='' and diabetic!=''
        query = " and is_hypertensive='No' and diabetic='Diabetic'"
      elsif hypertensive!='' and diabetic_healthy!=''
        query = " and is_hypertensive='Hypertensive' and diabetic='No'"
      elsif hypertensive!='' and diabetic!=''
        query = " and is_hypertensive='Hypertensive' and diabetic='Diabetic'"
      elsif weight_healthy!=''
        query = " and (is_over_weight='No' and is_obese='No' and is_under_weight='No')"
      elsif weight_overweight!=''
        query = " and is_over_weight='OverWeight'"
      elsif weight_obese!=''
        query = " and is_obese='Obese'"
      elsif hypertensive_healthy!=''
        query = " and is_hypertensive='No'"
      elsif hypertensive!=''
        query = " and is_hypertensive='Hypertensive'"
      elsif diabetic_healthy!=''
        query = " and diabetic='No'"
      elsif diabetic!=''
        query = " and diabetic='Diabetic'"
      end

      @customers_selected =Customer.where("sponsor = #{@current_staff.admin_id} #{query}").count
    end
    if @customers_selected.nil?
      @customers_selected = 0
    end
    @customers=Customer.where("sponsor = #{@current_staff.admin_id}").count
    render json: {total_customers: @customers, option_selected: @customers_selected}
  end

  protected
  def dashboard_active
    @dashboard_active = true
  end
end

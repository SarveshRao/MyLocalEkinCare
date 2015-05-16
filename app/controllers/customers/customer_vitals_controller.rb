class Customers::CustomerVitalsController < CustomerAppController
  include ApplicationHelper
  def update

    @customer_vitals = CustomerVitals.find_by_customer_id(params[:id])
    customer_id=params[:id]
    weight_id=VitalList.find_by_name('weight').id
    height_id=VitalList.find_by_name('feet').id
    inches_id=VitalList.find_by_name('inches').id


    unless(customer_params[:weight].nil?)
      name='weight_bmi'
      vital=Vital.create(customer_id:customer_id,vital_list_id:VitalList.find_by_name('weight').id,value:customer_params[:weight])
    end

    unless(customer_params[:feet].nil?)
      name='height_bmi'
      vital=Vital.create(customer_id:customer_id,vital_list_id:VitalList.find_by_name('feet').id,value:customer_params[:feet])
    end

    unless(customer_params[:inches].nil?)
      name='height_bmi'
      vital=Vital.create(customer_id:customer_id,vital_list_id:VitalList.find_by_name('inches').id,value:customer_params[:inches])
    end

    if(params[:customer_vitals][:blood_group].present?)
      group=params[:customer_vitals][:blood_group]
      blood_group=BloodGroup.find_by_blood_type(group)
      unless(blood_group.nil?)
        @customer_vitals.update(blood_group_id:blood_group.id)
      end
    end

    modified_date=formatted_date Time.now
    respond_to do |format|
      if @customer_vitals.update_attributes(customer_params)
        format.html {
          flash[:success] = "customer vitals updated"
          sign_in @customer_vitals
          redirect_to @customer_vitals
        }
        if @customer_vitals.inches
          inches = @customer_vitals.inches
        else
          inches = 0
        end

        if @customer_vitals.feet
          feet = @customer_vitals.feet
        else
          feet = 0
        end

        if @customer_vitals.weight
          weight = @customer_vitals.weight
        else
          weight = 0
        end

        inches = (feet * 12) + inches
        height_in_meters = (inches * 0.0254)
        weight = weight.to_i
        bmi=self.bmi(@customer_vitals.feet,@customer_vitals.inches,@customer_vitals.weight.to_i)
        colored_bmi=get_bmi_color(customer_id,bmi)
        format.json {render :json => { date:modified_date,customer_vitals: @customer_vitals, bmi: bmi,name:name,color:colored_bmi ,:status => 200 }}
      else
        format.html { render 'edit' }
        format.json {render :json => { date:modified_date,customer_vitals: @customer_vitals, bmi: bmi,name:name,color:colored_bmi, :status => 200 }}
      end
    end
  end



  protected
  def get_bmi_color customer_id,bmi
    customer=Customer.find(customer_id)
    begin
      colors = ['#1aae88', '#fcc633', '#e33244']
      if customer.age['years'].to_i < 25
        result_val = [bmi.between?(18, 25), bmi.between?(26, 30), eval("#{bmi} < 18 || #{bmi} > 30")]
      else
        result_val = [bmi.between?(19, 25), bmi.between?(26, 30), eval("#{bmi} < 19 || #{bmi} > 30")]
      end

      result_val.each_with_index do |val, index|
        if val
          return colors[index]
        end
      end
    rescue
      ''
    end
  end

  def bmi(height_in_feet,height_in_inches,weight)
    begin
      inches = height_in_feet+height_in_inches
      height_in_meters = (inches * 0.0254)
      weight = @customer_vitals.weight.to_i
      bmi = (weight / (height_in_meters * height_in_meters)).to_i
    rescue
      '-'
    end

  end

  def customer_params
    params.require(:customer_vitals).permit(:weight, :feet, :inches, :customer_id,:waist)
  end
end


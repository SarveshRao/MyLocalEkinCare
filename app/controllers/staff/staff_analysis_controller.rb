class Staff::StaffAnalysisController < StaffController
  # def index
  #     @hypertension0_count=0
  #     @hypertension1_count=0
  #     @hypertension2_count=0
  #     @hypertension3_count=0
  #     @hypertension4_count=0
  #     @hypertension5_count=0
  #     @hypertension6_count=0
  #     @hypertension7_count=0
  #     @hypertension8_count=0
  #     @hypertension9_count=0
  #
  #     @diabetic0_count=0
  #     @diabetic1_count=0
  #     @diabetic2_count=0
  #     @diabetic3_count=0
  #     @diabetic4_count=0
  #     @diabetic5_count=0
  #     @diabetic6_count=0
  #     @diabetic7_count=0
  #     @diabetic8_count=0
  #     @diabetic9_count=0
  #
  #     @obesity0_count=0
  #     @obesity1_count=0
  #     @obesity2_count=0
  #     @obesity3_count=0
  #     @obesity4_count=0
  #     @obesity5_count=0
  #     @obesity6_count=0
  #     @obesity7_count=0
  #     @obesity8_count=0
  #     @obesity9_count=0
  #
  #     @total_documents = MedicalRecord.all.count
  #
  #     Customer.all.each do |customer|
  #       age = customer.age['year'].to_i
  #       if customer.gender=='Male' and customer.has_hypertension1
  #         @hypertension0_count+=1 if age<=20
  #         @hypertension1_count+=1 if age.between?(21,30)
  #         @hypertension2_count+=1 if age.between?(31,40)
  #         @hypertension3_count+=1 if age.between?(41,50)
  #         @hypertension4_count+=1 if age>50
  #       end
  #
  #       # if customer.gender=='Female' and customer.has_hypertension1
  #       #   @hypertension5_count+=1 if age<20
  #       #   @hypertension6_count+=1 if age.between?(21,30)
  #       #   @hypertension7_count+=1 if age.between?(31,40)
  #       #   @hypertension8_count+=1 if age.between?(41,50)
  #       #   @hypertension9_count+=1 if age>50
  #       # end
  #       # if customer.is_diabetic and customer.gender=='Male'
  #       #   @diabetic0_count+=1 if age<20
  #       #   @diabetic1_count+=1 if age.between?(21,30)
  #       #   @diabetic2_count+=1 if age.between?(31,40)
  #       #   @diabetic3_count+=1 if age.between?(41,50)
  #       #   @diabetic4_count+=1 if age>50
  #       # end
  #       #
  #       # if customer.is_diabetic and customer.gender=='Female'
  #       #   @diabetic5_count_count+=1 if age<20
  #       #   @diabetic6_count+=1 if age.between?(21,30)
  #       #   @diabetic7_count+=1 if age.between?(31,40)
  #       #   @diabetic8_count+=1 if age.between?(41,50)
  #       #   @diabetic9_count+=1 if age>50
  #       # end
  #       #
  #       #
  #       # if customer.obesity_overweight_checkup>2 and customer.gender=='Female'
  #       #   @obesity0_count+=1 if age<20
  #       #   @obesity1_count+=1 if age.between?(21,30)
  #       #   @obesity2_count+=1 if age.between?(31,40)
  #       #   @obesity3_count+=1 if age.between?(41,50)
  #       #   @obesity4_count+=1 if age>50
  #       # end
  #       #
  #       # if customer.obesity_overweight_checkup>2 and customer.gender=='Male'
  #       #   @obesity5_count+=1 if age<20
  #       #   @obesity6_count+=1 if age.between?(21,30)
  #       #   @obesity7_count+=1 if age.between?(31,40)
  #       #   @obesity8_count+=1 if age.between?(41,50)
  #       #   @obesity9_count+=1 if age>50
  #       # end
  #     end
  # end

  def get_stats
    parameter=params[:type]
    gender=params[:gender]

    @count1=0
    @count2=0
    @count3=0
    @count4=0
    @count5=0

    unless((parameter.nil?) and (gender.nil?))
      if params[:min]
        @customers=Customer.where("gender='#{gender.to_s}' and id between #{params[:min]} and #{params[:max]}")
      else
        @customers=Customer.where("gender='#{gender.to_s}'")
      end
      @customers.each do |customer|
        age = customer.age['year'].to_i
        if(parameter.to_s=='hypertension')
          if customer.has_hypertension
            @count1+=1 if age<20
            @count2+=1 if age.between?(20,30)
            @count3+=1 if age.between?(31,40)
            @count4+=1 if age.between?(41,50)
            @count5+=1 if age>50
          end
        end

        if(parameter.to_s=='pre-hypertension')
          if customer.has_hypertension1
            @count1+=1 if age<20
            @count2+=1 if age.between?(20,30)
            @count3+=1 if age.between?(31,40)
            @count4+=1 if age.between?(41,50)
            @count5+=1 if age>50
          end
        end

        if(parameter.to_s=='diabetes')
          if customer.is_diabetic
            @count1+=1 if age<20
            @count2+=1 if age.between?(20,30)
            @count3+=1 if age.between?(31,40)
            @count4+=1 if age.between?(41,50)
            @count5+=1 if age>50
          end
        end
        if(parameter.to_s=='obesity')
          if customer.obesity_overweight_checkup>2
            @count1+=1 if age<20
            @count2+=1 if age.between?(20,30)
            @count3+=1 if age.between?(31,40)
            @count4+=1 if age.between?(41,50)
            @count5+=1 if age>50
          end
        end
      end
      # respond_to do |format|
      render json: {gender:gender,type_of_disease:parameter,:'<20'=>@count1,'20-30'=>@count2,'31-40'=>@count3,'41-50'=>@count4,'>50'=>@count5}, status: 200
      # format.json {render :json => {gender:@gender,type_of_disease:@parameter,:'<20'=>@count1,'20-30'=>@count2,'31-40'=>@count3,'41-50'=>@count4,'>50'=>@count5}}
      # end
    else
      render json: {}, status: :unprocessable_entity
    end
  end

end

require 'faker'

namespace :eKincare do

  task info: :environment do
  end

  task delete_seed_data: :environment do
    puts 'delete labtests'
    LabTest.delete_all
    puts 'Test components'
    StandardRange.delete_all
    TestComponent.delete_all
    puts 'delete providers'
    Provider.delete_all
    puts 'delete drugs'
    Drug.delete_all
    puts 'delete blood groups'
    BloodGroup.delete_all
    puts 'delete allergies'
    Allergy.delete_all
    puts 'delete immunizations'
    Immunization.delete_all
  end

  namespace :customers do
    task build: :environment do

      # puts 'Creating providers...'
      # 120.times do
      #   provider_name = "#{Faker::Name.first_name} medical center"
      #   provider_no = Faker::PhoneNumber.subscriber_number(10)
      #   Provider.create(name: provider_name, telephone: provider_no)
      # end

      puts 'Creating customers...'
      100.times do
        first_name = Faker::Name.first_name
        last_name = Faker::Name.last_name
        gender = ['Male', 'Female'].sample
        martial_status = ['Married', 'Single'].sample
        religious_affiliation =[
            'Arianism', 'Christadelphians', 'Christian Gnosticism',
            'Cerdonians', 'Kalam', 'Maturidi',
            'Bektashi', 'Chishti', 'Mevlevi'].sample
        language_spoken = ['Telugu', 'Hindi', 'English'].sample
        date_of_birth = Random.rand(25...60).years.ago
        customer_type = ['Self', 'Sponsored'].sample
        email = Faker::Internet.email
        mobile_number = Faker::PhoneNumber.subscriber_number(10)
        height = "#{rand(4.4..6.3).round(2)} feet"
        weight = "#{rand(45...92).round(2)} kgs"
        no_of_children = rand(5)
        daily_activity = ['Sedentary', 'Moderate', 'Active'].sample
        frequency_of_exercise = ['2-3 times/wk', '3-4 times/wk', 'Daily', 'Never', 'Occasional'].sample
        smoke = ['None', 'Occassional', 'Often'].sample
        alcohol = ['None', 'Occassional', 'Often'].sample
        medical_insurance = ['None', 'Yes'].sample
        diet = ['Vegetarian', 'Non Vegetarian', 'Vegan'].sample

        #add customers
        c = Customer.create!(first_name: first_name, last_name: last_name, gender: gender, martial_status: martial_status,
                             religious_affiliation: religious_affiliation, language_spoken: language_spoken,
                             date_of_birth: date_of_birth, email: email, customer_type: customer_type, mobile_number: mobile_number,
                             feet: [6, 5].sample, inches: [1..12].sample, weight: weight, smoke: smoke, alcohol: alcohol, frequency_of_exercise: frequency_of_exercise,
                             daily_activity: daily_activity, number_of_children: no_of_children, medical_insurance: medical_insurance, diet: diet, password: 'testtest1'
        )

        #add Address
        line1 = ['D.No: 007', 'Flt No: 5624', 'H.No: 4-562-452'].sample
        line2 = ['Jaysri Apts, kirthungla Street', 'Pikachu Apts , Margapatta city, Kalyan nagar', 'Apex Apts, Autonagar Street'].sample
        city_state = [{'Hyderabad' => 'Andhra Pradesh'}, {'Hyderabad' => 'Telangana'}, {'Vijayawada' => 'Andhra Pradesh'}, {'Madhurai' => 'Tamil Nadu'}, {'Chennai' => 'Tamil Nadu'}, {'Sringar' => 'Jammu & Kashmir'}].sample
        country = 'India'
        zip_code = Faker::Address.zip_code

        a = Address.create(line1: line1, line2: line2, city: city_state.keys.first, state: city_state.values.first, country: country, zip_code: zip_code, addressee_id: c.id, addressee_type: 'Customer')

        #add immunizations
        Random.rand(5..10).times do
          immunization_name = ['Influenza virus vaccine, IM', 'Tetanus and diphtheria toxoids, IM', 'Pneumococcal 7-valent Conjugate',
                               'Tetanus & Diphtheria', 'Pneumococcal 13-valent Conjugate ', 'Meningococcal Polysaccharide'].sample
          immunization_type = 'Intramuscular injection'
          immunization_instructions = 'Mild pain or soreness in the local area'
          immunization_dose = [' 0.5 / mL', '1.0 / mL'].sample
          customer_immunization_instructions = ['Soreness and swelling in injection site', 'Brief fainting spells',
                                                'Soreness at the injection site', 'Soreness and redness at the injection site'].sample
          immunization_date = Random.rand(1..200).days.ago

          immunization = Immunization.create!(name: immunization_name, immunization_type: immunization_type)
          ci = c.customer_immunizations.create!(dosage: immunization_dose, instructions: customer_immunization_instructions, date: immunization_date)
          ci.update(immunization: immunization)
          ci.save!
        end

        #add allergies
        #Random.rand(5..10).times do
        #  allergy_name = ['Soy', 'Shellfish', 'Peanuts', 'Latex', 'Dogs/Pets'].sample
        #  allergy_reaction = ['Hives and itching', 'Hives', 'Anaphylactic shock', 'Hives and difficulty breathing', 'Sneezing and runny nose'].sample
        allergy_severity = ['Moderate', 'Severe', 'Moderate to Severe'].sample
        #
        customer_allergy = c.customer_allergies.create(allergy: Allergy.all.take)
        customer_allergy.severity = allergy_severity
        customer_allergy.save!
        #end

        #add medications
        provider_id = Provider.all.take.id
        drug_id = Drug.all.take.id
        drug_date = Random.rand(1...3).years.ago
        type = ['Liquid', 'Tablet'].sample
        instructions = ['2 puffs once a day', '50mg bid with food'].sample
        rate_quantity = ['1/day', '2/day', '3/day'].sample
        dose_quantity = ['2/puffs', '50/mg', '1/puff', '30/mg'].sample
        Random.rand(2..3).times do
          c.medications.create(drug_id: drug_id, date: drug_date, instructions: instructions, medication_type: type, provider_id: provider_id, rate_quantity: rate_quantity, dose_quantity: dose_quantity)
        end

        #family medical histories
        name = Faker::Name.name
        relation = ['Brother', 'Daughter', 'Father', 'Mother', 'Son', 'Sister', 'Grandmother', 'Grandfather'].sample
        age = Random.rand(25..80)
        status = ['yes', 'no'].sample
        medical_condition_1 = ['​Rehabilitation of cardiac disease and treatment', 'Amputation/limb deficiency', 'Vestibular Conditions'].sample
        medical_condition_2 = ['Debility/Critical illness', 'Chronic Fatigue Syndrome'].sample
        medical_condition_3 = ['Cholecystectomy – specify open or laparoscopic', 'Blood patch, spinal or epidural'].sample
        c.family_medical_histories.create(name: name, relation: relation, age: age, status: status, medical_condition_1: medical_condition_1, medical_condition_2: medical_condition_2, medical_condition_3: medical_condition_3)

        #add guardians
        c.guardian_id = Customer.all.sample.id
        c.save!
      end
      Rake::Task['eKincare:health_assessments:build'].invoke
    end
    task drop: :environment do
      puts 'Deleting Customers ...'
      count = Customer.count
      CustomerAllergy.delete_all
      CustomerImmunization.delete_all
      FamilyMedicalHistory.delete_all
      Medication.delete_all
      Customer.all.destroy_all
      puts "#{count} Customers deleted"
      Rake::Task['eKincare:health_assessments:drop'].invoke
      puts 'done'
    end
  end

  namespace :health_assessments do
    task build: :environment do
      puts 'Creating assessments ...'
      Customer.all.each do |c|
        Random.rand(5..8).times do
          request_date = Random.rand(-25...60).days.ago
          assessment_type = ['Body', 'Dental', 'Vision'].sample
          paid = [true, false].sample
          package_type = ['General', 'Master', 'Executive'].sample
          status = ['requested', 'sample_collection', 'test_phase', 'test_results', 'update_emr', 'second_review', 'done'].sample

          HealthAssessment.create(request_date: request_date, assessment_type: assessment_type, paid: paid, customer_id: c.id, status: status, package_type: package_type)
        end
      end
    end
    task drop: :environment do
      puts 'Deleting assessments ...'
      count = HealthAssessment.count
      Note.delete_all
      MedicalRecord.delete_all
      HealthAssessment.destroy_all
      puts "#{count} Assessments deleted"
    end
  end

  namespace :staff do
    task build: :environment do
      email = 'staff@ekincare.com'
      name = 'kiran'
      Staff.create(name: name, password: 'testtest1', email: email)
      puts "#{email} created with password testtest1"
    end
    task drop: :environment do
      Staff.destroy_all
    end
  end
end

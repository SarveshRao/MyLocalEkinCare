require 'yaml'

# blood_groups = YAML.load(File.open(File.expand_path('db/blood_groups.yml')))
# puts 'seeding blood groups...'
# blood_groups.each do |key, value|
#   BloodGroup.find_or_create_by(blood_type: value['blood_type'])
# end
#
# allergies = YAML.load(File.open(File.expand_path('db/allergies.yml')))
# puts 'seeding allergies...'
# allergies.each do |key, value|
#   new_allergy = Allergy.find_or_create_by(name: value['name'])
#   new_allergy.reaction = value['reaction']
#   new_allergy.save
# end
#
# immunizations = YAML.load(File.open(File.expand_path('db/immunizations.yml')))
# puts 'seeding immunizations...'
# immunizations.each do |key, value|
#   new_immunization= Immunization.find_or_create_by(name: value['name'])
#   new_immunization.immunization_type = value['immunization_type']
#   new_immunization.save
# end
#
# drugs = YAML.load(File.open(File.expand_path('db/drugs.yml')))
# puts 'seeding drugs...'
# drugs.each do |key, value|
#   new_drug = Drug.find_or_create_by(name: value['name'])
#   new_drug.icd_code = value['icd_code']
#   new_drug.therepeutic_classification_type = value['therepeutic_classification_type']
#   new_drug.indian_names = value['indian_names']
#   new_drug.international_names = value['international_names']
#   new_drug.why_it_is_prescribed = value['why_it_is_prescribed']
#   new_drug.when_it_is_not_to_be_taken = value['when_it_is_not_to_be_taken']
#   new_drug.pregnancy_category = value['pregnancy_category']
#   new_drug.dosage_and_when_it_is_to_be_taken = value['dosage_and_when_it_is_to_be_taken']
#   new_drug.how_it_should_be_taken = value['how_it_should_be_taken']
#   new_drug.warnings_and_precautions = value['warnings_and_precautions']
#   new_drug.side_effects = value['side_effects']
#   new_drug.other_precautions = value['other_precautions']
#   new_drug.storage_conditions = value['storage_conditions']
#   new_drug.save
# end

#providers = YAML.load(File.open(File.expand_path('db/providers.yml')))
#puts 'seeding providers...'
#providers.each do |key, value|
#  if key['name']
#    provider = Provider.find_or_create_by(provider_id: key['provider_id'])
#    provider.name = key['name']
#    provider.telephone = key['telephone']
#    provider.provider_type = key['provider_type']
#    provider.branch = key['branch']
#    provider.poc = key['poc']
#    provider.offline_number = key['offline_number']
#    provider.email = key['email']
#    provider.save
#    key['addresses'].each do |k, v|
#      #a = Address.find_or_create_by_line1_and_city_and_state_and_country_and_zip_code(line1: k['line1'], city: k['city'], state: k['state'], country: k['country'], zip_code: k['zip_code'])
#      addr = provider.addresses.first
#      if provider.addresses.empty?
#        provider.addresses.create(line1: k['line1'], city: k['city'], state: k['state'], country: k['country'], zip_code: k['zip_code'])
#      else
#        addr.update(line1: k['line1'], city: k['city'], state: k['state'], country: k['country'], zip_code: k['zip_code'])
#        addr.save
#      end
#    end
#  end
#end

# lab_tests = YAML.load(File.open(File.expand_path('db/lab_tests.yml')))
# puts 'seeding lab tests...'
# lab_tests.each do |key, value|
#   new_lab_test = LabTest.find_or_create_by(name: key['name'])
#   key['test_components'].map do |k, v|
#     test_component = new_lab_test.test_components.find_or_create_by(name: k['name'])
#     test_component.units = k['units']
#     test_component.info = k['info']
#     test_component.save
#     test_component.standard_ranges.delete_all
#     k['standard_ranges'].map do |key, value|
#       #test_component.standard_ranges.find_or_create_by_gender_and_range_value_and_age_limit_and_age_male_range_value_and_age_female_range_value(gender: key['gender'], range_value: key['range_value'],
#       #  age_limit: key['age_limit'], age_male_range_value: key['age_male_range_value'], age_female_range_value: key['age_female_range_value'])
#       standard_range = test_component.standard_ranges.find_by(gender: key['gender'], range_value: key['range_value'], age_limit: key['age_limit'], age_male_range_value: key['age_male_range_value'], age_female_range_value: key['age_female_range_value'])
#       unless standard_range
#         existed_standard_range = test_component.standard_ranges.find_or_create_by(gender: key['gender'], age_limit: key['age_limit'])
#         existed_standard_range.update(gender: key['gender'], range_value: key['range_value'], age_limit: key['age_limit'], age_male_range_value: key['age_male_range_value'], age_female_range_value: key['age_female_range_value'])
#         existed_standard_range.save
#       end
#     end
#   end
# end

# medical_conditions=YAML.load(File.open(File.expand_path('db/medical_conditions.yml')))
# medical_conditions.each do |key,value|
#   medical_condition=MedicalCondition.create(name:value['name'])
# end


risk_factors = YAML.load(File.open(File.expand_path('db/risk_factors.yml')))
puts 'seeding risk factors...'
risk_factors.each do |key, value|
  new_risk_factor = RiskFactor.find_or_create_by(Name: value['Name'])
  new_risk_factor.save
end

message_prompts = YAML.load(File.open(File.expand_path('db/message_prompts.yml')))
puts 'seeding message prompts...'
message_prompts.each do |key, value|
  new_message_prompt = MessagePrompt.create(risk_factor_id: value['risk_factor_id'])
  new_message_prompt.range = value['range']
  new_message_prompt.message = value['message']
  new_message_prompt.image = value['image']
  new_message_prompt.gender = value['gender']
  new_message_prompt.save
end
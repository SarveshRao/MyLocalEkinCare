# dumping excel sheet lab results to db
require 'yaml'

task seed_health_score_inputs: :environment do
  if Rails.env.development?
  require 'rubyXL'

  puts 'delete lab tests, test components, standard ranges'
  StandardRange.delete_all
  TestComponent.delete_all
  LabTest.delete_all

  workbook = RubyXL::Parser.parse(File.expand_path('db/health_score_inputs.xlsx'))
  puts 'loading test components...'
  puts '________________________'

  worksheet = workbook[0]
  3.upto(59).each do |n|
    row = worksheet.sheet_data[n]
    test_name = row[1].value
    component_name = row[2].value

    m_nm_1 = row[3].value rescue ''
    m_nm_2 = row[4].value rescue ''
    m_gd_1 = row[5].value rescue ''
    m_bd_1 = row[6].value rescue ''
    m_bd_2 = row[7].value rescue ''

    fm_nm_1 = row[9].value rescue ''
    fm_nm_2 = row[10].value rescue ''
    fm_gd_1 = row[11].value rescue ''
    fm_bd_1 = row[12].value rescue ''
    fm_bd_2 = row[13].value rescue ''

    male_range_value = "#{m_nm_1}, #{m_nm_2}, #{m_gd_1}, #{m_bd_1}, #{m_bd_2}"
    female_range_value = "#{fm_nm_1}, #{fm_nm_2}, #{fm_gd_1}, #{fm_bd_1}, #{fm_bd_2}"
    #age_limit = row[3].value.gsub(/[years]/, '') rescue ''
    age_limit = ""
    age_male_range_value = male_range_value
    age_female_range_value = female_range_value
    #units = m_nm_2.gsub(/[0-9|>|<|=|.|+|to|-]*/, '')
    units = row[14].value
    info = row[15].value

    unless test_name.nil?
      @lab_test = LabTest.find_or_create_by(name: test_name)
    end

    unless component_name.nil?
      @test_component = @lab_test.test_components.find_or_create_by(name: component_name) do |test_component|
        test_component.units = units
        test_component.info = info
      end
    end

    if age_limit.empty?
      @test_component.standard_ranges.create(gender: 'M', range_value: male_range_value)
      @test_component.standard_ranges.create(gender: 'F', range_value: female_range_value)
    else
      @test_component.standard_ranges.create(gender: 'M', age_male_range_value: age_male_range_value, age_limit: age_limit)
      @test_component.standard_ranges.create(gender: 'F', age_female_range_value: age_female_range_value, age_limit: age_limit)
    end
    puts @test_component.name
  end

#lab_test_json
  lab_tests_json = LabTest.all.to_json(only: [:name, :test_components],
                                       include: {test_components: {only: [:name, :units, :info, :standard_ranges],
                                                                   include: {standard_ranges: {only: [:gender, :range_value, :age_limit, :age_male_range_value, :age_female_range_value]}}}})
  File.open(File.expand_path('db/lab_tests.json'), 'w') { |f| f.write lab_tests_json }
  else
    puts 'excel should be processed only on development'
  end
end

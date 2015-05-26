class TestComponent < ActiveRecord::Base
  include ApplicationHelper

  has_many :standard_ranges
  belongs_to :lab_test

  # def test_component_values customer
  #   component_lab_results = [0]
  #   customer.health_assessments.where(type: 'BodyAssessment').each do |body_assessment|
  #     body_assessment.lab_results.each do |lab_result|
  #       if lab_result.test_component_id == self.id
  #         component_lab_results << lab_result.result.to_i
  #       end
  #     end
  #   end
  #   component_lab_results.map(&:inspect).join(', ')
  # end

  def test_component_values customer
    component_results=self.aux_test_component_values customer
    component_results.map(&:inspect).join(', ')
  end

  def lab_result_increased? customer
    begin
      component_results=self.aux_test_component_values customer
      len=component_results.length
      if(component_results[len-2].to_i<component_results[len-1])
        return true
      end
    rescue
      return false
    end
    return false
  end

  def aux_test_component_values customer
    component_lab_results = []
    customer.health_assessments.where(type: 'BodyAssessment').each do |body_assessment|
      body_assessment.lab_results.each do |lab_result|
        lonic_code = TestComponent.find(lab_result.test_component_id).lonic_code rescue nil
        if lonic_code
          if lonic_code == self.lonic_code
            component_lab_results << lab_result.result.to_f
          end
        else
          if lab_result.test_component_id == self.id
            component_lab_results << lab_result.result.to_f
          end
        end
      end
    end
    component_lab_results=component_lab_results.reverse
  end

  def standard_range assessment
    customer = assessment.customer
    self.standard_ranges.collect { |standard_range| customer_standard_ranges(customer, standard_range, true) }.flatten.compact.join("").html_safe
  end

  def customer_component_age_info customer
    self.standard_ranges.each do |standard_range|
      if customer.gender == standard_range.gender
        if standard_range.age_limit && eval("#{customer.age['year']} #{standard_range.age_limit.gsub(/[years\s]/, '')}")
          return {sid: standard_range.id, exist: true}
        end
      end
    end
    {sid: '', exist: false}
  end

  def customer_component_age_exist customer
    component_info = customer_component_age_info(customer)
    component_info[:exist]
  end

  def customer_standard_range_age_exist customer, standard_range
    result = customer_component_age_info customer
    standard_range.id == result[:sid]
  end

  def customer_standard_ranges customer, standard_range, colorize
    customer_gender = customer.gender.chars.first rescue 'M'
    customer_gender=customer_gender.upcase
    if customer_gender == standard_range.gender
      if standard_range.age_limit && eval("#{customer.age['year']} #{standard_range.age_limit.gsub(/[years\s]/, '')}") && customer_standard_range_age_exist(customer, standard_range)
        range_value = customer_gender == 'M' ? standard_range.age_male_range_value : standard_range.age_female_range_value
        range_split_value = range_value.split(',')
        normal_range = range_value
      elsif !customer_component_age_exist(customer) && !is_empty?(standard_range.age_limit)
        range_value = default_value customer_gender
        range_split_value = range_value.split(',')
        normal_range = range_split_value[0].empty? ? range_split_value[1] : range_split_value[0]
      elsif is_empty?(standard_range.age_limit) && !standard_range.range_value.nil?
        range_value = standard_range.range_value
        range_split_value = range_value.split(',')
        normal_range = range_split_value[0].empty? ? range_split_value[1] : range_split_value[0]
      elsif standard_range.range_value.nil?

      end
      puts "#{colorize ? standard_range.colorize_ranges(range_split_value) : {ranges: range_split_value, normal_range: normal_range}} ********************************"
      colorize ? standard_range.colorize_ranges(range_split_value) : {ranges: range_split_value, normal_range: normal_range}
    end
  end

  def default_value gender
    standard_range = self.standard_ranges.where("age_limit = ? AND gender = ?", '', gender).first
    range_value = gender == 'M' ? standard_range.age_male_range_value : standard_range.age_female_range_value
  end

  def self.search(search)
    if search.nil? || search.empty?
      self.joins(:standard_ranges)
                      .select("test_components.name as test_component_name", "test_components.info as test_component_info", "test_components.lonic_code as test_component_lonic_code", "standard_ranges.*")
                      .order('test_components.name ASC')
    else
      self.joins(:standard_ranges)
          .select("test_components.name as test_component_name", "test_components.info as test_component_info", "test_components.lonic_code as test_component_lonic_code", "standard_ranges.*")
          .where("LOWER(name) LIKE :search" , search: "%#{search.downcase}%")
          .order('test_components.name ASC')
    end
  end

  def self.search_lab_test(lab_test_id, search)
    if search.nil? || search.empty?
      self.joins(:standard_ranges)
          .where("lab_test_id = " + lab_test_id)
          .select("test_components.name as test_component_name", "test_components.info as test_component_info", "test_components.lonic_code as test_component_lonic_code", "standard_ranges.*")
          .order('test_components.name ASC')
    else
      self.joins(:standard_ranges)
          .select("test_components.name as test_component_name", "test_components.info as test_component_info", "test_components.lonic_code as test_component_lonic_code", "standard_ranges.*")
          .where("LOWER(name) LIKE :search" , search: "%#{search.downcase}%")
          .where("lab_test_id = " + lab_test_id)
          .order('test_components.name ASC')
    end
  end

  def lab_results_with_dates customer
    lab_results = {}
    customer.health_assessments.where(type: 'BodyAssessment').each do |body_assessment|
      body_assessment.lab_results.each do |lab_result|
        if lab_result.test_component_id == self.id
          lab_results[lab_result.created_at] = lab_result.result.to_i
        end
      end
    end
    reversed_lab_results = Hash[lab_results.to_a.reverse]
  end

end

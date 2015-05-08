class LabResult < ActiveRecord::Base
  include ApplicationHelper

  belongs_to :body_assessment
  belongs_to :test_component

  default_scope { order('updated_at DESC') }

  def customer
    self.body_assessment.customer
  end

  def test_component_ranges_diff
    {diff: test_component_eval.abs, name: self.test_component.name, value: self.result, bad_range: is_bad_range_component?, color: colored_value, units: self.test_component.units, date: self.created_at, lab_test: self.test_component.lab_test, lab_result: self}
  end

  def info
    {test_component_diff: test_component_ranges_diff, test_component: self.test_component}
  end

  def is_bad_range_component?
    return false if self.result.empty?
    component_ranges = test_component.standard_ranges.collect { |standard_range| test_component.customer_standard_ranges(customer, standard_range, false) }.compact.flatten
    component_ranges = component_ranges.select { |cr| !cr[:ranges].nil? }
    if !component_ranges.empty?
      parse_ranges = parse component_ranges.first[:ranges]
      return !(parse_ranges[0] == true || parse_ranges[1] == true)
    end
  end

  def test_component_range_finder
    component_ranges = test_component.standard_ranges.collect { |standard_range| test_component.customer_standard_ranges(customer, standard_range, false) }.compact.flatten
    component_ranges = component_ranges.select { |cr| !cr[:ranges].nil? }

    if !component_ranges.empty?
      parse_ranges = parse component_ranges.first[:ranges]
      component_customer_range = ''
      parse_ranges.each_with_index do |range, index|
        if range
          component_customer_range = component_ranges.first[:ranges][index]
        end
      end
    end
    return {customer_range: component_customer_range, normal_range: component_ranges.first[:normal_range]}
  end

  def test_component_eval
    result = self.result.gsub(/[\=\+\/\(\)a-zA-Z\s\%\u03bc]*/, '')
    unless result.empty?
      normal_range = test_component_range_finder[:normal_range]

      if !normal_range.nil? || normal_range =~ /[0-9]+/
        compare_literal_nums = normal_range.gsub(/[\-\+\=\/\(\)a-zA-Z\s\%\u03bc]*/, '')
        normal_cst_range_literals = normal_range.gsub(/[0-9\+\/\(\)a-zA-Z\s\%\u03bc]*/, '')
        if normal_cst_range_literals =~ /[-]+/
          diff = comp_between_diff(/[\>\<\+\/\(\)a-zA-Z\s\%\u03bc]*/, /[-]/, normal_range)
        elsif normal_cst_range_literals =~ /[><]+/ && normal_cst_range_literals.length > 1
          diff = comp_between_diff(/[\+\/\(\)a-zA-Z\s\%\u03bc]*/, /[><]/, normal_range)
        elsif normal_cst_range_literals =~ /[>]+/
          if !eval("#{result} #{compare_literal_nums}")
            value = compare_literal_nums.gsub(/[\>\<\s\%\u03bc]*/, '')
            diff = eval("#{result}-#{value}")
          end
        elsif normal_cst_range_literals =~ /[<]+/
          if !eval("#{result} #{compare_literal_nums}")
            value = compare_literal_nums.gsub(/[\>\<\s\%\u03bc]*/, '')
            diff = eval("#{value}-#{result}")
          end
        else
        end

        if !(normal_range =~ /[0-9]+/) && !normal_range.nil?
          is_bound_range = result.downcase.strip == normal_range.downcase.strip
          diff = is_bound_range ? 0 : 1
        end
      end
    end
    return diff || 0
  rescue Exception
    0
  end

  def find_nearest_value min, max
    begin
      if self.result < min
        diff = eval("#{min}-#{self.result}")
      elsif max < self.result
        diff = eval("#{self.result}-#{max}")
      else
        diff = 0
      end
    rescue Exception
      diff = 0
    end
    diff
  end

  def comp_between_diff exp, sec_opt, normal_range
    compare_literal_nums = normal_range.gsub(exp, '')
    eval_values = compare_literal_nums.split(sec_opt).compact.sort_by { |a, b| a <=> b }
    min_val, max_val= eval_values[0], eval_values[1]
    find_nearest_value min_val, max_val
  end

  def comp_between exp, sec_opt, range
    compare_literal_nums = range.gsub(exp, '')
    eval_values = compare_literal_nums.split(sec_opt).compact.sort_by { |a, b| a <=> b }
    min_val, max_val = eval_values[0].to_f, eval_values[1].to_f
    status = self.result.to_f.between?(min_val, max_val)
    status
  end

  def comp_plus_or_minus compare_literals, range
    if compare_literals =~ /[\-|\+]/
      compare_literal_nums = range.gsub(/[\-\>\<\+\/\(\)a-zA-Z\s\%\u03bc]*/, '')
      if compare_literals =~ /\-/
        status = eval("#{self.result} < #{compare_literal_nums}")
      end
      if compare_literals =~ /\+/
        status = eval("#{self.result} > #{compare_literal_nums}")
      end
    end
    return status
  end

  def parse ranges
    # range_eles_status = []
    # result_val = self.result.gsub(/[\=\+\/\(\)a-zA-Z\s\%\u03bc]*/, '')
    # if !is_empty?(result_val) && !ranges.nil? && !ranges.empty?
    #   ranges.each do |current_standard_range|
    #     begin
    #       compare_literal_nums = current_standard_range.gsub(/[\=\+\/\(\)a-zA-Z\s\%\u03bc]*/, '')
    #       compare_literals = current_standard_range.gsub(/[0-9\+\/\.\(\)a-zA-Z\s\%\u03bc]*/, '')
    #       if current_standard_range =~ /[0-9]+/
    #         if compare_literals =~ /\-/
    #           status = comp_between(/[\>\<\+\=\/\(\)a-zA-Z\s\%\u03bc]*/, /\-/, current_standard_range)
    #         else
    #           if compare_literals =~ /[\>\<]+/
    #             status = comp_between(/[\-\+\=\/\(\)a-zA-Z\s\%\u03bc]*/, /[><]/, current_standard_range)
    #           end
    #           compare_literals.gsub!(/\=/, '')
    #           if compare_literals =~ /[\>|\<]+/
    #             status = eval("#{result_val} #{compare_literal_nums}")
    #           end
    #           compare_literals = current_standard_range.gsub(/[0-9\>\<\=\/\.\(\)a-zA-Z\s\%\u03bc]*/, '')
    #           if compare_literals =~ /[\-|\+]+/
    #             status = comp_plus_or_minus compare_literals, current_standard_range
    #           end
    #         end
    #         compare_literals = current_standard_range.gsub(/[\>\<\+\/\(\)a-zA-Z\s\%\u03bc]*/, '')
    #         if status == false && compare_literals =~ /\=/
    #           result_exp = Regexp.new(result_val)
    #           status = current_standard_range =~ result_exp
    #         end
    #       else
    #         status = (current_standard_range.downcase.strip == result_val.downcase.strip)
    #       end
    #     rescue Exception
    #       status = false
    #     end
    #     range_eles_status.push(status)
    #   end
    # end
    # range_eles_status

    range_eles_status = []
    result_val = self.result
    if !is_empty?(result_val) && !ranges.nil? && !ranges.empty?
      ranges.each do |current_standard_range|
        status = false
        begin
          current_standard_range = current_standard_range.gsub(" ", "")
          isDigitPresent = /\d/.match(result_val)
          if !isDigitPresent.nil?
            result_val = result_val.gsub(/[^0-9. ]/i, '')
            current_standard_range = current_standard_range.gsub(/[^0-9.<>=+\u002d\u2013]/i, '')
            if !/^<=/.match(current_standard_range).nil?
              if current_standard_range.split("<=")!=-1
                current_standard_range = current_standard_range.split("<=")[1]
              end
              if result_val.to_f <= current_standard_range.to_f
                status = true
              end
            elsif !/^</.match(current_standard_range).nil?
              if current_standard_range.split("<")!=-1
                current_standard_range = current_standard_range.split("<")[1]
              end
              if result_val.to_f < current_standard_range.to_f
                status = true
              end
            elsif !/^>=/.match(current_standard_range).nil?
              if current_standard_range.split(">=")!=-1
                current_standard_range = current_standard_range.split(">=")[1]
              end
              if result_val.to_f >= current_standard_range.to_f
                status = true
              end
            elsif !/^>/.match(current_standard_range).nil?
              if current_standard_range.split(">")!=-1
                current_standard_range = current_standard_range.split(">")[1]
              end
              if result_val.to_f > current_standard_range.to_f
                status = true
              end
            elsif !/\+$/.match(current_standard_range).nil?
              if current_standard_range.split("+")!=-1
                current_standard_range = current_standard_range.split("+")[0]
              end
              if result_val.to_f > current_standard_range.to_f
                status = true
              end
            elsif !/[\u002d,\u2013]+/.match(current_standard_range).nil?
              if current_standard_range.split(/[\u002d,\u2013]+/)!=-1
                current_standard_range_array = current_standard_range.split(/[\u002d,\u2013]+/)
              end
              if result_val.to_f >= current_standard_range_array[0].to_f and result_val.to_f <= current_standard_range_array[1].to_f
                status = true
              end
            else
              if result_val.to_f == current_standard_range.to_f
                status = true
              end
            end
          else
            result_val = result_val.downcase.gsub(/[^a-z]/i, '')
            if current_standard_range.downcase == result_val
              status = true
            end
          end
        rescue Exception
          status = false
        end
        range_eles_status.push(status)
      end
    end
    range_eles_status
  end

  def colored_value
    colors = ['text-danger', 'text-success', 'text-warning', 'text-danger', 'text-danger']
    customer = self.body_assessment.customer
    standard_ranges = self.test_component.standard_ranges.map { |standard_range| self.test_component.customer_standard_ranges(customer, standard_range, false) }.compact.flatten
    standard_ranges = standard_ranges.select { |cr| !cr[:ranges].nil? }
    if !standard_ranges.empty?
      result_values = parse standard_ranges.first[:ranges]
      result_values.each_with_index do |value, index|
        if value == true
          return colors[index]
        end
      end
      return colors[0]
    end
    return colors[0]
  end

end


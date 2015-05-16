class Examination < ActiveRecord::Base
  has_many :results
  belongs_to :dental_assessment

  def self.tooth_numbers
    tooth_json = {11 => 18, 21 => 28, 31 => 38, 41 => 48, 51 => 55, 61 => 65, 71 => 75, 81 => 85}
    tooth_numbers = tooth_json.map do |k, v|
      k.upto(v).to_a
    end
    tooth_numbers.flatten
  end

  def self.notation dentition, tooth_number
    begin
      dentition_type = {Permanent: {ul: {21 => 28}, ur: {11 => 18}, ll: {31 => 38}, lr: {41 => 48}},
                        Primary: {ul: {61 => 65}, ur: {51 => 55}, ll: {71 => 75}, lr: {81 => 85}}}
      dentition_type[dentition.to_sym].map do |notation, tooth_range|
        tooth_range.map do |min, max|
          if min.upto(max).to_a.include? tooth_number
            return notation.to_s.upcase
          end
        end
      end
      return nil
    rescue
      nil
    end
  end

  def self.tooth_numbers_type dentition
    if dentition == 'Primary'
      tooth_json = {51 => 55, 61 => 65, 71 => 75, 81 => 85}
    else
      tooth_json = {11 => 18, 21 => 28, 31 => 38, 41 => 48}
    end
    tooth_numbers = tooth_json.map do |k, v|
      k.upto(v).to_a
    end
    tooth_numbers.flatten
  end

  def self.tooth_type tooth_number
    unit_val = tooth_number%10
    'incisor' if [1, 2].include? unit_val
    'canine' if 3 == unit_val
    'premolar' if [4, 5].include? unit_val
    'molar' if [6, 7, 8].include? unit_val
  end

  def self.tooth_types
    ['Primary', 'Permanent']
  end

  def dental_infected_results
    self.results.map do |result|
      {diff: 1, name: "Dental Tooth Number", value: result.tooth_number, bad_range: true}
    end
  end
end

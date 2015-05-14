class BodyAssessment < HealthAssessment
  has_many :lab_results

  def categorize_components
    categorized_test_components = self.lab_results.group_by { |lr| lr.test_component.lab_test.name } rescue nil
  end
end

class AddHeightAndWeightAndNumberOfChildfChildrenAndDailyActivityAndFrequencyOfExerciseAndBloodIdAndSmokeAndAlcoholAndMedicalInsuranceToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :height, :string
    add_column :customers, :weight, :string
    add_column :customers, :number_of_children, :integer
    add_column :customers, :daily_activity, :string
    add_column :customers, :frequency_of_exercise, :string
    add_column :customers, :smoke, :string
    add_column :customers, :alcohol, :string
    add_column :customers, :medical_insurance, :string
  end
end

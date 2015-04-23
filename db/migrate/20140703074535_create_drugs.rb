class CreateDrugs < ActiveRecord::Migration
  def change
    create_table :drugs do |t|
      t.string :name
      t.string :icd_code
      t.string :therepeutic_classification_type
      t.string :indian_names
      t.string :international_names
      t.text :why_it_is_prescribed
      t.text :when_it_is_not_to_be_taken
      t.string :pregnancy_category
      t.text :dosage_and_when_it_is_to_be_taken
      t.text :how_it_should_be_taken
      t.text :warnings_and_precautions
      t.text :side_effects
      t.text :other_precautions
      t.text :storage_conditions

      t.timestamps
    end
  end
end

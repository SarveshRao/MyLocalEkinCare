class VitalListDataInsertion < ActiveRecord::Migration
  def change
    execute("insert into vital_lists(name) values('weight');")
    execute("insert into vital_lists(name) values('feet');")
    execute("insert into vital_lists(name) values('inches');")
  end
end

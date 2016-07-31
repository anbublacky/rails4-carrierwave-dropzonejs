class AddImagefileToStudents < ActiveRecord::Migration
  def change
    add_column :students, :imagefile, :json
  end
end

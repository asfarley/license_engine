class AddTypeToProgram < ActiveRecord::Migration[6.0]
  def change
    add_column :programs, :type, :string
  end
end

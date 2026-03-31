class AddBinaryInputToPrograms < ActiveRecord::Migration[6.0]
  def change
    add_column :programs, :binary_input, :binary, limit: 5.megabytes
  end
end

class AddOriginalFilenameStringToPrograms < ActiveRecord::Migration[6.0]
  def change
    add_column :programs, :original_filename, :string
  end
end

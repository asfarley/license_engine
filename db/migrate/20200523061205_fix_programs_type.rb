class FixProgramsType < ActiveRecord::Migration[6.0]
  def change
    change_column :programs, :type, 'integer USING CAST(type AS integer)'
    rename_column :programs, :type, :program_type
  end
end

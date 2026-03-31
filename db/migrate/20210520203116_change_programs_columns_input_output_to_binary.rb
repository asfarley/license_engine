class ChangeProgramsColumnsInputOutputToBinary < ActiveRecord::Migration[6.0]
  def change
    change_column :programs, :input, 'bytea USING convert_to(input,\'UTF8\')'
  end
end
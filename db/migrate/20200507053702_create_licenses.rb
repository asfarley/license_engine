class CreateLicenses < ActiveRecord::Migration[6.0]
  def change
    create_table :licenses do |t|
      t.string :name
      t.belongs_to :company, null: false, foreign_key: true
      t.string :type

      t.timestamps
    end
  end
end

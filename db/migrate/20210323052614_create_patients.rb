class CreatePatients < ActiveRecord::Migration[6.1]
  def change
    create_table :patients do |t|
      t.string :first_name
      t.string :last_name
      t.string :id_number
      t.string :phone_mobile
      t.string :gender
      t.date   :date_of_birth


      t.timestamps
    end
  end
end

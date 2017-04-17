class AddAddressModel < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses, id: :uuid, default: "gen_random_uuid()" do |t|
      t.uuid     "author_id"
      t.string   "name"
      t.string   "abbreviation"
      t.string   "description"
      t.string   "accessibility_info"
      t.string   "address_1"
      t.string   "address_2"
      t.string   "space"
      t.string   "city"
      t.string   "state"
      t.string   "zip_code"
      t.string   "country"
      t.string   "time_zone", default: "Central Time (US & Canada)"
      t.string   "phone_number"
      t.float    "latitude"
      t.float    "longitude"
      t.string   "website_url"
      t.string   "admin_notes"
      t.boolean  "archived", default: false
      t.boolean  "test", default: false
      t.boolean  "dummy", default: false
      t.timestamps
    end
  end
end

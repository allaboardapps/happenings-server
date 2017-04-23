class AddingHappeningModel < ActiveRecord::Migration[5.0]
  def change
    create_table :happenings, id: :uuid, default: "gen_random_uuid()" do |t|
      t.string   "happening_type"
      t.uuid     "author_id"
      t.string   "name"
      t.string   "abbreviation"
      t.string   "description"
      t.string   "admin_notes"
      t.jsonb    "data"
      t.boolean  "archived", default: false
      t.boolean  "test", default: false
      t.boolean  "dummy", default: false
      t.timestamps
    end
  end
end

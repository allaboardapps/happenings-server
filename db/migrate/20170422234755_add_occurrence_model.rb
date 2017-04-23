class AddOccurrenceModel < ActiveRecord::Migration[5.0]
  def change
    create_table :happenings, id: :uuid, default: "gen_random_uuid()" do |t|
      t.uuid     "happening_id"
      t.datetime "starts_at"
      t.datetime "ends_at"
      t.jsonb    "data"
      t.boolean  "archived", default: false
      t.boolean  "test", default: false
      t.boolean  "dummy", default: false
      t.timestamps
    end
  end
end

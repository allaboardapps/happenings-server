ActiveAdmin.register Occurrence do
  menu parent: "Inventory", priority: 2000

  actions :all, except: [:new, :create, :destroy]

  permit_params :happening_id, :starts_at, :ends_at, :archived, :test, :dummy

  controller do
    def scoped_collection
      super.includes(:happening)
    end
  end

  scope :actives, default: true
  scope :archives
  scope :tests
  scope :dummies

  config.sort_order = "updated_at desc"

  filter :id_eq, label: "UUID"
  filter :starts_at
  filter :ends_at
  filter :archived
  filter :test
  filter :dummy
  filter :updated_at
  filter :created_at

  index do
    selectable_column
    column "Short ID" do |occurrence|
      humanize_uuid(uuid: occurrence.id, length: 8, elipsis: false)
    end
    column "Happening" do |occurrence|
      link_to happening.id, admin_happening_path(occurrence.happening)
    end
    column :starts_at
    column :ends_at
    column "Updated", sortable: "updated_at" do |occurrence|
      Time.use_zone("Central Time (US & Canada)") do
        occurrence.updated_at.in_time_zone.strftime("%m-%d-%y")
      end
    end
    actions
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :starts_at
      f.input :ends_at
      f.input :archived
      f.input :test
      f.input :dummy
    end
    f.actions
  end

  show do |occurrence|
    attributes_table do
      row "Short ID" do
        humanize_uuid(uuid: occurrence.id, length: 8, elipsis: false)
      end
      row :id
      row :starts_at
      row :ends_at
      row :archived
      row :test
      row :dummy
      row :updated_at
      row :created_at
    end
  end
end

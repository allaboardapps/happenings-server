ActiveAdmin.register Address do
  menu parent: "Inventory", priority: 3000

  actions :all, except: [:new, :create, :destroy]

  permit_params :name, :abbreviation, :description, :accessibility_info, :space,
    :address_1, :address_2, :city, :state, :zip_code, :country, :latitude, :longitude,
    :time_zone, :phone_number, :website_url, :admin_notes,
    :archived, :test, :dummy

  controller do
    def scoped_collection
      super.includes(:author)
    end
  end

  scope :actives, default: true
  scope :archives
  scope :tests
  scope :dummies

  config.sort_order = "updated_at desc"

  filter :id_eq, label: "UUID"
  filter :name
  filter :author_last_name
  filter :address_1
  filter :city
  filter :state
  filter :zip_code
  filter :archived
  filter :test
  filter :dummy
  filter :updated_at
  filter :created_at

  index do
    selectable_column
    column "Short ID" do |address|
      humanize_uuid(uuid: address.id, length: 8, elipsis: false)
    end
    column "Author", sortable: "author.last_name"  do |address|
      link_to address.author.full_name, admin_user_path(address.author)
    end
    column "Address" do |address|
      Time.use_zone("Central Time (US & Canada)") do
        if address.address_2.present?
         "#{address.address_1}, #{address.address_2}"
        else
          address.address_1
        end
      end
    end
    column "Locale" do |address|
      "#{address.city}, #{address.state}, #{address.zip_code}"
    end
    # column "Web" do |address|
    #   link_to "GMap", google_map_url(address), target: "_blank"
    # end
    column "Updated", sortable: "updated_at" do |address|
      Time.use_zone("Central Time (US & Canada)") do
        address.updated_at.in_time_zone.strftime("%m-%d-%y")
      end
    end
    actions
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :name
      f.input :abbreviation
      f.input :description
      f.input :accessibility_info
      f.input :address_1
      f.input :address_2
      f.input :space
      f.input :city
      f.input :state
      f.input :zip_code
      f.input :country
      f.input :latitude
      f.input :longitude
      f.input :time_zone
      f.input :phone_number
      f.input :website_url
      f.input :admin_notes
      f.input :archived
      f.input :test
      f.input :dummy
    end
    f.actions
  end

  show do |address|
    attributes_table do
      row "Short ID" do
        humanize_uuid(uuid: address.id, length: 8, elipsis: false)
      end
      row :id
      row "Author", sortable: "author.last_name" do
        link_to address.author.full_name, admin_user_path(address.author)
      end
      row :name
      row :abbreviation
      row :description
      row :accessibility_info
      row :address_1
      row :address_2
      row :space
      row :city
      row :state
      row :zip_code
      row :country
      row :latitude
      row :longitude
      row :time_zone
      row :phone_number
      row :website_url do
        link_to address.website_url, address.website_url, target: "_blank"
      end
      row :admin_notes
      row :archived
      row :test
      row :dummy
      row :updated_at
      row :created_at
    end
  end
end

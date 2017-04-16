ActiveAdmin.register User do
  menu parent: "Users", priority: 100

  actions :all, except: [:new, :create, :destroy]

  permit_params :first_name, :last_name, :email, :roles, :statuses, :archived, :test, :dummy

  scope :actives, default: true
  scope :inactives
  scope :customers
  scope :admins
  scope :staffers
  scope :archives
  scope :tests
  scope :dummies

  config.sort_order = "lower(last_name) asc, lower(first_name) asc, created_at desc"

  filter :id_eq, label: "ID"
  filter :email_contains, as: :string, label: "Email"
  filter :first_name_contains
  filter :last_name_contains
  filter :roles, as: :check_boxes, collection: ->{ UserRoles.all }
  filter :statuses, as: :check_boxes, collection: ->{ UserStatuses.all }
  filter :archived
  filter :test
  filter :dummy
  filter :created_at

  index do
    selectable_column
    column "Short ID" do |user|
      humanize_uuid(uuid: user.id, length: 8, elipsis: false)
    end
    column :email, sortable: "users.email"  do |user|
      mail_to user.email, user.email
    end
    column :first_name
    column :last_name
    column "Roles" do |user|
      user.roles.join(", ")
    end
    column "Status" do |user|
      user.statuses.join(", ")
    end
    column "Updated", sortable: "users.updated_at" do |user|
      Time.use_zone(AllowedTimeZones::CENTRAL) do
        user.updated_at.in_time_zone.strftime("%m-%d-%y")
      end
    end
    actions
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :roles
      f.input :statuses
      f.input :archived
      f.input :test
      f.input :dummy
    end
    f.actions
  end

  show do |user|
    attributes_table do
      row "Short ID" do
        humanize_uuid(uuid: user.id, length: 8, elipsis: false)
      end
      row :id
      row :email
      row :first_name
      row :last_name
      row "Roles" do
        user.roles_presented
      end
      row "Statuses" do
        user.statuses_presented
      end
      row :archived
      row :test
      row :dummy
      row :updated_at
      row :created_at
    end
  end
end


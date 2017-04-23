ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Inventory" do
          ul do
            li link_to "Happenings", admin_happenings_path
            li link_to "Occurrences", admin_occurrences_path
            li link_to "Addresses", admin_addressess_path
          end
        end
        panel "System" do
          ul do
            li link_to "Users", admin_users_path
          end
        end
      end
      column do
        panel "Tech" do
          ul do
            # li link_to "HireFire Monitoring", "/hirefire/#{ENV['HIREFIRE_TOKEN']}/info", target: "_blank" if current_user.admin? && Rails.env.production?
            # li link_to "HireFire Monitoring", "/hirefire/development/info", target: "_blank" if current_user.admin? && Rails.env.development?
            # li link_to "Letter Opener Console", "/letter_opener", target: "_blank" if Rails.env.development?
            li link_to "Rails DB Dashboard", rails_db_path, target: "_blank" if current_user.admin? && Rails.env.development?
            li link_to "Sidekiq Dashboard", sidekiq_web_path, target: "_blank" if current_user.admin?
          end
        end
      end
    end
  end # content
end

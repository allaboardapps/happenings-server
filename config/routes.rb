Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users
  root "static#index"

  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web, at: "/sidekiq"
  end
end

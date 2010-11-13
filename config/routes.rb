Rails.application.routes.draw do
  get  "/contents/edit",   :as => :edit_content
  post "/contents/update", :as => :update_content
end

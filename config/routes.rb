EmailList::Application.routes.draw do
  resources :recipients, only: [:new, :create, :index]
  root to: "recipients#new"
end

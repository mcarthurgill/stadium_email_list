EmailList::Application.routes.draw do
  resources :recipients, only: [:new, :create]
  root to: "recipients#new"
end

Rails.application.routes.draw do
  root to: 'statics#home'

  devise_for :users, controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations'
                     }
end

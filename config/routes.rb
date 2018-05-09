Rails.application.routes.draw do
  get    'log_in'  => 'sessions#new',     as: 'log_in'
  delete 'log_out' => 'sessions#destroy', as: 'log_out'
  get    'sign_up' => 'users#new',        as: 'sign_up'

  root to: 'statics#home'

  resources :users
  resources :notebooks do
    resources :child_sections, only: [:new, :create]
    resources :sections do
      resources :notices
    end
  end
  resources :sessions
  resources :password_resets

  # TODO: REMOVE LATER!
  get 'check_ip' => 'check_ip#index'
  get 'fun_captcha' => 'fun_captcha#index'
end

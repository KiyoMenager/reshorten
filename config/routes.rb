Rails.application.routes.draw do
  scope path: 'api' do
    resources :links, only: [:show, :create, :update, :destroy], param: :short_code
  end
end

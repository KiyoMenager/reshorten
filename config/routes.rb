Rails.application.routes.draw do
  get '/:short_code', to: 'redirections#show'

  scope path: 'api' do
    resources :links, only: [:show, :create, :update, :destroy], param: :short_code
  end
end

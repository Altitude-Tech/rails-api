Rails.application.routes.draw do
	match '/api', to: 'api#create', via: :post
	match '/api', to: 'api#index', via: :get
	match '/api', to: 'api#ignore', via: [:put, :patch, :delete]
end

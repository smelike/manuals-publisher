Rails.application.routes.draw do

  get '/healthcheck', :to => proc { [200, {}, ['OK']] }

  resources :documents, path: "/:document_type", except: :destroy do
    resources :attachments, only: [:new, :create, :edit, :update]

    post :withdraw, on: :member
    post :publish, on: :member
  end

  root 'documents#index'
end

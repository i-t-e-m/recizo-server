Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope :api do
    namespace :recent do
      get '', to: 'apis#index'

      get 'kyabetsu', to: 'apis#kyabetsu'
      get 'negi', to: 'apis#negi'
      get 'hakusai', to: 'apis#hakusai'
      get 'hourensou', to: 'apis#hourensou'
      get 'retasu', to: 'apis#retasu'
      get 'tamanegi', to: 'apis#tamanegi'
      get 'burokkori', to: 'apis#burokkori'
      get 'kyuri', to: 'apis#kyuri'
      get 'tomato', to: 'apis#tomato'
      get 'nasu', to: 'apis#nasu'
      get 'piman', to: 'apis#piman'
      get 'daikon', to: 'apis#daikon'
      get 'ninjin', to: 'apis#ninjin'
      get 'satoimo', to: 'apis#satoimo'
      get 'jagaimo', to: 'apis#jagaimo'
    end

    namespace :past do
      get '', to: 'apis#index'

      get 'kyabetsu', to: 'apis#kyabetsu'
      get 'negi', to: 'apis#negi'
      get 'hakusai', to: 'apis#hakusai'
      get 'hourensou', to: 'apis#hourensou'
      get 'retasu', to: 'apis#retasu'
      get 'tamanegi', to: 'apis#tamanegi'
      get 'burokkori', to: 'apis#burokkori'
      get 'kyuri', to: 'apis#kyuri'
      get 'tomato', to: 'apis#tomato'
      get 'nasu', to: 'apis#nasu'
      get 'piman', to: 'apis#piman'
      get 'daikon', to: 'apis#daikon'
      get 'ninjin', to: 'apis#ninjin'
      get 'satoimo', to: 'apis#satoimo'
      get 'jagaimo', to: 'apis#jagaimo'
    end
  end
end

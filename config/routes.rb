Rails.application.routes.draw do
  resources :configuracaos

  get 'administracao/listagem_funcionarios'
  get 'administracao/criar_funcionario'
  get 'administracao/editar_funcionario'
  post 'administracao/salvar_funcionario'
  post 'administracao/atualizar_funcionario'
  get 'administracao/detalhes_funcionario'
  get 'administracao/relatorio_quantitativo_professor'
  get 'administracao/relatorio_quantitativo'
  get 'administracao/relatorio_nominal_geral'
  get "administracao/autocomplete_local_nome"
  get "administracao/relatorio_sem_cadastro"

      devise_for :usuarios#, :controllers => {:registrations => "registrations"}
      resources :funcionarios do
        get :autocomplete_local_nome,:on=>:collection
        get :funcionario_professor
      end


      scope "/admin", as: "admin" do
        resources :disciplinas
        resources :usuarios do
          get :autocomplete_local_nome,:on=>:collection
        end
        resources :locals do
          get 'resumo_escola'
        end
      end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable
  get '/', :to => 'administracao#listagem_funcionarios',:constraints => lambda{|req| req.env['warden'].user.try(:editor?)}
  get '/', :to => 'administracao#listagem_funcionarios',:constraints => lambda{|req| req.env['warden'].user.try(:gestor_seed?)}
  get '/', :to => 'administracao#listagem_funcionarios',:constraints => lambda{|req| req.env['warden'].user.try(:admin?)}
  root :to => 'funcionarios#index'

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

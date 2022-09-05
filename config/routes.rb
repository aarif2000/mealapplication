Rails.application.routes.draw do
  devise_for :users,
  controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
  }
  namespace :users do 
   resources :users, path: '/', except: %i[create] 
  end

  resources :recipes, controller: 'hotels/recipes'
  resources :plans, controller: 'hotels/plans'
  get 'hotel/plans/:id/buy', to:'hotels/plans#buy_plan', as:'buy_plan'
  get 'hotel/plans/active_users', to: 'hotels/plans#active_users'
  get 'hotel/plans/:id/users_activated', to:'hotels/plans#users_activated'



end

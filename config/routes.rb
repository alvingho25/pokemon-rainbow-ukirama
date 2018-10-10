Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#home'
  get '/heal', to: 'pokemons#healall'
  get '/heal/:id', to: 'pokemons#heal', as: 'heal_pokemon'
  get '/heal-trainer/:id', to: 'pokemon_trainers#healall', as: 'heal_trainer'
  get '/heal-trainer/:id/:pokemon_id', to: 'pokemon_trainers#heal', as: 'heal_trainer_pokemon'

  resources :pokedexes
  resources :skills
  resources :pokemons do
    resources :pokemon_skills, only: [:create, :destroy]
  end
  resources :pokemon_battles
  resources :trainers do
    resources :pokemon_trainers, only: [:create, :destroy]
  end
end

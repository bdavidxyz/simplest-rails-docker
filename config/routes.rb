require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  get 'hello/say_hello'
  root 'hello#say_hello'
end

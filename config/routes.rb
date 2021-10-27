Rails.application.routes.draw do

  get  'uploads'          => 'upload#list',      as: 'upload_list'
  get  'upload/new'       => 'upload#new',       as: 'upload_new'
  get  'upload/pending'   => 'upload#pending',   as: 'upload_pending'
  post 'upload/import'    => 'upload#import',    as: 'upload_import'

  devise_for :users, controllers: {
    sessions: 'user/sessions',
    registrations: 'user/registrations'
  }
  
  root to: 'default#index'
end

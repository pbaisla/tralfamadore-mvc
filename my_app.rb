require_relative 'environment'

class MyApp < Tralfamadore::App
  
  @@routes = {
      '/' => {
          get: 'root#index'
        },
      '/new' => {
          post: 'root#new'
        },
      '/view' => {
          get: 'root#show'
        }
    }

end

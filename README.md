# tralfamadore

A simple mvc framework

# Usage

1. `tralfamadore.rb` contains all the framework code

2. `environment.rb` requires all the files for the framework.
Require any other files that your app needs inside it.

3. Ensure `rack` is included in your `Gemfile`.
If it's not, add `gem 'rack'` to your Gemfile and run `bundle isntall`

4. `config.ru` is required to run your app on rack based servers.
It should look something like this:
```ruby
  # If app_file.rb contains the application code
  require_relative 'app_file'
  
  # If MyApp is the class which inherits from Tralfamadore::App
  run MyApp.new
```

5. To run the app, just type `rackup`

# How to use

1. Create a class which inherits from `Tralfamadore::App`.
The routes will be defined in this file like this:
```ruby

  class MyApp < Tralfamadore::App

    @@routes = {
        '/' => {
            get: 'root#index',
            post: 'root#new'
          },
        '/path' => {
            get: 'path#show',
            ...
            put: 'path#update'
          }
      }

  end

```
In `root#index`, root is the name of the controller in snake case and index is th method in the controller to be called for a GET request to '/'.
Similarly, the update method of Path controller will be called for PUT requests to '/path'

2. All controllers must be placed in a `controllers` directory and must inherit from `Tralfamadore::Controller`.
Each method in the controller mapped to a route gets the request hash as a parameter.

3. All models must be placed in a `models` directory and must inherit from `Tralfamadore::Model`.

4. All views must be placed in a `views` directory and have the extension `.tpl`.

5. Views can be rendered from controllers by using the `render` method which takes the name of the view and optionally a hash of data as arguments.
If no view is given to `render`, it redirects to '/'

6. To use variables inside views, they must be placed within `%%` symbols like this:
`<p> %% data['name'] %% </p>`

7. Models currently only support `csv` files.
The name of the csv file must be a snake case version of the Model class' name.
The attributes of the model are assumed to be the headers in the csv file.
The csv files must be stored in the `db` directory.

8. Models have the following methods:
- all: Returns an array of hashes containing all records in the file
- find: Takes a block as argument and fetches only those records for which the block returns `true`
- save: Saves a new to record to file. Takes a hash as argument

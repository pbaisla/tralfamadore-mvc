module Tralfamadore

  class App
    
    @@routes = {}
    
    def call(env)
      route = find(env['REQUEST_METHOD'], env['REQUEST_PATH'])
      if route
        perform_action_for route, env
      else
        [404, {}, [env['REQUEST_PATH'], "\nPage not found."]]
      end
    end

    def find(method, path)
      begin
        @@routes[path][method.downcase.to_sym]
      rescue NoMethodError
        nil
      end
    end

    def perform_action_for(route, env)
      controller, action = route.split '#'
      Object.const_get(controller.split('_').collect(&:capitalize).join).new.send(action, env)
    end

  end

  class Controller

    def render(template='', data={})
      if template == ''
        [302, {"Location" => '/'}, ['']]
      else
        body = File.open("views/#{template}.tpl").readlines
        body.map! do |line|
          matches = /%%([^\r\n%]*)%%/.match line
          if matches
            evaled = eval "eval matches[1]"
            line.sub(matches[0], evaled)
          else
            line
          end
        end
      end
      [200, {"Content-Type" => "text/html"}, body]
    end

    def process_post(env)
      line = env['rack.input'].gets
      post_data = Rack::Utils.parse_query line
      sym_hash = {}
      post_data.each do |k,v|
        sym_hash[k.to_sym] = v
      end
      sym_hash
    end
    
    def process_get(env)
      get_data = Rack::Utils.parse_query env['QUERY_STRING']
      sym_hash = {}
      get_data.each do |k,v|
        sym_hash[k.to_sym] = v
      end
      sym_hash
    end

  end

  class Model

    def initialize(params={})
      @@filename = "db/#{get_class_name.gsub(/(.)([A-Z])/,'\1_\2').downcase}.csv"
      @params = params
    end

    def get_class_name
      self.class.to_s
    end

    def self.all
      all_rows = []
      CSV.foreach(@@filename, headers: true, header_converters: :symbol) do |row|
        all_rows << row
      end
      all_rows
    end

    def self.find &block
      self.all.select do |i|
        yield i
      end
    end

    def save
      file = CSV.open(@@filename, "r+", headers: true, header_converters: :symbol)
      file.readline
      line = []
      file.headers.each do |header|
        line << @params[header]
      end
      while !file.eof?
        file.readline
      end
      file << line
      file.close
    end

    def to_h
      @params
    end

  end

end

class Root < Tralfamadore::Controller

  def index(req)
    render 'root'
  end

  def new(req)
    post_data = process_post(req)
    resume = Resume.new post_data
    resume.save
    render 'success', resume.to_h
  end

  def show(req)
    query = process_get(req)
    Resume.new
    resume = Resume.find do |row|
      query.all? do |k,v|
        row[k] == v
      end
    end
    if query.empty? or resume.empty?
      render 'notfound'
    else
      render 'view', resume[0]
    end
  end

end

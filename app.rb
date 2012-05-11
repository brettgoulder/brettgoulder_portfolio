__DIR__ = File.dirname(__FILE__)
%w(helpers portfolio).each{|r| require "#{__DIR__}/lib/#{r}" }
PortfolioItem.path = "#{__DIR__}/portfolio"

module BrettGoulder
  class Sinatra::Base
    configure do
      Compass.configuration do |config|
        config.project_path = File.dirname(__FILE__)
        config.sass_dir = File.join('views', 'stylesheets')
      end
    end
    set :logging, true
    set :public_folder, File.join(File.dirname(__FILE__), 'public')
    set :haml, {:format => :html5, :attr_wrapper => '"'}
    enable :static
    
    helpers do
      def partial(template, locals={})
        haml("_#{template}".to_sym, :locals => locals, :layout => false)
      end

      def portfolio_path(portfolio)
        "/portfolio/#{portfolio.slug}"
      end

      def render_page(portfolio)
        Tilt.new(portfolio.path).render(self)
      end
    end
    
    get "/stylesheets/:file.css" do |file|
      content_type 'text/css'
      # Use views/stylesheets & blueprint's stylesheet dirs in the Sass load path
      sass :"stylesheets/#{file}", :load_paths => (
        [ File.join(File.dirname(__FILE__), 'views', 'stylesheets') ] + 
        Compass::Frameworks::ALL.map { |f| f.stylesheets_directory })
    end
    
    get '/' do
      @portfolio_items = PortfolioItem.all
      @portfolio = PortfolioItem.all[0]
      haml(:portfolio)
    end
    
    get '/contact/?' do
      haml :contact
    end
    
    get '/reflection/?' do
      haml :reflection
    end
    
    get '/cv/?' do
      haml :cv, :layout => :cv_layout
    end
    
    get '/portfolio/?' do
      @portfolio_items = PortfolioItem.all
      @portfolio = PortfolioItem.all[0]
      haml(:portfolio)
    end
      
    get '/portfolio/:slug/?' do |slug|
      @portfolio_items = PortfolioItem.all
      if @portfolio = PortfolioItem[slug]
        haml(:portfolio)
      else
        pass
      end
    end
  end
end

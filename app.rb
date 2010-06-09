__DIR__ = File.dirname(__FILE__)
%w(helpers portfolio).each{|r| require "#{__DIR__}/lib/#{r}" }
PortfolioItem.path = "#{__DIR__}/portfolio"

module BrettGoulder
  class Sinatra::Base
      set :logging, true
      set :public, File.join(File.dirname(__FILE__), 'public')
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
      
      get '/' do
        haml :index
      end
      
      get '/contact/?' do
        haml :contact
      end
      
      get '/reflection/?' do
        haml :reflection
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

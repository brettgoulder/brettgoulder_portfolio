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
        include Helpers
      end
    
      get '/' do
        @portfolio_items = PortfolioItem.all
        haml :portfolio
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

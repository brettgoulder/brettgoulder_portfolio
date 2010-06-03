module BrettGoulder
  module Helpers
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
end
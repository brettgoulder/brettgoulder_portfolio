class PortfolioItem
  attr_accessor :path, :template

  def self.path=(path)
    @path = path
  end
  
  def self.files
    Dir["#{File.expand_path(@path)}/*"]
  end
  
  def self.all
    @all ||= files.
      collect {|f| new(f)}.
      sort_by {|a| a.slug}
  end
  
  def initialize(path)
    @path, @template = path, File.read(path)
  end
  
  def self.[](slug)
    all.find {|p| p.slug == slug}
  end
  
  def id
    slug
  end

  def slug
    File.basename(self.path, '.*')
  end

  def updated
    File.mtime(path)
  end

  def title
    h1 = /^\s*(%h1|#)\s+/
    template.split("\n").grep(h1).first.gsub(h1,'').strip
  rescue
    raise "No title for #{slug}"
  end
  
end
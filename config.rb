###
# Blog settings
###

# Time.zone = "UTC"
Time.zone = "Tokyo"
activate :blog do |blog|
  blog.prefix = "articles"
  # blog.permalink = ":year/:month/:day/:title.html"
  # blog.sources = ":year-:month-:day-:title.html"
  # blog.taglink = "tags/:tag.html"
  # blog.layout = "layout"
  blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = ":year.html"
  # blog.month_link = ":year/:month.html"
  # blog.day_link = ":year/:month/:day.html"
  # blog.default_extension = ".markdown"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  blog.paginate = true
  blog.per_page = 4
  blog.page_link = "page/:num"
end

page "/articles/*", :layout => :article_layout
%w(/stylesheets/*.css /javascripts/*.js /feed.xml).each do |path|
  page path, :layout => false
end

### 
# Compass
###

# Susy grids in Compass
# First: gem install susy
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
# 
# With no layout
# page "/path/to/file.html", :layout => false
# 
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
# 
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
helpers do
  def current_index
    blog.articles.index current_article
  end

  def prev_page
    return unless current_index
    blog.articles[current_index + 1]
  end

  def next_page
    return if !current_index or current_index <= 0
    blog.articles[current_index - 1]
  end

  def get_date(article=nil)
    date = article ? article.date : data.page.date
    return (case date
            when String
              DateTime.parse date
            else
              date
            end)
  end
#   def some_helper
#     "Helping"
#   end
end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  # activate :cache_buster

  # Use relative URLs
  # activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"
end

activate :livereload
activate :deploy do |deploy|
  config = Hash[
    File.read(File.dirname(__FILE__) + '/.env').lines.map {|line| line.strip.split('=') }
  ]

  deploy.method = :rsync
  deploy.user = config['USER']
  deploy.host = config['HOST']
  deploy.port = config['PORT'].to_i if config['PORT']
  deploy.path = config['PATH']
  deploy.clean = true
end

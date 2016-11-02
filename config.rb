###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml',  layout: false
page '/*.json', layout: false
page '/*.txt',  layout: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# General configuration

###
# Helpers
###

# middleman-syntax gem
activate :syntax

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

# Build-specific configuration
configure :build do
  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript
end

# VNA Applications
app.data.applications.each do |key, vna_app|
	proxy "/applications/#{key}.html", "/applications/template.html", locals: { title: vna_app.title, vna_app: vna_app }, ignore: true
	proxy "/applications/#{key}.json", "/applications/template.json", locals: { title: vna_app.title, vna_app: vna_app }, ignore: true
end

# build/.htaccess
after_build do
	FileUtils.copy 'source/_.htaccess', 'build/.htaccess'
end

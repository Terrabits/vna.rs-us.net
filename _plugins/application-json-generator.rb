require 'json'
require 'fileutils'

module Jekyll

  class ApplicationJsonGenerator < Generator
    safe true

    def generate(site)
      FileUtils::mkdir_p(Dir.pwd + '/_site/applications')
      site.pages.each do |page|
        layout = page.data['layout']
        title = page.data['title']
        if (layout == 'applications' && title != 'Applications')
          path = page.path
          path.gsub! /.html$/, '.json'
          render_json(page, path)

          new_name = page.name
          new_name.gsub! /.html$/, '.json'
          new_page = Page.new(site, site.source, page.dir, new_name)
          site.pages << new_page
        end
      end
    end

    def render_json(app, path)
      puts "Found application: " + path
      hash = Hash.new
      hash[:name] = app.data['title']
      hash[:version] = app.data['version']
      hash[:download_url] = app.data['download_url']
      hash[:change_log] = app.data['change_log']
      File.write path, hash.to_json
    end

  end # ApplicationJsonGenerator

end # Jekyll

# Generates help pages to be loaded into application’s built-in Help window.
# Generates pages from docs collection, but sets an extra frontmatter variable
# ``in_app_help: true`` for each page.
#
# Note: “docs” below can be used to refer to documentation pages
# as well as to Jekyll’s concept of “document”.

module Jekyll
  class InAppHelpPage < Page
    def initialize(site, base_dir, url_prefix, path, content, data)
      @site = site
      @base = base_dir

      url_prefix = site.config['in_app_help']['url_prefix']

      if path == '/index'
        @dir = url_prefix
      else
        @dir = File.join(url_prefix, path)
      end

      @content = content

      @name = "index.html"

      self.process(@name)

      self.data = data
      self.data['in_app_help'] = true
      self.data['permalink'] = nil
    end
  end

  class Site
    def write_in_app_help_pages(in_collection, out_collection, url_prefix)
      originals = @collections[in_collection]
      originals.docs.each do |doc|
        page = InAppHelpPage.new(self, self.source, url_prefix, doc.cleaned_relative_path, doc.content, doc.data)
        p doc.cleaned_relative_path
        @pages << page
      end
    end
  end
end


Jekyll::Hooks.register :site, :post_read do |site|
  if site.config.key?('in_app_help')
    cfg = site.config['in_app_help']
    site.write_in_app_help_pages(
      cfg['in_collection'],
      cfg['out_collection'],
      cfg['url_prefix'])
  end
end
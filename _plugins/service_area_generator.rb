module Jekyll
  class ServiceAreaPage < Page
    def initialize(site, base, dir, page_data)
      @site = site
      @base = base
      @dir  = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'service-area.html')
      self.data.merge!(page_data)
    end
  end

  class ServiceAreaGenerator < Generator
    safe true
    priority :normal

    def generate(site)
      return unless site.data['service_areas']

      site.data['service_areas'].each do |city|
        city_slug = city['city_slug']
        city_name = city['city']
        distance  = city['distance']

        next unless city['services']

        city['services'].each do |service|
          slug         = service['slug']
          service_name = service['service_name']
          dir          = "service-areas/#{city_slug}/#{slug}"

          page_data = {
            'layout'           => 'service-area',
            'title'            => "#{service_name} in #{city_name}, FL | AJ Automotive Services",
            'description'      => service['description'],
            'city'             => city_name,
            'city_slug'        => city_slug,
            'distance'         => distance,
            'service_name'     => service_name,
            'hero_tagline'     => service['hero_tagline'],
            'intro_heading'    => service['intro_heading'],
            'intro_content'    => service['intro_content'],
            'included_heading' => service['included_heading'],
            'included_items'   => service['included_items'],
            'faqs'             => service['faqs'],
          }

          page = ServiceAreaPage.new(site, site.source, dir, page_data)
          site.pages << page
        end
      end
    end
  end
end

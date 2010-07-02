require 'net/http'
require 'uri'

# Notify pubsubhubbub hubs about updated content.
module PushNotify

  # A collection of URLs representing updated content.
  class Content

    def initialize(*new_content_urls)
      @new_content_urls = new_content_urls
    end

    # Notify pubsubhubbub hubs that this content has been updated.
    def tell(*hub_urls)
      hub_urls.each do |hub_url|
        hub_uri = hub_url.is_a?(URI) ? hub_url : URI(hub_url)
        # pubsubhubbub supports multiple hub.url fields in one POST but
        # net/http does not
        new_content_urls.each do |new_content_url|
          resp = Net::HTTP.post_form(hub_uri, {
            'hub.mode' => 'publish',
            'hub.url' => new_content_url
            })
          yield resp if block_given?
        end
      end
    end

    attr_reader :new_content_urls

  end

end

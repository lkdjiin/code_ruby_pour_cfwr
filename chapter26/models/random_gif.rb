require 'net/http'
require 'dotenv/load'
require 'nori'

module API
  class Giphy
    def initialize(tags:)
      @tags = tags
    end

    def gif_url
      payload
        .fetch('data')
        .fetch('fixed_height_downsampled_url')
    end

    private

    def payload
      JSON.parse(response.body)
    end

    def response
      Net::HTTP.get_response(URI.parse(api_url))
    end

    def api_url
      "http://api.giphy.com/v1/gifs/random?api_key=#{api_key}&tag=#{@tags}"
    end

    def api_key
      ENV["GIPHY_KEY"]
    end
  end

  class Tenor
    def initialize(tags:)
      @tags = tags
    end

    def gif_url
      # payload["results"].first["media"].first["mediumgif"]["url"]
      payload
        .fetch("results")
        .first
        .fetch("media")
        .first
        .fetch("mediumgif")
        .fetch("url")
    end
    private

    def payload
      JSON.parse(response.body)
    end

    def response
      Net::HTTP.get_response(URI.parse(api_url))
    end

    def api_url
      "https://api.tenor.com/v1/random?q=#{@tags}&key=#{api_key}&limit=1"
    end

    def api_key
      ENV["TENOR_KEY"]
    end
  end

  class TheCatAPI
    def initialize(tags:)
      @xml_path = ["response", "data", "images", "image", "url"]
    end

    def gif_url
      payload.dig(*xml_path)
    end

    private

    attr_reader :xml_path

    def payload
      Nori.new.parse(response.body)
    end

    def response
      Net::HTTP.get_response(URI.parse(api_url))
    end

    def api_url
      'http://thecatapi.com/api/images/get?format=xml&size=small'
    end
  end
end

class RandomGif
  def initialize(collection_id:)
    @collection = Collection[collection_id]
    @client = random_api.new(tags: tags)
  end

  def get
    Gif.create(url: @client.gif_url, collection_id: @collection.id)
  end

  private

  def random_api
    return API::TheCatAPI if rand < 0.1
    rand > 0.5 ? API::Giphy : API::Tenor
  end

  def tags
    @collection.tags.tr(" ", "+")
  end
end

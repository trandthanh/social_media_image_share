require "httparty"

class ImageConverterService
  def initialize(post_id, photo_url)
    @post = Post.find(post_id)
    @title = @post.title
    @description = @post.description
    @photo_url = photo_url
    @auth = { username: ENV['HCTI_USER'], password: ENV['HCTI_PASSWORD'] }
  end

  def generate_image
    # html = "<div class=\"box\"><h3>Hello, world 😍</h3></div>"
    html = "<div class=\"box\">
      #{@title}
      <br>
      #{@description}
      <br>
      <img height=\"300\" width=\"400\" src=\"#{@photo_url}\">
    </div>"

    # css = ".box {
    #   border: 4px solid #8FB3E7;
    #   padding: 20px;
    #   color: white;
    #   font-size: 100px;
    #   width: 800px;
    #   height: 400px;
    #   font-family: 'Roboto';
    #   background-color: #8BC6EC;
    #   background-image: linear-gradient(135deg, #8BC6EC 0%, #9599E2 100%);
    # }"

    image = HTTParty.post("https://hcti.io/v1/image",
                          body: { html: html },
                          basic_auth: @auth)
    @post.update(generated_image_url: image.parsed_response["url"])
  end
end

# { url: https://hcti.io/v1/image/bfae7d68-86cc-4934-83ac-af3ba75a0d34 }

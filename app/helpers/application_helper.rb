module ApplicationHelper
  require "redcarpet"
  require "coderay"

  def user_avatar_or_default(user)
    return user && user.avatar.file ? user.avatar :
      'https://s3-ap-northeast-1.amazonaws.com/rootedlearning/uploads/default/avatar.jpg'
  end

  class HTMLwithCoderay < Redcarpet::Render::HTML
  end

  def markdown(text)
      html_render = HTMLwithCoderay.new(filter_html: true)
      options = {
          autolink: true,
          space_after_headers: true,
          no_intra_emphasis: true,
          fenced_code_blocks: true,
          tables: true,
          hard_wrap: true,
          xhtml: true,
          lax_html_blocks: true,
          strikethrough: true
      }
      markdown = Redcarpet::Markdown.new(html_render, options)
      markdown.render(text)
  end
end

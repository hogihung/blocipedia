module ApplicationHelper

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new
    extensions = {fenced_code_blockis: true,
                  disable_indented_code_blocks: true,
                  strikethrough: true,
                  hard_wrap: true}
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    (redcarpet.render text).html_safe
  end

end
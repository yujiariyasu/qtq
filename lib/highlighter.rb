require 'rouge/plugins/redcarpet'

class Highlighter < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet
end

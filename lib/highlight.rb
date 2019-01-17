require 'rouge/plugins/redcarpet'

class Highlight < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet
end

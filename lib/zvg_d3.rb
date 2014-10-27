require "zvg_d3/version"
if defined?(Rails)
  module ZvgD3
    module Rails
      class Engine < ::Rails::Engine
      end
    end
  end
end

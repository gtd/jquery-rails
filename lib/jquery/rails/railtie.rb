# Configure Rails 3.0 to use public/javascripts/jquery et al
module Jquery
  module Rails

    class Railtie < ::Rails::Railtie
      config.before_configuration do
        require "jquery/assert_select" if ::Rails.env.test?

        jq_defaults = %w(jquery jquery-ui jquery.min jquery-ui.min).select do |file|
          ::Rails.root.join("public/javascripts/#{file}.js").exist?
        end

        %w(jquery jquery-ui).each do |pair|
          if jq_defaults.include?(pair) && jq_defaults.include?("#{pair}.min")
            jq_defaults.delete(::Rails.env.production? ? pair : "#{pair}.min")
          end
        end

        # Merge the jQuery scripts, remove the Prototype defaults and finally add 'jquery_ujs'
        # at the end, because load order is important
        config.action_view.javascript_expansions[:defaults] -= PROTOTYPE_JS + ['rails']
        config.action_view.javascript_expansions[:defaults] |= jq_defaults
        config.action_view.javascript_expansions[:defaults] << 'jquery_ujs'
      end
    end

  end
end

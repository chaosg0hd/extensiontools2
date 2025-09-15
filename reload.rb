# frozen_string_literal: true
# File: extensiontools2/reload.rb
require 'sketchup.rb'

module ExtensionTools2
  module Reload
    def self.perform
      puts "[ET2][Reload] Reloading ExtensionTools2..."

      # Reload core
      core_path = File.join(ROOT_PATH, "core.rb")
      load core_path if File.exist?(core_path)

      # Reload functions
      if Dir.exist?(FN_PATH)
        fn_files = Dir[File.join(FN_PATH, '*.rb')].sort
        fn_files.each { |file| load file }
        puts "[ET2][Reload] Reloaded #{fn_files.size} functions."
      end

      # Reset toolbar state so it can rebuild
      STATE[:toolbar_built] = false
      ExtensionTools2.setup_toolbar if ExtensionTools2.respond_to?(:setup_toolbar)

      UI.messagebox("ExtensionTools2 reloaded.")
    end

    def self.setup_ui
      # Hook Reload menu for convenience
      unless STATE[:menu_built]
        menu = UI.menu("Plugins").add_submenu("ExtensionTools2")
        menu.add_item("Reload ExtensionTools2") { perform }
        STATE[:menu_built] = true
      end
    end
  end
end

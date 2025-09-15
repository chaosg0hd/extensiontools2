# frozen_string_literal: true
require 'sketchup.rb'
require 'fileutils'

puts "[ET2][Core] starting..."

module ExtensionTools2
  ROOT_PATH  = File.expand_path(__dir__)
  FN_PATH    = File.join(ROOT_PATH, 'functions')
  LOCAL_PATH = File.join(ROOT_PATH, 'local')
  ICONS_PATH = File.join(ROOT_PATH, 'assets', 'icons')

  # persistent state
  STATE ||= { menu_built: false, toolbar_built: false }

  def self.beep
    UI.beep rescue nil
  end

  def self.icon_path(name)
    path = File.join(ICONS_PATH, name.to_s)
    File.exist?(path) ? path : ''
  end

  # --- load all functions ---
  def self.load_functions
    if Dir.exist?(FN_PATH)
      fn_files = Dir[File.join(FN_PATH, '*.rb')].sort
      puts "[ET2][Core] loading #{fn_files.size} function files..."
      fn_files.each { |file| load file }
    else
      puts "[ET2][Core] functions path not found: #{FN_PATH}"
    end
  end

  # --- setup toolbar ---
  def self.setup_toolbar
    return if STATE[:toolbar_built]

    toolbar = UI::Toolbar.new("ET2")

    # Reload button
    cmd_reload = UI::Command.new("Reload ET2") do
      ExtensionTools2::Reload.perform if defined?(ExtensionTools2::Reload)
    end

    cmd_reload.tooltip = "Reload ExtensionTools2"
    cmd_reload.status_bar_text = "Reload ExtensionTools2 Core and Functions"
    cmd_reload.small_icon = icon_path("reload.png")
    cmd_reload.large_icon = icon_path("reload.png")
    toolbar.add_item(cmd_reload)

    toolbar.show
    STATE[:toolbar_built] = true
  end

  # --- run once ---
  load_functions
  setup_toolbar
end

puts "[ET2][Core] finished loading."

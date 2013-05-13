#!/usr/bin/ruby

require 'fileutils'
include FileUtils

scripts = [
  'utils.rb',
  'ship.rb',
  'ship_location_strategy.rb',
  'field.rb',
  'game.rb',
  'field_view.rb',
  'main_window.rb',
  'app.rb',
  ]

output_script = '#!/usr/bin/ruby
# encoding: utf-8
require \'matrix\'
require \'Qt\'
'

scripts.each { |script|
  File.open(script) { |file|
    while (line = file.gets)
      output_script << line unless line =~ /require.*/
    end
  }
  output_script << "\n"
}

rm "seafight.rb"
File.open("seafight.rb", "w"){ |file| file.write output_script }
chmod "+x", "seafight.rb"

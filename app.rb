require 'Qt4'
require 'main_window'

app = Qt::Application.new(ARGV)

main_window = MainWindow.new
main_window.resize 800, 600
main_window.show

app.exec

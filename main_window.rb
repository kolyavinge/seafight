require 'Qt4'

class MainWindow < Qt::Widget
  
  attr_accessor :presenter
  
  def showEvent event
    setWindowTitle "Sea Fight on Rubyyyy"
  end
  
  def paintEvent event
    painter = Qt::Painter.new self
    painter.drawEllipse 10, 10, 100, 100
    painter.end
  end
end

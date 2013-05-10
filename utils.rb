require 'matrix'

class Matrix
  def []=(i, j, x)
    @rows[i][j] = x
  end
end

module Utils
  def Utils.impacted_points? x1, y1, x2, y2
    ((x1 - x2).abs < 2) && ((y1 - y2).abs < 2)
  end

  def print_field ships, field_size
    z = 1
    m = Matrix::zero field_size
    ships.each{ |ship|
      ship.coords.each{ |p| m[p.y,p.x] = z }
      z += 1
    }
    (0...10).each{ |row_index|
      m.row(row_index).each{ |elem|
        if elem == 0 then print "." else print elem-1 end
      }
      print "\n"
    }
  end
end

module Utils

  def Utils.impacted_points? x1, y1, x2, y2
    (x1 - x2).abs < 2 and (y1 - y2).abs < 2
  end

end

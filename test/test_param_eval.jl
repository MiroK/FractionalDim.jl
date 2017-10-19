@test begin
    l = Segment(Point(0, 0), Point(3, 0))
    l(0) == l.O && l(1) == l.B && l(0.5) == 0.5*(l.O + l.B)
end

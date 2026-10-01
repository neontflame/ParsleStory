extends Line2D
class_name MapleFootholdLine

func createFootholdLine(pos1:Vector2i, pos2:Vector2i, jumpthru:bool):
	clear_points()
	add_point(pos1)
	add_point(pos2)
	createCollision(jumpthru)

func createCollision(jumpthru:bool):
	for i in points.size() - 1:
		var new_shape:CollisionShape2D = CollisionShape2D.new()
		$StaticBody2D.add_child(new_shape)
		var segment = SegmentShape2D.new()
		segment.a = points[i]
		segment.b = points[i + 1]
		new_shape.shape = segment
		new_shape.one_way_collision = jumpthru

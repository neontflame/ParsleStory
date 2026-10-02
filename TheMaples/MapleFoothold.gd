extends Line2D
class_name MapleFootholdLine

func createFootholdLine(pos1:Vector2i, pos2:Vector2i, jumpthru:bool):
	clear_points()
	global_position = pos1
	var posDois = Vector2(pos2) - global_position
	add_point(Vector2.ZERO)
	add_point(Vector2(posDois))
	createCollision(jumpthru)

func createCollision(jumpthru:bool):
	for i in points.size() - 1:
		var new_shape = CollisionShape2D.new()
		$StaticBody2D.add_child(new_shape)
		var rect = RectangleShape2D.new()
		new_shape.position = (points[i] + points[i + 1]) / 2
		new_shape.rotation = points[i].direction_to(points[i + 1]).angle()
		var length = points[i].distance_to(points[i + 1])
		rect.extents = Vector2(length / 2, width / 2)
		new_shape.one_way_collision = jumpthru
		new_shape.one_way_collision_margin = 8.0
		new_shape.one_way_collision_direction = new_shape.one_way_collision_direction.rotated(-new_shape.rotation)
		new_shape.shape = rect
		# print("collision made!")

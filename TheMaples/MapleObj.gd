extends MapleNode
class_name MapleObj

@export var obj:AnimatedSprite2D
var variation:String = ''
var subvar:String = ''
var subsubvar:String = ''

func setup(obj, type, subtype, subsubtype):
	highParse("Obj", obj)
	parseObj(type, subtype, subsubtype)

func parseObj(type:String, subtype:String, subsubtype:String):
	variation = type
	subvar = subtype
	subsubvar = subsubtype
	
	var theParsley = masterParse[type][subtype][subsubtype]["0"]
	# Why is there a trailing 0 now. It gets More Ridiculous by the second
	
	var img = Image.new()
	img.load_png_from_buffer(
		Marshalls.base64_to_raw(theParsley["_image"])
	)
	# obj.texture = ImageTexture.create_from_image(img)
	parseAnimation(masterParse[type][subtype][subsubtype])
	
	obj.offset = Vector2i(theParsley["origin"]["_x"], theParsley["origin"]["_y"]) * -1
	if theParsley.has("z"):
		obj.z_index = theParsley["z"]["_value"]

var frameOffsetIndex:Dictionary = {
}

func parseAnimation(parsled):
	var newFrames = SpriteFrames.new()
	obj.sprite_frames = newFrames
	obj.sprite_frames.clear("default")
	for frameKey in parsled:
		var frame = parsled[frameKey]
		if frame is Dictionary:
			if frame.has("_image"):
				print('frame ', frameKey, ' of ', variation)
				var img = Image.new()
				img.load_png_from_buffer(
					Marshalls.base64_to_raw(frame["_image"])
				)
				var tex:ImageTexture = ImageTexture.create_from_image(img)
				obj.sprite_frames.add_frame("default", tex, 1.0, int(frameKey))
				frameOffsetIndex[frameKey] = Vector2i(
					frame["origin"]["_x"], 
					frame["origin"]["_y"]
					) * -1
	obj.sprite_frames.set_animation_speed("default", 12.0)
	obj.play("default")

func onFrameChange():
	if frameOffsetIndex.has(str(obj.frame)):
		obj.offset = frameOffsetIndex[str(obj.frame)]

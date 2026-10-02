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
	
	parseAnimation(masterParse[type][subtype][subsubtype])
	if theParsley.has("z"):
		obj.z_index += theParsley["z"]["_value"] + 100

var frameOffsetIndex:Dictionary = {
}

func parseAnimation(parsled):
	var newFrames = SpriteFrames.new() # because to do otherwise would mean every sprite would have the same animation. And we dont want that
	
	obj.sprite_frames = newFrames
	for frameKey in parsled:
		var frame = parsled[frameKey]
		if frame is Dictionary:
			if frame.has("_image"):
				#print('frame ', frameKey, ' of ', variation)
				
				var img = Image.new()
				img.load_png_from_buffer(
					Marshalls.base64_to_raw(frame["_image"])
				)
				var tex:ImageTexture = ImageTexture.create_from_image(img)
				
				# ok Now the animations are accurate
				var lengthInMultiplys:float = 1.0
				if frame.has("delay"):
					lengthInMultiplys = (frame["delay"]["_value"] / 1000.0) / (1.0/15.0)
				
				obj.sprite_frames.add_frame("default", tex, lengthInMultiplys, int(frameKey))
				# every frame has a different offset for some godforsaken reason
				frameOffsetIndex[frameKey] = Vector2i(
					frame["origin"]["_x"], 
					frame["origin"]["_y"]
					) * -1
	obj.sprite_frames.set_animation_speed("default", 15.0)
	obj.play("default")

func onFrameChange():
	if frameOffsetIndex.has(str(obj.frame)):
		obj.offset = frameOffsetIndex[str(obj.frame)]

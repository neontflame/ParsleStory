extends MapleNode
class_name MapleObj

@export var obj:Sprite2D
var variation:String = ''
var subvar:String = ''
var subsubvar:String = ''

func setup(obj, type, subtype, subsubtype):
	highParse("Obj", obj)
	parseObj(type, subtype, subsubtype)

func parseObj(type:String, subtype:String, subsubtype:String):
	var theParsley = masterParse[type][subtype][subsubtype]["0"]
	# Why is there a trailing 0 now. It gets More Ridiculous by the second
	
	var img = Image.new()
	img.load_png_from_buffer(
		Marshalls.base64_to_raw(theParsley["_image"])
	)
	obj.texture = ImageTexture.create_from_image(img)
	
	obj.offset = Vector2i(theParsley["origin"]["_x"], theParsley["origin"]["_y"]) * -1
	if theParsley.has("z"):
		obj.z_index = theParsley["z"]["_value"]
	
	variation = type
	subvar = subtype
	subsubvar = subsubtype

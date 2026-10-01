extends MapleNode

enum VRBDir {
	TOP,
	LEFT,
	BOTTOM,
	RIGHT
}

@export var mapToLoad:String = "Map0/000010000"

var version:int = 0
var cloud:int = 0
var town:int = 0
var mobRate:float = 0
var bgm:String = ''
var returnMap:int = 0
var mapDesc:String = ''
var hideMinimap:int = 0
var forcedReturn:int = 0
var moveLimit:int = 0
var mapMark:String = ''
var swim:int = 0
var fieldLimit:int = 0
var VRBounds:Array[int] = [0, 0, 0, 0] #top, left, bottom, right
var fly:int = 0
var noMapCmd:int = 0
var onFirstUserEnter:String = ''
var onUserEnter:String = ''

func _ready() -> void:
	highParse("Map", mapToLoad)

func lowParse(thing:Dictionary):
	super.lowParse(thing)
	
	match thing["_dirName"]:
		"info":
			triggerLowerParse(thing)
		"back":
			makeBg(thing)
		"life":
			triggerLowerParse(thing)
		"reactor":
			pass
		"foothold":
			# these are collisions. hold off for now
			pass
		"ladderRope":
			pass
		"miniMap":
			pass
		"portal":
			pass
		_:
			#ACTUAL TILES !!! HALLELUJAH
			if thing.has("tile"):
				if thing["info"].has("tS"):
					makeTile(thing["info"]["tS"]["_value"], thing["tile"])

func makeBg(thing:Dictionary):
	for thingie in thing:
		var thingle = thing[thingie]
		if thingle is Dictionary:
			var pos:Vector2 = Vector2i(
				thingle["x"]["_value"],
				thingle["y"]["_value"]
			)
			var scrollest:Vector2 = Vector2i(
				thingle["rx"]["_value"],
				thingle["ry"]["_value"]
			) / -100.0
			
			var copySpacing:Vector2 = Vector2i(
				thingle["cx"]["_value"],
				thingle["cy"]["_value"]
			)
			var bgSource:String = thingle["bS"]["_value"]
			var variation:String = str(int(thingle["no"]["_value"]))
			var isOnFront:bool = (thingle["front"]["_value"] == 1.0)
			var isFlipped:bool = (thingle["f"]["_value"] == 1.0)
			
			var backery = load("res://TheMaples/MapleBg.tscn").instantiate()
			
			if isOnFront:
				$BGFront.add_child(backery)
			else:
				$BGBack.add_child(backery)
				
			backery.setup(bgSource, variation)
			backery.position = pos
			backery.copySpacing = copySpacing
			backery.parallax.scroll_scale = scrollest
			backery.z_index = -1000 + int(thingie)
			
			backery.textureRect.flip_h = isFlipped
			backery.textureRect.modulate.a = thingle["a"]["_value"] / 255.0
			
			backery.setupBehavior(int(thingle["type"]["_value"]))


func makeTile(type:String, thing:Dictionary):
	for thingie in thing:
		var thingle = thing[thingie]
		if thingle is Dictionary:
			var pos:Vector2 = Vector2i(
				thingle["x"]["_value"],
				thingle["y"]["_value"],
			)
			var possiblyZIndex:int = round(thingle["zM"]["_value"])
			var variation:String = thingle["u"]["_value"]
			var subvar:int = round(thingle["no"]["_value"])
			
			var tilery = load("res://TheMaples/MapleTile.tscn").instantiate()
			tilery.setup(type, variation, subvar)
			tilery.position = pos
			# Weird fuckin mystery number but hey if it works
			tilery.z_index += (4 - possiblyZIndex) * 10
			
			#print(
				#"new tile (%s)! variation: %s | subvariation: %s | x: %s | y: %s | z-index?: %s" % [
					#type,
					#variation, subvar,
					#pos.x, pos.y,
					#possiblyZIndex
				#]
			#)
			$Tiles.add_child(tilery)

func triggerLowerParse(thing:Dictionary):
	for thingie in thing:
		var thingle = thing[thingie]
		if thingle is Dictionary:
			lowerParse(thingle)

func lowerParse(thing:Dictionary):
	match(thing['_dirName']):
		'VRTop':
			VRBounds[VRBDir.TOP] = thing['_value']
		'VRLeft':
			VRBounds[VRBDir.LEFT] = thing['_value']
		'VRBottom':
			VRBounds[VRBDir.BOTTOM] = thing['_value']
		'VRRight':
			VRBounds[VRBDir.RIGHT] = thing['_value']
		_:
			if thing.has("_value"):
				set(thing['_dirName'], thing['_value'])

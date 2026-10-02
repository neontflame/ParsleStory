extends MapleNode
class_name MapleMap

@export var mapToLoad:String = "Map0/000010000"
@export var bgmPlayer:AudioStreamPlayer

# bunch of stuff taken from the .img
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
var VRBounds:Array[int] = [-1, -1, -1, -1] #top, left, bottom, right
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
			return
		"back":
			makeBg(thing)
			return
		"life":
			triggerLowerParse(thing)
			return
		"reactor":
			pass
		"foothold":
			makeFoothold(thing)
			return
		"ladderRope":
			pass
		"miniMap":
			pass
		"portal":
			makePortal(thing)
		_:
			#ACTUAL TILES !!! HALLELUJAH
			if thing.has("obj"):
				makeObj(thing["obj"])
			if thing.has("tile"):
				if thing["info"].has("tS"):
					makeTile(thing["info"]["tS"]["_value"], thing["tile"])
			return

#region Makes stuff
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
				backery.z_index = 3000 + int(thingie)
			else:
				$BGBack.add_child(backery)
				backery.z_index = -3000 + int(thingie)
				
			backery.setup(bgSource, variation)
			backery.position = pos
			backery.copySpacing = copySpacing
			backery.parallax.scroll_scale = scrollest
			
			backery.textureRect.flip_h = isFlipped
			backery.textureRect.modulate.a = thingle["a"]["_value"] / 255.0
			
			backery.setupBehavior(int(thingle["type"]["_value"]))

var boundaries:Array[int] = [-1, -1, -1, -1] #top, left, bottom, right

func makeTile(type:String, thing:Dictionary):
	for thingie in thing:
		var thingle = thing[thingie]
		if thingle is Dictionary:
			var pos:Vector2 = Vector2i(
				thingle["x"]["_value"],
				thingle["y"]["_value"],
			)
			#var possiblyZIndex:int = round(thingle["zM"]["_value"])
			var variation:String = thingle["u"]["_value"]
			var subvar:int = round(thingle["no"]["_value"])
			
			var tilery = load("res://TheMaples/MapleTile.tscn").instantiate()
			tilery.setup(type, variation, subvar)
			tilery.position = pos
			# Weird fuckin mystery equation but hey if it works
			tilery.z_index += 100
			
			$Tiles.add_child(tilery)
			setBoundary(pos.y, pos.x, pos.y, pos.x)
	
	if VRBounds == [-1, -1, -1, -1]:
		print("Hey man. This Shit is not Set")
		VRBounds = boundaries

func setBoundary(top:int, left:int, bottom:int, right:int):
	if boundaries[0] == -1 or boundaries[0] > top:
		boundaries[0] = top
	if boundaries[1] == -1 or boundaries[1] > left:
		boundaries[1] = left
	if boundaries[2] == -1 or boundaries[2] < bottom:
		boundaries[2] = bottom
	if boundaries[3] == -1 or boundaries[3] < right:
		boundaries[3] = right

func makeObj(thing:Dictionary):
	for thingie in thing:
		var thingle = thing[thingie]
		if thingle is Dictionary:
			var pos:Vector2 = Vector2i(
				thingle["x"]["_value"],
				thingle["y"]["_value"],
			)
			var possiblyZIndex:int = round(thingle["z"]["_value"])
			
			var objectStyle:String = thingle["oS"]["_value"]
			var variation:String = thingle["l0"]["_value"]
			var subvar:String = thingle["l1"]["_value"]
			var subsubvar:String = thingle["l2"]["_value"]
			var isFlipped:bool = (thingle["f"]["_value"] == 1.0)
			
			var objectery = load("res://TheMaples/MapleObj.tscn").instantiate()
			objectery.setup(objectStyle, variation, subvar, subsubvar)
			objectery.position = pos
			# Weird fuckin mystery number again !
			objectery.z_index += possiblyZIndex
			objectery.obj.flip_h = isFlipped
			
			$Obj.add_child(objectery)

func makeFoothold(thing:Dictionary):
	for thingie in thing:
		var thingle = thing[thingie]
		if thingle is Dictionary:
			# it's even funnier the second time!
			for thingies in thingle:
				var thingery = thingle[thingies]
				if thingery is Dictionary:
					# it's even funnier the *third time!
					for footID in thingery:
						var footness = thingery[footID]
						if footness is Dictionary:
							var pos1:Vector2 = Vector2i(
								footness["x1"]["_value"],
								footness["y1"]["_value"]
							)
							var pos2:Vector2 = Vector2i(
								footness["x2"]["_value"],
								footness["y2"]["_value"]
							)
							var canFallThrough:bool = true
							if footness.has("forbidFallDown"):
								canFallThrough = footness["forbidFallDown"]["_value"] != 1.0
								print(canFallThrough)
							
							var footery = load("res://TheMaples/MapleFoothold.tscn").instantiate()
							footery.createFootholdLine(pos1, pos2, canFallThrough)
							footery.layer = thingie
							$Footholds.add_child(footery)

func makePortal(thing:Dictionary):
	for thingie in thing:
		var thingle = thing[thingie]
		if thingle is Dictionary:
			var portalName:String = thingle["pn"]["_value"]
			var portalType:int = int(thingle["pt"]["_value"])
			var pos:Vector2 = Vector2(
				thingle["x"]["_value"],
				thingle["y"]["_value"]
			)
			var targetMap:int = int(thingle["tm"]["_value"])
			var targetPortal:String = thingle["tn"]["_value"]
			
			var portal = load("res://TheMaples/MaplePortal.tscn").instantiate()
			portal.setup(portalName, portalType)
			portal.position = pos
			portal.targetMap = targetMap
			portal.targetPortal = targetPortal
			$MapHelpers.add_child(portal)
#endregion

# other cool thingies
func triggerLowerParse(thing:Dictionary):
	for thingie in thing:
		var thingle = thing[thingie]
		if thingle is Dictionary:
			lowerParse(thingle)

func lowerParse(thing:Dictionary):
	match(thing['_dirName']):
		"bgm":
			print('bgm: ', thing["_value"])
			bgmPlayer.stream = MapleFileUtils.load_song(thing["_value"])
			bgmPlayer.play()
			return
		'VRTop':
			VRBounds[0] = thing['_value']
		'VRLeft':
			VRBounds[1] = thing['_value']
		'VRBottom':
			VRBounds[2] = thing['_value']
		'VRRight':
			VRBounds[3] = thing['_value']
		_:
			if thing.has("_value"):
				set(thing['_dirName'], thing['_value'])

extends Node
class_name FileUtils

static func get_wz_folder_path(wz:String):
	return "mapleExport/%s.wz" % wz
	
static func get_user_path():
	return OS.get_executable_path().get_base_dir()

static func get_text_file_content(pathness) -> String:
	var filePath = get_user_path() + "/" + pathness
	
	if FileAccess.file_exists(filePath):
		return FileAccess.get_file_as_string(filePath)
	return ''

static var jsonCache:Dictionary = {}

static func load_json_from_file(path:String):
	if jsonCache.has(path):
		return jsonCache[path]
	
	var jsonToLoad:String = get_text_file_content(path)
	jsonCache[path] = JSON.parse_string(jsonToLoad)
	
	return jsonCache[path]

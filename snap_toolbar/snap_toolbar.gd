@tool
extends EditorPlugin

var snap_bar
var save_data_path: String = "res://addons/snap_toolbar/snap_toolbar_savedata.tres"
const SNAPPING_TOOLBAR = preload("uid://cebjsmuqhd7fo")

func _enter_tree() -> void:
	snap_bar = SNAPPING_TOOLBAR.instantiate()
	add_control_to_container(CONTAINER_SPATIAL_EDITOR_MENU, snap_bar)
	scene_changed.connect(_on_scene_changed)
	
	if DirAccess.dir_exists_absolute(save_data_path):
		var loadedFile = load(save_data_path)
		snap_bar.load_settings(loadedFile.translate_increment, loadedFile.rotate_increment, loadedFile.scale_increment)
	else:
		var newFile = snap_bar_data.new()
		newFile.translate_increment = 1.0
		newFile.rotate_increment = 15.0
		newFile.scale_increment = 10.0
		snap_bar.load_settings(newFile.translate_increment, newFile.rotate_increment, newFile.scale_increment)
		ResourceSaver.save(newFile, save_data_path)

func _exit_tree() -> void:
	remove_control_from_container(CONTAINER_SPATIAL_EDITOR_MENU, snap_bar)
	
	snap_bar.queue_free()

## Executes Scene change function in the snapping toolbar
func _on_scene_changed(new_root: Node) -> void:
	if new_root:
		snap_bar.load_toolbar_values()

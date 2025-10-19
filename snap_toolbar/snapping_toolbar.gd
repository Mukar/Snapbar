@tool
extends Control

var snap_dialog
var save_data_path: String = "res://addons/snap_toolbar/snap_toolbar_savedata.tres"
var line_edits: Array

func _ready():
	%icon_translate.icon = get_theme_icon(&"ToolMove", &"EditorIcons")
	%icon_rotation.icon = get_theme_icon(&"ToolRotate", &"EditorIcons")
	%icon_scale.icon = get_theme_icon(&"ToolScale", &"EditorIcons")
	
	var popup_children = EditorInterface.get_base_control().find_children("*", "ConfirmationDialog", true, false)
	
	for i in popup_children:
		if i.title == "Snap Settings":
			snap_dialog = i
			line_edits = i.find_children("*", "LineEdit", true, false)
	
	snap_dialog.confirmed.connect(update_toolbar_from_popup)

func _on_input_translate_value_changed(value: float) -> void:
	line_edits[0].set_text(str(value))
	snap_dialog.confirmed.emit()

func _on_input_rotation_value_changed(value: float) -> void:
	line_edits[1].set_text(str(value))
	snap_dialog.confirmed.emit()

func _on_input_scale_value_changed(value: float) -> void:
	line_edits[2].set_text(str(value))
	snap_dialog.confirmed.emit()

## Updates toolbar values into popup, as Godot resets snapping values per scene by default.
func load_toolbar_values():
	line_edits[0].set_text(str(%input_translate.value))
	line_edits[1].set_text(str(%input_rotation.value))
	line_edits[2].set_text(str(%input_scale.value))
	snap_dialog.confirmed.emit()

## Updates toolbar values with changes made in popup, if changes are made there.
func update_toolbar_from_popup():
	%input_translate.set_value_no_signal(float(line_edits[0].text))
	%input_rotation.set_value_no_signal(float(line_edits[1].text))
	%input_scale.set_value_no_signal(float(line_edits[2].text))
	save_settings()

## Loads snap settings from file for persistence across editor shutdown.
func load_settings(translate_increment: float, rotate_increment: float, scale_increment: float):
	%input_translate.set_value_no_signal(float(translate_increment))
	%input_rotation.set_value_no_signal(float(rotate_increment))
	%input_scale.set_value_no_signal(float(scale_increment))
	snap_dialog.confirmed.emit()

## Saves snap settings to file for persistence across editor shutdown.
func save_settings():
	if DirAccess.dir_exists_absolute(save_data_path):
		var loadedFile = load(save_data_path)
		loadedFile.translate_increment = %input_translate.value
		loadedFile.rotate_increment = %input_rotation.value
		loadedFile.scale_increment = %input_scale.value
		ResourceSaver.save(loadedFile, save_data_path)
	else:
		var newFile = snap_bar_data.new()
		newFile.translate_increment = %input_translate.value
		newFile.rotate_increment = %input_rotation.value
		newFile.scale_increment = %input_scale.value
		ResourceSaver.save(newFile, save_data_path)

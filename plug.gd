extends "res://addons/gd-plug/plug.gd"


func _plugging():
	plug("xiezi5160/MultirunForGodot4")
	plug("imjp94/gd-plug")
	updated.connect(_on_plugin_updated)

func _on_updated(plugin):
	# Override to catch all updated plugins
	match plugin.name:
		"imjp94/gd-plug":
			print("Use upgrade command!")

func _on_GUT_updated(plugin):
	print("%s updated" % plugin.name)
	print("Installed files: " + plugin.dest_files)

func _on_plugin_updated(plugin):
	# Catch all updated plugins with signal
	print("%s post update hook with signal" % plugin.name)

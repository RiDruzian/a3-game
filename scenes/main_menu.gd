extends Control


func _on_botão_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/node_2d.tscn")


func _on_botao_sair_pressed() -> void:
	get_tree().quit()

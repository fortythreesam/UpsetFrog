extends DropItem

func _on_Area2D_body_entered(body):
	if body.has_method("give_potion"):
		body.give_potion()
		queue_free()

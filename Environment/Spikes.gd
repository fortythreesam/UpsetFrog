extends Area2D

export(float) var damage = 10

func _on_Spikes_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage, -0.2, 0.1, 0.3)

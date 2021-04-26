extends State
class_name BossIdleState

func step(owner, delta):
	if owner.target:
		if abs(owner.position.x - owner.target.position.x) < owner.vision_range:
			emit_signal("change_state", "attack")

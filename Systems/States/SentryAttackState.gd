extends State
class_name SentryAttackState

func step(owner, delta: float):
	owner.launch(owner.position + owner.launch_from + Vector2(-1, 0))

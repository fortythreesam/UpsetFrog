extends State
class_name BossAttackState

func start(owner):
	owner.play_sound('notice')

func step(owner, delta: float):
	owner.direction = Vector2.ZERO
	if owner.target:
		if abs(owner.position.x - owner.target.position.x) < owner.attack_range and \
		   abs(owner.position.y - owner.target.position.y) < owner.attack_range_y:
			owner.alt_attack()
		else:
			owner.launch(owner.target.position)

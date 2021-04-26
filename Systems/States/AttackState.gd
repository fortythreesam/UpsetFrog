extends State
class_name AttackState

func step(owner, delta: float):
	owner.direction = Vector2.ZERO
	if owner.target:
		owner.attack()
		if abs(owner.position.x - owner.target.position.x) > owner.attack_range or \
		   abs(owner.position.y - owner.target.position.y) > owner.attack_range_y:
			emit_signal("change_state", "chase")
		if abs(owner.position.x - owner.target.position.x) < owner.personal_space:
			owner.direction = owner.position.direction_to(owner.target.position) * -1

extends State
class_name ChaseState

func start(owner):
	owner.play_sound('notice')
	
func step(owner, delta):
	
	if owner.target:
		
		owner.direction = Vector2.ZERO
		
		var in_range_x = false
		var in_range_y = false
		
		if owner.position.x - owner.target.position.x < owner.personal_space:
			owner.direction.x = 1
		elif owner.position.x - owner.target.position.x > owner.attack_range:
			print(owner.attack_range)
			print(owner.position.x - owner.target.position.x > owner.attack_range)
			owner.direction.x = -1
		else:
			in_range_x = true
			owner.direction.x = 0
			
		if abs(owner.position.y - owner.target.position.y) > owner.attack_range_y:
			owner.direction.y = sign(owner.target.position.y - owner.position.y)
		else:
			in_range_y = true
			owner.direction.y = 0
			
		if abs(owner.position.x - owner.target.position.x) > owner.vision_range * 1.1:
			owner.direction = Vector2.ZERO
			emit_signal("change_state", "idle")
			
		if in_range_x and in_range_y:
			emit_signal("change_state", "attack")
	else:
		emit_signal("change_state", "idle")

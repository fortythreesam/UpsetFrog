extends Enemy

func _ready():
	ai_controller.states.attack = BossAttackState.new()
	ai_controller.states.idle = BossIdleState.new()
	ai_controller.change_state("idle")

func alt_attack():
	custom_attack_animation = "attack_alt"
	attack()


func _animation_finished():
	match animated_sprite.animation:
		"attack_alt":
			end_attack()
		_:
			._animation_finished()

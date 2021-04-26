extends Enemy

func _ready():
	ai_controller.states.attack = SentryAttackState.new()
	ai_controller.change_state("attack")


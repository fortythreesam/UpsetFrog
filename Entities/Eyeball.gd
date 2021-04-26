extends Enemy

func _ready():
	ai_controller.states.attack = RangedAttackState.new()

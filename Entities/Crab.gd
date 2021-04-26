extends Entity

export(int) var roll_speed = 50
export(float) var roll_cooldown = 0.3
export(float) var roll_stamina_cost = 25

var roll_direction: int = -1
var roll_cooldown_timer: float = -1

var options = preload("res://UI/Options.tscn")

func _ready():
	movable_states.append("roll")

func _process(delta):
	if not alive: return
	
	if animated_sprite.animation == "roll":
		direction = Vector2(0, roll_direction)
	else:
		direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
		direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	
	if direction.y != 0:
		roll_direction = direction.y
		
	roll_cooldown_timer -= delta

func _input(event):
	if event.is_action_pressed("escape"):
		var options_instance = options.instance()
		options_instance.pause_mode = Node.PAUSE_MODE_PROCESS
		$CanvasLayer.add_child(options_instance)
		get_tree().paused = true
	if event.is_action_pressed("attack"):
		charge_attack()
	if event.is_action_released("attack"):
		release_charge()
	if event.is_action_pressed("roll"):
		roll()
	if event.is_action_pressed("use_potion"):
		use_potion()
	
func roll():
	if animated_sprite.animation in actionable_states and roll_cooldown_timer <= 0 and stamina > 0:
		play_sound("roll")
		animated_sprite.play("roll")
		take_stamina(roll_stamina_cost)
		invincible = true
		y_speed_boost = roll_speed
	

func kill():
	PlayerInfoManager.alive = false
	.kill()

func _animation_finished():
	match animated_sprite.animation:
		"roll":
			roll_cooldown_timer = roll_cooldown
			animated_sprite.play("idle")
			invincible = false
			y_speed_boost = 0
		_:
			._animation_finished()

func give_potion():
	play_sound("pickup")
	potions += 1

func is_player():
	return true

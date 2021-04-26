extends KinematicBody2D
class_name Entity

export(bool) var is_player = false
export(float) var max_health = 100
export(float) var max_stamina = 100
export(float) var damage = 30
export(int) var potions = 0
export(float) var potion_strength = 20
export(float) var attack_stamina_cost = 40
export(float) var charge_damage_per_second = 20
export(float) var knockback_strengh = 25
export(float) var max_x_speed = 100
export(float) var max_y_speed = 60
export(float) var attack_cooldown = 1
export(float) var invincibility_time = 0.5
export(float) var potion_drop_chance = 0.2
export(PackedScene) var projectile
export(float) var projectile_speed = 120
export(float) var projectile_life = 2
export(Vector2) var launch_from = Vector2(0, 0)
export(int) var poise = 1
export(bool) var invincible = false

var inventoy = []

var velocity: Vector2
var direction: Vector2

var x_speed_boost: float = 0
var y_speed_boost: float = 0

var health: float 
var alive: bool = true

var stamina = 100
var stamina_per_second = 70
var stamina_recharge_timer = 0.3

var actionable_states = ["idle", "walk", "attack_start"]
var movable_states = ["idle", "walk"]
var exclusive_movable_states = ["idle", "walk"]

var attack_cooldown_timer: float = 0
var invincibility_timer: float = 0
var flash_interval: float = 0

var highlight_time: float = 0.2
var highlight_timer: float = 0

var knockback: Vector2

var charging_attack = false
var bonus_charge_damage = 0

var launching_projectile = false
var projectile_direction: Vector2 

var potion_scene = preload("res://Items/Potion.tscn")

var custom_attack_animation = ""

var poise_counter

onready var animated_sprite: AnimatedSprite = $AnimatedSprite 
onready var weapon_hitbox: Area2D = $HitBox 
onready var sounds = $Sounds 

func _ready():
	health = max_health
	poise_counter = poise
	animated_sprite.connect("animation_finished", self, '_animation_finished')
	animated_sprite.play("idle")
	weapon_hitbox.connect("body_entered", self, "_on_hitbox_Body_entered")
	weapon_hitbox.connect("area_entered", self, "_on_hitbox_Area_entered")
	weapon_hitbox.set_deferred("monitoring", false)
	weapon_hitbox.set_deferred("moniterable", false)

func _process(delta):
	
	direction.normalized()
	
	if animated_sprite.animation in movable_states and alive:
		velocity = direction
	else:
		velocity = Vector2.ZERO
	
	stamina_recharge_timer -= delta
	attack_cooldown_timer -= delta
	
	
	if animated_sprite.animation in exclusive_movable_states and stamina < max_stamina and stamina_recharge_timer <= 0:
		stamina += delta * stamina_per_second
	
	if invincibility_timer > 0:
		invincibility_timer -= delta
		flash_interval -= delta
		if flash_interval < 0:
			animated_sprite.visible = !animated_sprite.visible
			flash_interval = 0.1
	else:
		animated_sprite.show()
	
	if highlight_timer > 0:
		highlight_timer -= delta
		animated_sprite.modulate = Color(100,100,100)
	else:
		animated_sprite.modulate = Color(1,1,1)
		
	if charging_attack:
		bonus_charge_damage += delta * charge_damage_per_second
	
	if knockback != Vector2.ZERO:
		velocity = knockback
		knockback = lerp(knockback, Vector2.ZERO, delta*20)
		if knockback.x < 1 and knockback.y < 1:
			knockback = Vector2.ZERO
	velocity = velocity * Vector2(max_x_speed + x_speed_boost, max_y_speed + y_speed_boost)
	move_and_slide(velocity)
	if animated_sprite.animation in exclusive_movable_states:
		update_animation()
	
func update_animation():
	if direction != Vector2.ZERO:
		if animated_sprite.animation == "idle":
			var dir = 1
			if direction.x < 0:
				dir = -1
			animated_sprite.play("walk", dir)
	else:
		animated_sprite.play("idle")
	
		

func charge_attack():
	if animated_sprite.animation != "attack_start" and \
	   animated_sprite.animation in actionable_states and \
	   attack_cooldown_timer <= 0 and \
	   stamina > 0:
		charging_attack = true
		animated_sprite.play("attack_start")

func release_charge():
	if animated_sprite.animation == "attack_start":
		play_sound("swing")
		enable_hitbox()
		animated_sprite.play("attack")

func attack():
	if animated_sprite.animation != "attack_start" and \
	   animated_sprite.animation in actionable_states and\
	   attack_cooldown_timer <= 0:
		animated_sprite.play("attack_start")

func launch(target: Vector2):
	if animated_sprite.animation != "attack_start" and \
	   projectile != null and \
	   animated_sprite.animation in actionable_states and\
	   attack_cooldown_timer <= 0:
		projectile_direction = (position + launch_from).direction_to(target)
		launching_projectile = true
		animated_sprite.play("attack_start")
	
func release_projectile():
	play_sound("shoot")
	launching_projectile = false
	
	var projectile_instance = projectile.instance()
	projectile_instance.position = position + launch_from
	projectile_instance.entity = self
	projectile_instance.damage = damage
	projectile_instance.lifespan = projectile_life
	projectile_instance.velocity = projectile_direction * projectile_speed
	attack_cooldown_timer = attack_cooldown
	get_parent().add_child(projectile_instance)

func end_attack():
	animated_sprite.play("attack_end")
	take_stamina(attack_stamina_cost + bonus_charge_damage)
	bonus_charge_damage = 0
	charging_attack = false
	disable_hitbox()

func _animation_finished():
	match animated_sprite.animation:
		"walk":
			animated_sprite.play("walk")
		"attack_start":
			var next_animation = "attack"
			
			if custom_attack_animation != "":
				next_animation = custom_attack_animation
				custom_attack_animation = ""
			if charging_attack:
				animated_sprite.play("attack_start")
			elif launching_projectile:
				release_projectile()
				animated_sprite.play(next_animation)
			else:
				play_sound("swing")
				enable_hitbox()
				animated_sprite.play(next_animation)
		"attack":
			end_attack()
		"attack_end":
			animated_sprite.play("idle")
			attack_cooldown_timer = attack_cooldown
		"hurt":
			if alive:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("dead")
				

func enable_hitbox():
	weapon_hitbox.set_deferred("monitoring", true)
	
func disable_hitbox():
	weapon_hitbox.set_deferred("monitoring", false)
	
func hit(incoming_damage: int, x_dir: float, y_dir: float = 0, power_modifier: float = 1):
	if alive and invincibility_timer <= 0 and not invincible:
		play_sound("hit")
		poise_counter -= 1
		if poise_counter <= 0:
			animated_sprite.play("hurt")
			poise_counter = poise
		knockback = Vector2(sign(x_dir), sign(y_dir)) * (knockback_strengh * power_modifier)
		health -= incoming_damage
		flash_interval = 0.2
		invincibility_timer = invincibility_time
		highlight_timer = highlight_time
		disable_hitbox()
		if health <= 0:
			kill()
	
func kill():
	play_sound("dead")
	if not is_player:
		PlayerInfoManager.add_kill()
	if randf() < potion_drop_chance:
		var potion_instance = potion_scene.instance()
		potion_instance.position = position
		get_parent().add_child(potion_instance)
	alive = false
	$CollisionShape2D.set_deferred("disabled", true)
	
func take_stamina(amount):
	stamina_recharge_timer = 0.3
	stamina -= amount
	
func use_potion():
	if potions > 0 and health < max_health:
		play_sound("heal")
		potions -= 1
		health = min(health + potion_strength, max_health)
	
func _on_hitbox_Body_entered(body):
	if body.has_method("hit") and body != self:
		body.hit(damage + bonus_charge_damage, sign(body.position.x - position.x))
	
func _on_hitbox_Area_entered(area):
	if area.name == "HurtBox":
		var body = area.get_parent()
		if body == self: return
		body.hit(damage + bonus_charge_damage, sign(body.position.x - position.x))
	if area.get_parent().has_method("reflect"):
		area.get_parent().reflect(self)
	
func play_sound(sound):
	if sounds != null:
		if sounds.get_node(sound) != null:
			sounds.get_node(sound).play()

extends CharacterBody2D

var health := 5
var speed = 350
var dead := false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var move_dir := Input.get_vector("left", "right", "up", "down")
	velocity = move_dir * speed
	move_and_slide()

	var aim_dir := get_global_mouse_position() - global_position
	update_animation(move_dir, aim_dir)

func update_animation(move_dir: Vector2, aim_dir: Vector2) -> void:
	var prefix := "run" if move_dir != Vector2.ZERO else "idle"

	if abs(aim_dir.x) > abs(aim_dir.y):
		animated_sprite_2d.flip_h = aim_dir.x < 0
		animated_sprite_2d.play(prefix + "_right")
	elif aim_dir.y < 0:
		animated_sprite_2d.play(prefix + "_up")
	else:
		animated_sprite_2d.play(prefix + "_down")
		
func take_damage(amount: int) -> void:
	if dead:
		return
	health -= amount
	print("Vida del jugador: ", health)
	if health <= 0:
		dead = true
		die()

func die() -> void:
	set_physics_process(false)
	get_tree().call_deferred("reload_current_scene")
	

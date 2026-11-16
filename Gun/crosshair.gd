extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
var tween: Tween
var player: CharacterBody2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	z_index = 100
	player = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()

	if player and not (tween and tween.is_running()):
		var target := 1.0 + (player.velocity.length() / 350.0) * 0.4
		sprite.scale = sprite.scale.lerp(Vector2(target, target), 0.15)

	if Input.is_action_just_pressed("fire"):
		shoot_effect()

func shoot_effect() -> void:
	if tween:
		tween.kill()
	sprite.scale = Vector2(1.5, 1.5)
	sprite.rotation = deg_to_rad(45)
	tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2.ONE, 0.15)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(sprite, "rotation", 0.0, 0.15)

func _physics_process(_delta: float) -> void:
	var space := get_world_2d().direct_space_state
	var query := PhysicsPointQueryParameters2D.new()
	query.position = global_position
	query.collide_with_bodies = true
	query.collide_with_areas = true

	var on_enemy := false
	for hit in space.intersect_point(query):
		if hit.collider.is_in_group("enemy"):
			on_enemy = true
			break

	sprite.modulate = Color.RED if on_enemy else Color.WHITE

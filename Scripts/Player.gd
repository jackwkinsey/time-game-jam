extends Sprite

const SPEED = 64;
const TILE_SIZE = 16;

var last_position = Vector2();
var target_position = Vector2();
var move_direction = Vector2();

onready var ray = $RayCast2D;

func _ready():
	position = position.snapped(Vector2(TILE_SIZE, TILE_SIZE));
	last_position = position;
	target_position = position;
	
func _process(delta):
	if ray.is_colliding():
		position = last_position;
		target_position = last_position;
	else:
		# move the player based on move direction
		position += move_direction * SPEED * delta;
		
		# if the player moved further than one space, snap to target position
		if position.distance_to(last_position) >= TILE_SIZE - SPEED * delta:
			position = target_position;
	
	if position == target_position:
		# only get movement direction from input when player is at target position
		get_move_direction();
		last_position = position;
		target_position += move_direction * TILE_SIZE;
	
func get_move_direction():
	var right = int(Input.is_action_pressed("ui_right"));
	var left = int(Input.is_action_pressed("ui_left"));
	var down = int(Input.is_action_pressed("ui_down"));
	var up = int(Input.is_action_pressed("ui_up"));
	
	move_direction.x = right - left;
	move_direction.y = down - up;
	
	# Prevent diagonal movement...eventually want to allow this!
	if move_direction.x != 0 && move_direction.y != 0:
		move_direction = Vector2.ZERO;
		
	if move_direction != Vector2.ZERO:
		ray.cast_to = move_direction * TILE_SIZE / 2;

extends Sprite

const SPEED = 64;
const TILE_SIZE = 16;

var last_position = Vector2();
var target_position = Vector2();
var move_direction = Vector2();

func _ready():
	position = position.snapped(Vector2(TILE_SIZE, TILE_SIZE));
	last_position = position;
	target_position = position;
	
func _process(delta):
	# move the player based on move direction
	position += move_direction * SPEED * delta;
	
	# if the player moved further than one space, snap to target position
	if position.distance_to(last_position) >= TILE_SIZE - SPEED * delta:
		position = target_position;
	
	if position == target_position:
		# only get movement direction from input when player is at target position
		move_direction = get_move_direction();
		last_position = position;
		target_position += move_direction * TILE_SIZE;
	
func get_move_direction():
	var right = int(Input.is_action_pressed("ui_right"));
	var left = int(Input.is_action_pressed("ui_left"));
	var down = int(Input.is_action_pressed("ui_down"));
	var up = int(Input.is_action_pressed("ui_up"));
	var x = right - left;
	var y = down - up;
	
	# Prevent diagonal movement...eventually want to allow this!
	if x != 0 && y != 0:
		x = 0;
		y = 0;
	
	return Vector2(x, y);

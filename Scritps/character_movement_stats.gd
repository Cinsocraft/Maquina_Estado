extends Resource
class_name CharacterMovementStats

#region Gestión de movimiento horizontal


@export var input_direction = 0.0
@export var target_speed = 0.0

@export var move_speed:float = 500.0

@export var move_speedTop:float = 500.0

@export var acceleration_speed: float = 5000.0

@export var decceleration_speed: float = 5000.0

#endregion


#region Gestión de movimiento vertical
@export var jump_speed:float = -550.0

@export var coyote_time_actived = false

@export var jump_wall_actived = false

@export var was_wall_R = false

@export var was_wall_L = false

@export var correct_corner:float = 10

@export var wall_slide_speed:float = 200.0

@export var wall_jumpV_force:float = -500.0

@export var wall_jumpH_force:float = -500.0

@export var wall_jumpHL_force:float = 500.0

#Doble Jump

#endregion

#region Gestión vida y powerup

#Vida

@export var time_between_shoot: float = 0.25

@export var can_shoot: bool = false

@export var bulletDirection = Vector2(1,0)
#Disparo o melee

#endregion

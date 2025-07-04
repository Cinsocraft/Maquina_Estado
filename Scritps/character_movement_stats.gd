extends Resource
class_name CharacterMovementStats

#region Gestión de movimiento horizontal
@export var move_speed:float = 500.0

@export var acceleration_speed: float = 500.0

@export var decceleration_speed: float = 500.0

#endregion


#region Gestión de movimiento vertical
@export var jump_speed:float = -500.0

@export var coyote_time_actived = false

@export var jump_wall_actived = false

@export var was_wall_R = false

@export var was_wall_L = false

@export var correct_corner = 3

@export var wall_slide_speed = 200.0

@export var wall_jumpV_force = -550.0

@export var wall_jumpH_force = -650.0

@export var wall_jumpHL_force = 500.0

#Doble Jump

#endregion

#region Gestión vida y powerup

#Vida

#Disparo o melee

#endregion

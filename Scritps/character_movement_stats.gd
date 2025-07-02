extends Resource
class_name CharacterMovementStats

#region Gestión de movimiento horizontal
@export var move_speed:float = 500.0

@export var acceleration_speed: float = 500.0

@export var decceleration_speed: float = 500.0

#endregion


#region Gestión de movimiento vertical
@export var jump_speed:float = -500

@export var coyote_time_actived = false
@export var was_on_floor = false

@export var correct_corner = 3

@export var wall_slide_speed = 1200

#Doble Jump

#endregion

#region Gestión vida y powerup

#Vida

#Disparo o melee

#endregion

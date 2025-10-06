class_name weapons_resource extends Resource


@export var name : StringName


@export_category("Weapon Position")
@export var pos : Vector3
@export var rot : Vector3

@export_category("Animations")


@export_category("Ammo")
@export var curr_ammo : int
@export var mag : int

@export_category("Damage")
@export var dam_high : int
@export var dam_low : int
#@export var dam_type

extends Node

enum Alternatives {NEAR, MID, FAR}
var resource_name: String = "mushroom"
var time_range: int = 20:
	set(value):
		time_range = clampi(value,10,3600)
	get():
		return time_range
var citizens: int = 20:
	set(value):
		citizens = clampi(value,2,100)
	get():
		return citizens

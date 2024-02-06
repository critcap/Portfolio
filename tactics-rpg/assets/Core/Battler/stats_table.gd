tool
class_name StatsDataTable
extends Resource

#region Combat
export(int, 0, 255) var mhp := 0 setget set_mhp
export(int, 0, 255) var wait := 0 setget set_wait
export(int, 0, 255) var spd := 0 setget set_spd
export(int, 0, 255) var atk := 0 setget set_atk
export(int, 0, 255) var def := 0 setget set_def
export(int, 0, 255) var acc := 0 setget set_acc
export(int, 0, 255) var eva := 0 setget set_eva
export(int, 0, 255) var atp := 0 setget set_atp
export(int, 0, 255) var mvp := 0 setget set_mvp
#endregion

#region Movement
export(int, 0, 255) var move := 0 setget set_move
export(int, 0, 255) var jump := 0 setget set_jump
#endregion

export var data: Dictionary = {}


#region
func set_mhp(value):
	mhp = value
	data[StatTypes.MHP] = value


func set_atk(value):
	atk = value
	data[StatTypes.ATK] = value


func set_def(value):
	def = value
	data[StatTypes.DEF] = value


func set_acc(value):
	acc = value
	data[StatTypes.ACC] = value


func set_eva(value):
	eva = value
	data[StatTypes.EVA] = value


func set_atp(value):
	atp = value
	data[StatTypes.ATP] = value


func set_mvp(value):
	mvp = value
	data[StatTypes.MVP] = value


func set_move(value):
	move = value
	data[StatTypes.MOVE] = value


func set_jump(value):
	jump = value
	data[StatTypes.JUMP] = value


func set_wait(value):
	wait = value
	data[StatTypes.WAIT] = value


func set_spd(value):
	spd = value
	data[StatTypes.SPD] = value

#endregion

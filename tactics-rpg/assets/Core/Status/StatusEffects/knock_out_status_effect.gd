class_name KnockOutStatusEffect
extends StatusEffect

var _health: Health

func _init(health: Health) -> void:
	_health = health

func _ready() -> void:
	Notifications.subscribe(TurnController.TURN_CHECK_NOTIFICATION, 	\
							self, 										\
							funcref(self, "on_can_take_turn_check"), 	\
							_health.owner								\
							)
	_health.connect("check_is_alive", self, "on_is_alive_check")


func on_can_take_turn_check(args) -> void:
	var checker = args as BaseException
	if checker.default_toggle == true:
		checker.flip_toggle()


func on_is_alive_check(args: BaseException) -> void:
	if args.default_toggle == true:
		args.flip_toggle()
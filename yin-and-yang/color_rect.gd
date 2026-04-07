extends ColorRect

enum State {
	 ENTER,
	 DIVE,
	 HOLD,
	 RETURN,
	 BREATH
}

@export  var state = State.ENTER
@export var time_passed := 0.0
@export var shader_time := 0.0
@export var ip := 0.0
# ⏱ timings
const MAX_TIME := 40.0
const HOLD_TIME := 0.5
const BREATH_TIME := 2.0

func _process(delta):
	match state:
		State.ENTER:
				time_passed += delta * 0.5
				if time_passed >= 5.0:
					state = State.DIVE

		State.DIVE:
				time_passed += delta * 1.0
				if time_passed >= MAX_TIME:
					time_passed = MAX_TIME
					state = State.HOLD

		State.HOLD:
				time_passed += delta
				if time_passed >= MAX_TIME + HOLD_TIME:
					state = State.RETURN

		State.RETURN:
				time_passed -= delta * 1.2
				if time_passed <= 0.0:
					time_passed = 0.0
					state = State.BREATH

		State.BREATH:
				time_passed -= delta
				if time_passed <= -BREATH_TIME:
					time_passed = 0.0
					state = State.ENTER

	 # 🎯 Smooth easing
	var normalized = clamp(time_passed / MAX_TIME, 0.0, 1.0)
	var eased = 0.5 - 0.5 * cos(normalized * PI)

	shader_time = eased * MAX_TIME

	var mat = material
	if mat:

		var t = Time.get_ticks_msec() * 0.001

	 # 🌀 Morph between Mandelbrot ↔ Julia
		var mix_val = 0.5 + 0.5 * sin(t * 0.5)

		mat.set_shader_parameter("u_c_mix", mix_val)

	 # Optional: also animate the constant itself (VERY COOL)
		var c = Vector2(
		ip * cos(t * 0.3),
		ip * sin(t * 0.2)
		)
		mat.set_shader_parameter("u_c", c)
		material.set_shader_parameter("u_c", c/ip) #Vector2(-0.4, 0.6)
		#material.set_shader_parameter("u_c_mix", 1.0)
		
		mat.set_shader_parameter("u_time", shader_time)
		mat.set_shader_parameter("u_resolution", get_viewport_rect().size)

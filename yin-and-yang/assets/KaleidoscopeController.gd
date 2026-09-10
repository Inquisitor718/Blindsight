extends CanvasItem
## Attach this to the SAME node that has the ShaderMaterial using
## kaleidoscope.gdshader (a ColorRect, Polygon2D, or Sprite2D all work).
## It gives you the two control variables in the Inspector, and animates
## the shader's colors with a tween whenever they change.

enum InnerColor { BLUE, RED, WHITE, YELLOW }

@export var inner: InnerColor = InnerColor.BLUE:
	set(v):
		inner = v
		_tween_color("inner_color", inner_palette[v])

@export_range(1, 3, 1) var outer: int = 1:
	set(v):
		outer = v
		_tween_color("outer_color", outer_palette[v - 1])

@export var transition_time: float = 0.6

var inner_palette: Array[Color] = [
	Color(0.25, 0.45, 1.0), # Blue
	Color(0.95, 0.15, 0.18), # Red
	Color(0.97, 0.97, 0.95), # White
	Color(1.00, 0.85, 0.15), # Yellow
]

var outer_palette: Array[Color] = [
	Color(0.55, 0.42, 0.05), # level 1 - dim yellow
	Color(0.80, 0.62, 0.05), # level 2
	Color(1.00, 0.82, 0.05), # level 3 - hot yellow
]

var _active_tweens := {}

func _ready() -> void:
	_tween_color("inner_color", inner_palette[inner], 0.0)
	_tween_color("outer_color", outer_palette[outer - 1], 0.0)

func _tween_color(param: String, target: Color, duration: float = -1.0) -> void:
	var mat := material as ShaderMaterial
	if mat == null:
		return
	if duration < 0.0:
		duration = transition_time

	if _active_tweens.has(param):
		(_active_tweens[param] as Tween).kill()

	var current = mat.get_shader_parameter(param)
	var from_color: Color = current if current != null else target

	var tw := create_tween()
	_active_tweens[param] = tw
	tw.tween_method(
		func(c: Color): mat.set_shader_parameter(param, c),
		from_color,
		target,
		duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

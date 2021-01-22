extends Node

const _colors = {
	"red": Color8(230, 72, 46), #e6482e
	"yellow": Color8(244, 180, 27), #f4b41b
	"green": Color8(56, 217, 115), #38d973
	"white": Color8(207, 198, 184), #cfc6b8
	"blue": Color8(60, 172, 215), #3cacd7
	"black": Color8(71, 45, 60), #472d3c
	"brown": Color8(122, 68, 74), #7a444a
}

func get_color(col_name):
	if not col_name in _colors:
		print("HEY! Could not find color: %s" % col_name)
		return _colors["white"]
	return _colors[col_name]

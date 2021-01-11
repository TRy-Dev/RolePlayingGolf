extends Node

const EPSILON = 0.0001

# https://forum.processing.org/one/topic/recreate-map-function.html
func map(value, istart, istop, ostart, ostop):
	return ostart + (ostop - ostart) * ((value - istart) / (istop - istart))

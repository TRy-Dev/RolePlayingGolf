extends Node

var _states = {
	"checkpoint": {
		
	},
	"event": {
		
	}
}

func save_state(state_name):
	if not state_name in _states:
		print("State does not exist: %s" % state_name)
		return
	print("save state in %s" % state_name)


func load_state(state_name):
	if not state_name in _states:
		print("State does not exist: %s" % state_name)
		return
	print("load state from %s" % state_name)

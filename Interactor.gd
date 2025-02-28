extends RayCast3D
class_name Interactor

var last_interactable : Variant = null
@onready var interaction_label : Label = $"../../../CanvasLayer/Label"

func _physics_process(_delta: float) -> void:
	if not self.is_colliding():
		if self.last_interactable != null:
			if self.last_interactable.has_method("hide_outline"):
				self.last_interactable.hide_outline()
			self.last_interactable = null
			self.interaction_label.text = ""
		return
		
	var detected : Object = self.get_collider()
	
	if self.last_interactable != detected and  detected is Station or detected is Stock or detected is Interactable:
		if self.last_interactable != null and self.last_interactable.has_method("hide_outline"):
			self.last_interactable.hide_outline() 
			self.interaction_label.text = ""
		
		
		self.last_interactable = detected
		if detected.has_method("get_prompt_message"):
			self.interaction_label.text = self.last_interactable.get_prompt_message()
		elif detected is Station or detected is Stock:
			self.interaction_label.text = detected.name
		elif detected.has_method("get_prompt"):
			self.interaction_label.text = detected.get_prompt()
			if detected.has_method("show_outline"):
				detected.show_outline()
		else:
			self.last_interactable = null
	
	if self.last_interactable != null and Input.is_action_just_pressed("interact"):
		if self.last_interactable is Stock:
			self.last_interactable.get_ingredient()
		elif self.last_interactable is Station:
			self.last_interactable.try_interact(Ingredient.new())
		elif self.last_interactable is Interactable:
			self.last_interactable.interact(null)
			

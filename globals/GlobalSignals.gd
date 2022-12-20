extends Node

# bullet
signal bullet_fired(bullet, position, direction)
signal bullet_impacted(position, direction) # for the blood particle effect

# punch
signal punch_fired(punch, position, direction)

target_x = 0
target_y = 0

final_x = 0
final_y = 0
angle = 0

// camera shake
trauma = 0					// 0..1, current shake "stress" — decays to 0 on its own
trauma_decay = 1.2			// how fast trauma drains per second
max_angle_shake = 4			// degrees, rotation shake at full trauma
max_offset_shake = 6		// pixels, positional shake at full trauma
shake_seed = random(1000)	// randomizes the noise pattern so shake isn't identical every time
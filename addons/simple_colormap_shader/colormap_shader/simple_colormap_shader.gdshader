shader_type spatial;
render_mode vertex_lighting;

// Constants
const vec3 WHITE = vec3(1.0,1.0,1.0);

// Samplers/Textures
uniform sampler2D main_tex : source_color;
uniform sampler2D emission_map : source_color;
uniform sampler2D color_map : source_color,filter_nearest;

// Remap colors
instance uniform vec3 remap_0_red : source_color = vec3(1.0,1.0,1.0);
instance uniform vec3 remap_1_green : source_color = vec3(1.0,1.0,1.0);
instance uniform vec3 remap_2_blue : source_color = vec3(1.0,1.0,1.0);
instance uniform vec3 remap_3_yellow : source_color = vec3(1.0,1.0,1.0);
instance uniform vec3 remap_4_magenta : source_color = vec3(1.0,1.0,1.0);
instance uniform vec3 remap_5_teal : source_color = vec3(1.0,1.0,1.0);

// Functions

int get_pixel_remap_bitmask(vec3 pixel) {
	// Determine which remap color this pixel should be multiplied by, if any
	int final_mask = 0;
	
	float THRESHOLD = 0.9;
	
	if (pixel.r > THRESHOLD) {
		final_mask += 1;
	}
	
	if (pixel.g > THRESHOLD) {
		final_mask += 2;
	}
	
	if (pixel.b > THRESHOLD) {
		final_mask += 4;
	}
	
	return final_mask;
}


vec3 get_pixel_remap_multiplier(vec3 pixel) {
	// Get pixel remap bitmask
	int remap_mask = get_pixel_remap_bitmask(pixel);
	
	vec3 remap_multiplier_array[8] = { WHITE, remap_0_red, remap_1_green, remap_2_blue, remap_3_yellow, remap_4_magenta, remap_5_teal, WHITE };
	
	return remap_multiplier_array[remap_mask];
}


void fragment() {
	// Start with our main tex
	vec3 final_albedo = texture(main_tex,UV).rgb;
	
	// Multiply by this pixel's color map if required
	final_albedo *= get_pixel_remap_multiplier(texture(color_map,UV).rgb);
	
	// Get our final emission map by multiplying the result of our color remap by the value on our emission map
	vec3 final_emission = final_albedo * texture(emission_map,UV).rgb;
	
	// Apply the final result
	ALBEDO = final_albedo;
	EMISSION = final_emission;
}

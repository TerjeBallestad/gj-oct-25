shader_type canvas_item;

instance uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D crack_mask; // The second texture for the pattern

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    // Get the color of the main sprite (A) and the main UV coordinates
    vec4 base_color = texture(TEXTURE, UV);
    
    // Get the value of the crack mask at this pixel
    // Assuming the mask is grayscale, we take the red channel (or any single channel)
    float mask_value = texture(crack_mask, UV).r;
    
    // The "cutoff" is where we compare the mask to the progress.
    // Use the step() function for a sharp transition:
    float alpha_cutoff = step(mask_value, progress);
    
    // The resulting color's alpha is the base color's alpha multiplied by the cutoff
    COLOR = vec4(base_color.rgb, base_color.a * alpha_cutoff);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

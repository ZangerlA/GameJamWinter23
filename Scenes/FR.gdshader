shader_type canvas_item;

void vertex() {
    // Parameters for the jump
    float jump_height = 20.0; // Maximum height of the jump
    float jump_width = 10.0;  // Width of the jump (left and right movement)
    float speed = 10.0; // Speed of the jump

    // Calculate a value that oscillates between 0 and 1
    float t = sin(TIME * speed) * 0.5 + 0.5;

    // Adjust the jump curve for a more natural motion (ease in and out)
    float jump_curve = pow(4.0 * t * (1.0 - t), 2.0);

    // Calculate the vertical offset for the jump
    float jump_offset_y = jump_curve * jump_height;

    // Calculate the horizontal offset for the jump (arc-like trajectory)
    float jump_offset_x = cos(TIME * speed) * jump_width;

    // Apply the offsets to the vertex position
    VERTEX.x += jump_offset_x;
    VERTEX.y += jump_offset_y;
}

void fragment() {
    // Disco light effect
    float disco_light_frequency = 4.0;  // Frequency of color change
    vec3 disco_colors = vec3(
        abs(sin(TIME * disco_light_frequency)),  // Red channel
        abs(sin(TIME * disco_light_frequency + 2.0)),  // Green channel
        abs(sin(TIME * disco_light_frequency + 4.0))   // Blue channel
    );

    // Blend the original texture color with the disco colors
    vec4 original_color = texture(TEXTURE, UV);
    COLOR = vec4(mix(original_color.rgb, disco_colors, 0.5), original_color.a);
}
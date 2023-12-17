shader_type canvas_item;

void fragment() {
    // Calculate scale factor based on the beat
    float scaleFactor = 1.0 + 0.8 * 0.05; // Scales up to 5% on the beat

    // Calculate the new UV coordinates
    vec2 newUV = (UV - vec2(0.5, 0.5)) * scaleFactor + vec2(0.5, 0.5);

    // Sample the texture with new UV coordinates
    COLOR = texture(TEXTURE, newUV);
}

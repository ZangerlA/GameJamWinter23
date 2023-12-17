shader_type canvas_item;

void vertex() {
    // Wave parameters
    float wave_amplitude = 20.0; // How much the flower sways
    float wave_frequency = 2.0; // How fast the flower sways
    float half_height = 0.5; // Threshold for the upper half (relative to sprite height)

    // Determine the relative y position (0.0 at bottom, 1.0 at top)
    float relative_y = ((VERTEX.y + 0.5) / 1.0) * -1.0; // Adjust if the pivot is not at the center
    // Apply the wave effect only to the upper half
    if (relative_y > half_height) {
        VERTEX.x += sin(VERTEX.y + TIME * wave_frequency) * wave_amplitude;
    }
}
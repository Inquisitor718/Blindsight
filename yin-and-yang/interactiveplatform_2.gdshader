shader_type particles;

uniform float spread_strength = 0.02;

void process() {
    float dist = abs(TRANSFORM[3].x);

    float spread = dist * spread_strength;

    VELOCITY.x += TRANSFORM[3].x * spread;
    VELOCITY.y = -200.0;
}
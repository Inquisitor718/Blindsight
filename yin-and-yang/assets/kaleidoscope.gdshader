shader_type canvas_item;

// ============================================================
// KALEIDOSCOPE SHADER
// Two regions: a central circle ("inner") and the surrounding
// corner wedges ("outer"). Both are filled with small swarming
// "stick" particles that fade to transparent at both ends.
//
// Colors are driven from GDScript (see KaleidoscopeController.gd)
// so that changing "inner" / "outer" in the Inspector smoothly
// animates the color transition instead of hard-cutting.
// If you don't attach the script, you can still drive
// inner_color / outer_color directly from this material's
// Inspector panel — they just won't auto-tween on their own.
// ============================================================

// ---- colors (set by script, or by hand in the Inspector) ----
uniform vec4 inner_color : source_color = vec4(0.25, 0.45, 1.0, 1.0); // current inner color (blue/red/white/yellow)
uniform vec4 outer_color : source_color = vec4(0.55, 0.42, 0.05, 1.0); // current outer yellow intensity

// ---- kaleidoscope shape ----
uniform float wedges : hint_range(3.0, 24.0) = 6.0;        // mirror-fold count (6 = classic 3-mirror triangular kaleidoscope)
uniform float inner_radius : hint_range(0.05, 0.6) = 0.28;  // radius of the central circle
uniform float edge_softness : hint_range(0.0, 0.3) = 0.06;  // blend width between inner circle and outer corners

// ---- particle look ----
uniform float density : hint_range(2.0, 40.0) = 14.0;       // sticks per wedge tile
uniform float stick_length : hint_range(0.05, 0.9) = 0.35;  // as a fraction of one grid cell
uniform float stick_width : hint_range(0.01, 0.35) = 0.10;  // as a fraction of one grid cell
uniform float swarm_speed : hint_range(0.0, 3.0) = 0.6;     // drifting motion speed
uniform float swirl_speed : hint_range(0.0, 3.0) = 0.6;     // per-particle rotation speed

// ---- optional: swap procedural sticks for a texture ----
uniform sampler2D particle_texture : source_color, filter_linear;
uniform bool use_particle_texture = false;

float hash21(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

vec2 hash22(vec2 p) {
    return vec2(hash21(p), hash21(p + vec2(19.19, 7.7)));
}

float sd_segment(vec2 p, vec2 a, vec2 b) {
    vec2 pa = p - a;
    vec2 ba = b - a;
    float h = clamp(dot(pa, ba) / max(dot(ba, ba), 0.0001), 0.0, 1.0);
    return length(pa - ba * h);
}

// draws one field of swarming sticks in grid-space "p" (already * density)
vec4 sticks_layer(vec2 gp, float len_frac, float wid_frac, float t, vec4 col, vec2 seed) {
    vec2 cell = floor(gp);
    vec4 result = vec4(0.0);

    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 c = cell + vec2(float(x), float(y));
            vec2 rnd = hash22(c + seed);

            // swarming drift, unique per particle
            float phase = rnd.x * 6.2831853;
            vec2 drift = vec2(sin(t * swarm_speed + phase), cos(t * swarm_speed * 1.3 + phase)) * 0.22;
            vec2 center = c + vec2(0.5) + drift;

            // slow independent rotation
            float ang = rnd.y * 6.2831853 + t * swirl_speed * (rnd.x - 0.5) * 2.0;
            vec2 dir = vec2(cos(ang), sin(ang));

            float half_len = len_frac * 0.5;
            vec2 a = center - dir * half_len;
            vec2 b = center + dir * half_len;

            float d = sd_segment(gp, a, b);
            float shape = 1.0 - smoothstep(wid_frac * 0.4, wid_frac, d);

            // alpha gradient fading out at BOTH ends of the stick
            vec2 pa = gp - a;
            vec2 ba = b - a;
            float along = clamp(dot(pa, ba) / max(dot(ba, ba), 0.0001), 0.0, 1.0);
            float end_fade = smoothstep(0.0, 0.22, along) * smoothstep(1.0, 0.78, along);

            float alpha = shape * end_fade;
            result = max(result, vec4(col.rgb, col.a * alpha));
        }
    }
    return result;
}

void fragment() {
    vec2 uv = UV - vec2(0.5);
    float radius = length(uv);
    float angle = atan(uv.y, uv.x);

    // ---- triangular mirror fold ----
    float seg = TAU / wedges;
    float a = mod(angle, seg);
    a = abs(a - seg * 0.5);
    vec2 folded = radius * vec2(cos(a), sin(a));

    float t = TIME;

    vec2 gp_inner = folded * density;
    vec2 gp_outer = folded * (density * 0.85);

    vec4 innerLayer = sticks_layer(gp_inner, stick_length, stick_width, t, inner_color, vec2(0.0));
    vec4 outerLayer = sticks_layer(gp_outer, stick_length * 1.2, stick_width * 1.15, t * 0.85, outer_color, vec2(31.0, 7.0));

    if (use_particle_texture) {
        innerLayer.a *= texture(particle_texture, fract(gp_inner)).a;
        outerLayer.a *= texture(particle_texture, fract(gp_outer)).a;
    }

    float innerMask = 1.0 - smoothstep(inner_radius - edge_softness, inner_radius + edge_softness, radius);

    vec3 rgb = mix(outerLayer.rgb, innerLayer.rgb, innerMask);
    float alpha = mix(outerLayer.a, innerLayer.a, innerMask);

    COLOR = vec4(rgb, alpha);
}

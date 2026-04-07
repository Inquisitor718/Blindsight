shader_type canvas_item;

uniform vec2 u_resolution;
uniform float u_time;

// 🎨 Controls
uniform vec3 u_base_color = vec3(0.2, 0.6, 1.0);
uniform vec3 u_inner_color = vec3(0.02, 0.0, 0.05);
uniform float u_inner_glow = 0.3;

uniform vec2 u_c = vec2(-0.8, 0.156);
uniform float u_c_mix = 0.0; // 0 = Mandelbrot, 1 = Julia

uniform vec2 u_center = vec2(-0.74364388703, 0.13182590421);
uniform float u_zoom_speed = 0.15;

// HSV → RGB
vec3 hsv2rgb(vec3 c) {
    vec3 rgb = clamp(abs(mod(c.x * 6.0 + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0,
                     0.0,
                     1.0);
    return c.z * mix(vec3(1.0), rgb, c.y);
}

void fragment() {
    vec2 uv = (FRAGCOORD.xy - 0.5 * u_resolution) / u_resolution.y;

    float zoom = exp(u_time * u_zoom_speed);

    vec2 center = u_center + vec2(
        0.0005 * sin(u_time * 0.3),
        0.0005 * cos(u_time * 0.2)
    );

    vec2 pos = center + uv / zoom;

// Blend between Mandelbrot and Julia
    vec2 c = mix(pos, u_c, u_c_mix);
    vec2 z = mix(vec2(0.0), pos, u_c_mix);

    // 🫀 ORGANIC MOTION
    float breath = 0.5 + 0.5 * sin(u_time * 0.6);

    vec2 flow = vec2(
        sin(uv.y * 4.0 + u_time * 0.8),
        cos(uv.x * 4.0 + u_time * 0.7)
    );

    float angle = length(uv) * 2.0 + u_time * 0.5;
    vec2 swirl = vec2(cos(angle), sin(angle));

    float base_strength = (0.002 + breath * 0.003) / zoom;

    // 🔁 MANDELBROT
    //vec2 z = vec2(0.0);
    float iter = 0.0;
    float escape_mag = 0.0;

    float maxIter = 100.0 + log(zoom) * 20.0;

    for (int i = 0; i < 300; i++) {
        if (float(i) > maxIter) break;

        float x = z.x*z.x - z.y*z.y + c.x;
        float y = 2.0*z.x*z.y + c.y;

        z = vec2(x, y);

        float mag = length(z);

        if (mag > 2.0) {
            iter = float(i);
            escape_mag = mag;
            break;
        }

        iter = float(i);
    }

    // 🧬 Tail-based distortion
    float tail_factor = clamp(escape_mag / 4.0, 0.0, 1.0);
    c += (flow * 0.6 + swirl * 0.4) * base_strength * tail_factor;

    // =========================
    // 🎨 COLOR + 3D DEPTH
    // =========================

    vec3 final_color;

    if (iter >= maxIter - 1.0) {
        // 🧊 INNER REGION (with glow)
        float glow = u_inner_glow * (0.5 + 0.5 * sin(u_time * 1.5));
        final_color = u_inner_color + glow;
    } else {
        // Smooth coloring
        float log_zn = log(dot(z, z)) / 2.0;
        float nu = log(log_zn / log(2.0)) / log(2.0);
        float mu = iter + 1.0 - nu;

        float t = mu / maxIter;

        // 🌈 Color
        float base_hue = atan(u_base_color.g, u_base_color.r) / (2.0 * 3.141592);
        float hue = fract(base_hue + t * 0.5 + u_time * 0.05);

        vec3 col = hsv2rgb(vec3(hue, 0.8, 0.9));

        // =========================
        // 🧊 FAKE 3D LIGHTING
        // =========================

        float depth = t;

        // Fake normal from gradient
        float dx = dFdx(mu);
        float dy = dFdy(mu);
        vec3 normal = normalize(vec3(dx, dy, 0.01));

        // Light direction
        vec3 light_dir = normalize(vec3(0.3, 0.4, 1.0));

        float diffuse = dot(normal, light_dir) * 0.5 + 0.5;

        // Depth shading
        float fog = exp(-depth * 2.0);

        col *= diffuse;
        col *= fog;

        // Slight glow
        col += 0.15 * sin(vec3(3.0, 5.0, 7.0) * t + u_time);

        final_color = col;
    }

    COLOR = vec4(final_color, 1.0);
}
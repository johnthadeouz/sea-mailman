shader_type spatial;
render_mode blend_mix, cull_disabled, unshaded;
uniform float speed_wave : hint_range(0.0, 50.0, 0.1) = 1.0;
uniform float speed_flicker : hint_range(0.0, 50.0, 0.1) = 1.0;

void fragment() {
    float edge_fade = 1.0 - length(UV * 2.0 - 1.0);
    
    float wave = sin((TIME * speed_wave) * 2.0 + UV.x * 3.0) * 0.5 + 0.5;
    
    float alpha = edge_fade * wave;
    alpha = smoothstep(0.0, 0.8, alpha);
    
    float flicker = sin((TIME * speed_flicker) * 5.0 + UV.y * 10.0) * 0.1 + 0.9;
    
    ALPHA = alpha * flicker * 0.7;
    
    vec3 base_color = COLOR.rgb;
    EMISSION = base_color * (wave * 0.5 + 0.5);
}

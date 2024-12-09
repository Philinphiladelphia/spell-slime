shader_type canvas_item;

uniform float edge_transparency : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE;
    float dist = min(uv.x, min(uv.y, min(1.0 - uv.x, 1.0 - uv.y)));
    float alpha = smoothstep(0.0, edge_transparency, dist);
    COLOR.a *= alpha;
}
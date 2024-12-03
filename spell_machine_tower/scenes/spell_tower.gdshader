shader_type canvas_item;

float remap(float value, float in_min, float in_max)
{
	return (value - in_min) / (in_max - in_min);
}

void fragment()
{
	float fade_value = 1. - (distance(UV, vec2(.5,.5)) * 2.);
	fade_value = remap(fade_value, .01,.6);
	COLOR.a = mix(0.,1., fade_value);
}
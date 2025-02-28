shader_type canvas_item;

uniform sampler2D screen_texture  : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D lightTexture;
uniform sampler2D noiseTexture;
uniform sampler2D splatsTexture : repeat_enable;

float hash11(float seed)
{
    return fract(sin(seed*123.456)*123.456);
}

vec3 rdr(vec2 uv)
{
    vec2 px = vec2(.01, 0.02)*.15;
    vec2 pxn = px*2.;
    //uv = floor(uv/px)*px;
    vec3 light = texture(lightTexture, uv).xyz;
	float noise = texture(noiseTexture, uv).x;
    return texture(screen_texture, uv).xyz+hash11(TIME+noise)*.05+light*.1;
}

vec3 blur(vec2 uv, float screenSize)
{
    uv.x += hash11(TIME)*.0005;
    vec3 acc = vec3(0.);
    const float cnt = 8.;
    for(float i = 0.;i < cnt; ++i)
    {
        float f = i+TIME*.1;
        vec2 off = vec2(sin(f), cos(f))*i*screenSize*.5*0.5;
        acc+= rdr(uv+off);
    }
    acc = acc/cnt;
    return acc;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 bg = texture(screen_texture, SCREEN_UV);
	bg.xyz = blur(SCREEN_UV, SCREEN_PIXEL_SIZE.x);
	bg.xyz += texture(splatsTexture, SCREEN_UV*1.5).xyz*0.05;
	bg.xyz -= texture(splatsTexture, -SCREEN_UV*1.2).xyz*.07;
	bg.xyz = mix(bg.xyz, vec3(1.)*(bg.x+bg.y+bg.z)/3.0, 0.5);
	COLOR = vec4(bg.xyz,1);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

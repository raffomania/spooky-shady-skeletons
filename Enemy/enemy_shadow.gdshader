// NOTE: Shader automatically converted from Godot Engine 4.1.1.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix,depth_prepass_alpha,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 shadow_color : source_color;
//how much bigger is the floor plane than the Billboard
uniform float size;
// uniform float shadow_angle;
uniform vec3 light_position;

uniform float debug : hint_range(-5,30);
uniform float debug2 : hint_range(-5,5);

// front 0
// back 1
// left 2
// right 3
uniform int direction : hint_range(0,3);
uniform sampler2D front_texture : source_color,filter_linear,repeat_enable; 
uniform sampler2D back_texture : source_color,filter_linear,repeat_enable;
uniform sampler2D looking_left_texture : source_color,filter_linear,repeat_enable;
uniform sampler2D looking_right_texture : source_color,filter_linear,repeat_enable;
uniform sampler2D idle_texture : source_color,filter_linear,repeat_enable;
uniform bool idle;

//animation
uniform int h_frames;
uniform int v_frames;
uniform int total_frames;
uniform float animation_progress : hint_range(0,1);

vec2 rotate(vec2 uv, vec2 pivot, float angle) {
	mat2 rotation = mat2(vec2(sin(angle), -cos(angle)),
						vec2(cos(angle), sin(angle)));
	
	uv -= pivot;
	uv = uv * rotation;
	uv += pivot;
	return uv;
}

void fragment() {
	vec2 base_uv = UV;

	//shadow uv transformation 
    // scale size
	base_uv = base_uv * size;
    //translate sprite sheet to anim frame 0
    base_uv -= (size / 2.0) - 0.5;

    // move shadow to bottom of leg
    base_uv.y += 0.5;

    vec3 shadow_vector = normalize(light_position - NODE_POSITION_WORLD);

    // calculate shadow angle
    vec3 midpoint = vec3(0.5,0.0,1.0);
    float dot_ = shadow_vector.x;
    float det = shadow_vector.z;
    float shadow_angle = atan(det,dot_);
    base_uv = rotate(base_uv, midpoint.xz, shadow_angle + PI);

    //calculate shadow stretch
    float stretch = exp(0.85 * dot(vec3(0.0, 1.0, 0.0), shadow_vector));
    base_uv.y = base_uv.y * (1.0 - stretch) + stretch;

    // trimming
    if (base_uv.x > 1.0) {
        discard;
    }
    if (base_uv.y > 1.0) {
        discard;
    }
    if (base_uv.x < 0.0) {
        discard;
    }
    if (base_uv.y < 0.0) {
        discard;
    }

    //uv frame calc for animation
    int current_frame = int(animation_progress * float(total_frames));   
    int tile_pos_x = current_frame % h_frames;
    int tile_pos_y = current_frame / v_frames;
    base_uv = vec2((float(base_uv.x) + float(tile_pos_x)) / float(h_frames), (float(base_uv.y) + float(tile_pos_y)) / float(v_frames));

    // directions
    vec4 albedo_tex;
    if (direction == 0) {
        albedo_tex = texture(front_texture,base_uv);
    } else if (direction == 1) {
        albedo_tex = texture(back_texture,base_uv);
    } else if (direction == 2) {
        albedo_tex = texture(looking_left_texture,base_uv);
    } else {
        albedo_tex = texture(looking_right_texture,base_uv);
    }

    if (idle) {
        albedo_tex = texture(idle_texture,base_uv);
    }

    ALBEDO = shadow_color.xyz;
    ALPHA = albedo_tex.a * shadow_color.a;
}

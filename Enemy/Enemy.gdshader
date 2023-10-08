// NOTE: Shader automatically converted from Godot Engine 4.1.1.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : source_color;
uniform float point_size : hint_range(0,128);
uniform float roughness : hint_range(0,1);
uniform sampler2D texture_metallic : hint_default_white,filter_linear_mipmap,repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r,filter_linear_mipmap,repeat_enable;
uniform float specular;
uniform float metallic;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

// front 0
// back 1
// left 2
// right 3
uniform int direction : hint_range(0,3);
uniform sampler2D front_texture : source_color,filter_nearest_mipmap,repeat_enable; 
uniform sampler2D back_texture : source_color,filter_nearest_mipmap,repeat_enable;
uniform sampler2D looking_left_texture : source_color,filter_nearest_mipmap,repeat_enable;
uniform sampler2D looking_right_texture : source_color,filter_nearest_mipmap,repeat_enable;
// TODO: add left and right up?
// uniform sampler2D back_texture : source_color,filter_linear_mipmap,repeat_enable;
// uniform sampler2D back_texture : source_color,filter_linear_mipmap,repeat_enable;

uniform float hit_animation : hint_range(0,1);
uniform vec4 hit_anim_color : source_color;

//animation
uniform int h_frames;
uniform int v_frames;
uniform int total_frames;
uniform float animation_progress : hint_range(0,1);
// uniform int current_frame; // calculate in shader based on beat

void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}

void fragment() {
	vec2 base_uv = UV;

    // calculate current frame
    int current_frame = int(animation_progress * float(total_frames));   
    int tile_pos_x = current_frame % h_frames;
    int tile_pos_y = current_frame / v_frames;

    //uv frame calc for animation
    base_uv = vec2((float(base_uv.x) + float(tile_pos_x)) / float(h_frames), (float(base_uv.y) + float(tile_pos_y)) / float(v_frames));
    //  directions
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

    ALBEDO = albedo_tex.rgb + (hit_anim_color.rgb * float(hit_animation));
    ALPHA = albedo_tex.a;
}
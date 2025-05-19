void light_cell_shading(
    vec3 normal,
    vec3 light,
    float attenuation,
    vec3 light_color,
    sampler2D gradiente_color,
    inout vec3 diffuse_light
) {
    float productopunto = clamp(dot(normal, light), -0.9, 0.9);
    float sample = clamp((productopunto + 0.1) * attenuation / 2.1, 0.05, 0.95);
    vec4 shaded = texture(gradiente_color, vec2(sample, 0.0));
    diffuse_light += clamp(shaded.rgb * light_color, 0.0, 1.0);
}

void light_cell_shading_suelo(
    vec3 normal,
    vec3 light,
    float attenuation,
    vec3 light_color,
    sampler2D gradiente_color,
    inout vec3 diffuse_light
) {
    float productopunto = clamp(dot(normal, light), -0.9, 0.9);
    float sample = clamp((productopunto + 0.1) * attenuation / 2.1, 0.05, 0.95);
    vec4 shaded = texture(gradiente_color, vec2(sample, 0.0));
	diffuse_light += clamp(dot(normal, light), 0.0, 1.0) * light_color * attenuation * 0.4;
    diffuse_light += clamp(shaded.rgb * light_color, 0.0, 1.0);
}

void mezcla(
	vec2 uv,
    vec3 normal,
    vec3 light,
    float attenuation,
    vec3 light_color,
    sampler2D gradiente_color,
	sampler2D ruido_lambert,
    inout vec3 diffuse_light,
    float blend_factor // entre 0.0 y 1.0
) {
    // Cell shading duro
    float hard = clamp(dot(normal, light), -0.9, 0.9);
    float hard_sample = clamp((hard + 0.1) * attenuation / 2.1, 0.05, 0.95);
    vec3 hard_shaded = texture(gradiente_color, vec2(hard_sample, 0.0)).rgb * light_color;
     
	// Difusión suave estilo Lambert con ruido
	float soft = max(dot(normal, light), 0.0);
	
	// Aquí sí podés condicionar si querés afectar el valor
    vec3 soft_shaded = vec3(0.0);
	soft_shaded = light_color * attenuation;
	
	
	vec3 color_final = mix(hard_shaded, soft_shaded, blend_factor) * 1.5;
	diffuse_light += color_final; //clamp(color_final, 0.0, 1.2); 
}


//fresnel-----------------------------------------------------------------------
float fresnel(float cantidad, vec3 normal, vec3 view){
	return pow((1.0 - clamp(dot(normalize(normal)*0.2,normalize(view)), 0.0, 0.1)), cantidad);
}

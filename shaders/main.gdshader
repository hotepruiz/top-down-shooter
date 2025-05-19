shader_type spatial;
render_mode unshaded; // Desactiva la iluminación para este pass

// Variable para acumular la intensidad de la luz
uniform sampler2D texture_overlay; // Textura PNG transparente
uniform float alpha : hint_range(0.0, 1.0) = 1.0; // Control de transparenci

void fragment() {
    vec4 overlay_color = texture(texture_overlay, UV);
    ALBEDO = overlay_color.rgb;
    ALPHA = overlay_color.a * alpha; // Aplica la transparencia
}
/*
shader_type spatial;
render_mode unshaded; // Desactiva la iluminación predeterminada

uniform sampler2D texture_overlay; // Textura de brillo pintada a mano
uniform float alpha : hint_range(0.0, 1.0) = 0.0; // Control de transparencia (ajustable desde GDScript)

void vertex() {
    // Billboarding: Hacer que la textura siempre mire hacia la cámara
    mat4 model_view = INV_VIEW_MATRIX * MODEL_MATRIX;
    model_view[0] = vec4(1.0, 0.0, 0.0, 0.0); // Fijar eje X
    model_view[1] = vec4(0.0, 1.0, 0.0, 0.0); // Fijar eje Y
    model_view[2] = vec4(0.0, 0.0, 1.0, 0.0); // Fijar eje Z
    VERTEX = (model_view * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
    // Mostrar la textura de brillo
    vec4 overlay_color = texture(texture_overlay, UV);
    ALBEDO = overlay_color.rgb;
    ALPHA = overlay_color.a * alpha; // Aplicar transparencia
}*/


struct vertex_data {
    
    float4 position [[position]];
    
    float4 color;
};

[[vertex]] vertex_data vertex_shader() {
    return vertex_data();
}

[[fragment]] float4 fragment_shader(vertex_data in [[stage_in]]) {
    return in.color;
}

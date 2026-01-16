
struct vertex_out {
    float4 position [[position]];
    float4 color;
};

[[vertex]] vertex_out vertex_shader() {
    return {float4(0, 0, 0, 1), float4(0, 0, 0, 1)};
}

[[fragment]] float4 fragment_shader(vertex_out in [[stage_in]]) {
    return in.color;
}

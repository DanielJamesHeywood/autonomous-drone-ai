
struct VertexOut {
    float4 position [[position]];
    float4 color;
};

[[vertex]] VertexOut vertexShader(uint id [[vertex_id]]) {
    return {float4(0, 0, 0, 1), float4(0, 0, 0, 1)};
}

[[fragment]] float4 fragmentShader(VertexOut in [[stage_in]]) {
    return in.color;
}

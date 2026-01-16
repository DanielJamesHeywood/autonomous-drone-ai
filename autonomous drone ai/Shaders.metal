
struct VertexIn {
    float3 position;
    float3 color;
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
};

[[vertex]] VertexOut vertexShader(uint id [[vertex_id]]) {
    switch (id) {
        case 0:
            return {float4(-1, -1, 0, 1), float4(0, 0, 0, 1)};
        case 1:
            return {float4(-1, 1, 0, 1), float4(1, 0, 0, 1)};
        case 2:
            return {float4(1, -1, 0, 1), float4(0, 1, 1, 1)};
        case 3:
            return {float4(1, 1, 0, 1), float4(1, 1, 1, 1)};
        default:
            return VertexOut();
    }
}

[[fragment]] float4 fragmentShader(VertexOut in [[stage_in]]) {
    return in.color;
}

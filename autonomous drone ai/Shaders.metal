#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float3 position;
    float3 color;
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
};

[[vertex]] VertexOut vertexShader(
    uint id [[vertex_id]],
    const device VertexIn* vertices [[buffer(0)]],
    constant float4x4& modelViewProjectionMatrix [[buffer(1)]]
) {
    return {modelViewProjectionMatrix * float4(vertices[id].position, 1), float4(vertices[id].color, 1)};
}

[[fragment]] float4 fragmentShader(VertexOut in [[stage_in]]) {
    return in.color;
}

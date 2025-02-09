#version 150

// shader by link2_thepast, based on depth_test shader by onnowhere

in vec2 texCoord;
in vec2 oneTexel;

uniform sampler2D DiffuseSampler;
uniform sampler2D DiffuseDepthSampler;

out vec4 fragColor;

void main() {
    float d = texture(DiffuseDepthSampler, texCoord).r-.000001;
    vec4 dv = vec4(d);
    dv = dv*vec4(255.*255.*255.,255.*255.,255.,1.);
    dv = fract(dv);
    fragColor = dv;
}

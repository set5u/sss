#version 150

// shader by link2_thepast, based on depth_test shader by onnowhere

in vec2 texCoord;
in vec2 oneTexel;

uniform sampler2D DiffuseSampler;
uniform sampler2D DiffuseDepthSampler;

out vec4 fragColor;

void main() {

    float zScale = 256.;

    vec2 tex0 = texCoord - oneTexel;
    vec2 tex1 = vec2(texCoord.x, texCoord.y + oneTexel.y);
    vec2 tex2 = vec2(texCoord.x + oneTexel.x, texCoord.y);

    vec3 pos0 = vec3(-oneTexel, (1.-texture(DiffuseDepthSampler, tex0).r) * zScale);
    vec3 pos1 = vec3(vec2(oneTexel.x, 0.), (1.-texture(DiffuseDepthSampler, tex1).r) * zScale);
    vec3 pos2 = vec3(vec2(0., oneTexel.y), (1.-texture(DiffuseDepthSampler, tex2).r) * zScale);
    
    vec3 v0 = pos1 - pos0;
    vec3 v1 = pos2 - pos0;
    vec3 n = normalize(cross(v0, v1)).grb;
    fragColor = vec4((n+1.)*.5,1.);
}

#version 150

in vec2 texCoord;
in vec2 oneTexel;

uniform sampler2D DiffuseSampler;
uniform sampler2D DiffuseDepthSampler;

out vec4 fragColor;

void main() {
    const float siz = 1.;
    vec3 d = texture(DiffuseSampler, texCoord).rgb;
    vec3 e = texture(DiffuseSampler, vec2(texCoord.x+oneTexel.x*siz,texCoord.y)).rgb;
    vec3 f = texture(DiffuseSampler, vec2(texCoord.x,texCoord.y+oneTexel.y*siz)).rgb;
    vec3 g = texture(DiffuseSampler, vec2(texCoord.x-oneTexel.x*siz,texCoord.y)).rgb;
    vec3 h = texture(DiffuseSampler, vec2(texCoord.x,texCoord.y-oneTexel.y*siz)).rgb;
    float di = dot(abs(e-d)+abs(f-d)+abs(g-d)+abs(h-d),vec3(1.,1.,1.));
    const float th = .3;
    fragColor = vec4(di < th ? d : (d+e+f+g+h)/5.,1.);
}

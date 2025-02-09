#version 150

// shader by link2_thepast, based on depth_test shader by onnowhere

in vec2 texCoord;
in vec2 oneTexel;
in vec3 vPosition;

uniform sampler2D DiffuseSampler;
uniform sampler2D DiffuseDepthSampler;
uniform sampler2D DiffuseNormalSampler;
uniform sampler2D DiffuseCMainSampler;
uniform sampler2D DiffuseCTainSampler;
uniform sampler2D DiffuseCDepthSampler;

uniform float GameTime;

out vec4 fragColor;
float random(vec2 st) {
  return fract(sin(dot(st.xy, vec2(12.9898,78.233)))* 43758.5453123)*2.-1.;
}

void main() {    

    const float noiseness = .4;
    const float ts = 8.;
    vec4 tex = texture(DiffuseSampler, texCoord);
    const float zScale = 1.1;
    float depth = pow(zScale,texture(DiffuseDepthSampler, texCoord).r*16.)/16.;

    vec2 centCoord = texCoord * 2. -1.;
    vec3 rp = vec3(centCoord,depth);
    vec3 sRayPos = vec3(0.,0.,0.);
    vec3 sRayDir = normalize(rp-sRayPos);
    float sRayLen = length(rp);
    vec3 rayPos = sRayPos;
    vec3 rayDir = sRayDir;
    float rayLen = sRayLen;
    vec3 color = vec3(.5);
    vec3 fColor = vec3(0.);
    float at = 1.;
    float bt = 1.;
    int j = 0;
    for(float i = 0;i < 64.;i++,j++){
      vec3 rayEnd = rayPos + rayDir * rayLen;
      float rd = pow(zScale,texture(DiffuseDepthSampler, rayEnd.xy*.5+.5).r*16.)/16.;
      vec3 crNorm = ((texture(DiffuseNormalSampler,rayEnd.xy*.5+.5).rgb*2.-1.)).rgb;
      bool invF = dot(crNorm,rayDir) < .0;
      if((invF && abs(rd-rayEnd.z) < rd*.1)||all(equal(sRayPos,rayPos))){
        vec3 difC = texture(DiffuseSampler,rayEnd.xy*.5+.5).rgb;
        difC *= 1.5;
        vec3 diff = difC+pow(difC,vec3(10.));
        color = color*diff;
        at *= .8;
        rayPos = rayEnd;
        rayDir = normalize(reflect(-rayDir,crNorm)+noiseness*vec3(random(texCoord+GameTime+i),random(texCoord+GameTime+i+1.),random(texCoord+GameTime+i-1.)));
        rayLen = .15;
        j = 0;
      }else{
        float tt = (rayEnd.z - rd);
        rayLen += tt;
      }
      if(at < .1 || rayLen < 0. || rayEnd.x < -1. || rayEnd.x > 1. || rayEnd.y < -1. || rayEnd.y > 1.||j > 4){
        fColor = mix(fColor,color,1./bt);
        color = vec3(.5);
        bt++;
        at = 1.;
        rayPos = sRayPos;
        rayDir = sRayDir;
        rayLen = sRayLen;
        j = 0;
      }
    }        
    fColor = mix(fColor,color,1./bt);
    fragColor = vec4(fColor+tex.rgb,1.);
}

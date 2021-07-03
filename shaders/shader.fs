#version 330 core

in vec2 texCoord;
out vec4 fragColor;

uniform sampler2D tex;

void main()
{
    //float alpha = floor(mod(gl_FragCoord.y, 2.0));

    //fragColor = vec4(1.0, 0.0, 0.0, 1.0);
    fragColor = texture(tex, texCoord);
    //fragColor = texCoord.xyxy;
}
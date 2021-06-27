#version 330 core

in vec2 texCoord;
out vec4 fragColor;

//uniform sampler2D texture0;

void main()
{
    float alpha = floor(mod(gl_FragCoord.y, 2.0));

    fragColor = vec4(0.0f, 0.5f, 0.0f, alpha);
    //fragColor = texture(texture0, texCoord);
}
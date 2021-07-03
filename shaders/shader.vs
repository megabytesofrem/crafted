#version 330 core
layout (location = 0) in vec3 aPosition;
layout (location = 1) in vec2 aTexCoord;

uniform mat4 mvp; // model view projection matrix
out vec2 texCoord;

void main()
{
    //texCoord = aTexCoord;
    
    //gl_Position = vec4(aPosition, 1.0);
    gl_Position = mvp * vec4(aPosition, 1.0);
    texCoord = aTexCoord;
}
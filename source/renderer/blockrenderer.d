module renderer.blockrenderer;

import shader;
import std.conv : to;
import std.stdio;

import bindbc.opengl;

class BlockRenderer
{
    GLuint vao; // vertex array
    GLuint vbo; // vertex buffer object (sent to gpu)

    GLfloat[] vertices = [
        // position
        
        // first tri
        -0.5f, -0.5f, 0.5f, // bottom left
         0.5f, -0.5f, 0.5f, // bottom right
         0.5f,  0.5f, 0.5f, // top right

        // second tri
        -0.5f, -0.5f, 0.5f, // bottom left
        -0.5f,  0.5f, 0.5f, // top left
         0.5f,  0.5f, 0.5f, // top right
    ];

    public this() {
        // generate vao
        glGenVertexArrays(1, &vao);
        glBindVertexArray(vao);

        // generate and bind vbo
        glGenBuffers(1, &vbo);
        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER, vertices[0].sizeof * vertices.length, vertices.ptr, GL_STATIC_DRAW);
    }

    public void render(Shader shader) {
        glBindVertexArray(vao);

        // we have 3 floats for x, y, z position
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * float.sizeof, cast(void*)0);
        glEnableVertexAttribArray(0);

        shader.use();

        glDrawArrays(GL_TRIANGLES, 0, vertices.length.to!int);
    }
}
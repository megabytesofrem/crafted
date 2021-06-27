module renderer.quadrenderer;


import shader;
import std.conv : to;
import std.stdio;

import bindbc.opengl;

/** Experimental quad renderer to try and play with OpenGL more */
class QuadRenderer
{
    GLuint vao; // vertex array
    GLuint vbo; // vertex buffer object (sent to gpu)
    GLuint vboColors;

    GLint colorAttrib;

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

    GLfloat[] colors = [
        1.0, 0.0, 0.0, // R
        0.0, 1.0, 0.0, // G
        0.0, 0.0, 0.0, // B
        1.0, 1.0, 0.0, // Y?
    ];

    public this(Shader shader) {
        // generate vao
        glGenVertexArrays(1, &vao);
        glBindVertexArray(vao);

        // generate and bind vbo
        glGenBuffers(1, &vbo);
        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER, vertices[0].sizeof * vertices.length, vertices.ptr, GL_STATIC_DRAW);

        // bind colors vbo
        glGenBuffers(1, &vboColors);
        glBindBuffer(GL_ARRAY_BUFFER, vboColors);
        glBufferData(GL_ARRAY_BUFFER, colors.sizeof, colors.ptr, GL_STATIC_DRAW);

        colorAttrib = glGetAttribLocation(shader.program, "v_color");
    }

    public void render(Shader shader) {
        glBindVertexArray(vao);

        // we have 3 floats for x, y, z position
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, null);
        glEnableVertexAttribArray(0);

        // copy color information and tell opengl the layout
        glEnableVertexAttribArray(colorAttrib);
        glBindBuffer(GL_ARRAY_BUFFER, vboColors);
        glVertexAttribPointer(colorAttrib, 3, GL_FLOAT, GL_FALSE, 0, null);

        shader.use();

        glDrawArrays(GL_TRIANGLES, 0, vertices.length.to!int);
    }
}
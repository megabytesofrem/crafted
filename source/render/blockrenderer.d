module render.blockrenderer;

import engine.shader;
import std.conv : to;
import std.stdio;

import bindbc.opengl;

class BlockRenderer
{
    Shader sh;

    GLuint vao; // vertex array
    GLuint vbo; // vertex buffer object (sent to gpu)

    GLuint ebo;

    GLfloat[] vertices = [
        // positions        UV coords

        // Front face
        -1.0, -1.0,  1.0,   0.0, 0.0,   // bottom left,       (+x and +y)
        1.0, -1.0,  1.0,    0.0, 1.0,   // bottom right     (+x and -y)
        1.0,  1.0,  1.0,    1.0, 1.0,   // top right      (-x and -y)
        -1.0,  1.0,  1.0,   1.0, 0.0,   // top left     (+x and -y)

        // Back face
        -1.0, -1.0, -1.0,   0.0, 0.0,
        -1.0,  1.0, -1.0,   0.0, 1.0,
        1.0,  1.0, -1.0,    1.0, 1.0,
        1.0, -1.0, -1.0,    1.0, 0.0,

        // Top face
        -1.0,  1.0, -1.0,   1.0, 1.0,
        -1.0,  1.0,  1.0,   1.0, 0.0,
        1.0,  1.0,  1.0,    0.0, 0.0,
        1.0,  1.0, -1.0,    0.0, 1.0,

        // Bottom face
        -1.0, -1.0, -1.0,   1.0, 1.0,
        1.0, -1.0, -1.0,    1.0, 0.0,
        1.0, -1.0,  1.0,    0.0, 0.0,
        -1.0, -1.0,  1.0,   0.0, 1.0,

        // Right face
        1.0, -1.0, -1.0,    1.0, 1.0,
        1.0,  1.0, -1.0,    1.0, 0.0,
        1.0,  1.0,  1.0,    0.0, 0.0,
        1.0, -1.0,  1.0,    0.0, 1.0,

        // Left face
        -1.0, -1.0, -1.0,   1.0, 1.0,
        -1.0, -1.0,  1.0,   1.0, 0.0,
        -1.0,  1.0,  1.0,   0.0, 0.0,
        -1.0,  1.0, -1.0,   0.0, 1.0,  
    ];

    GLuint[] indices = [
        0, 1, 2,        0, 2, 3,    // front
        4, 5, 6,        4, 6, 7,    // back
        8,  9,  10,     8,  10, 11, // top
        12, 13, 14,     12, 14, 15, // bottom
        16, 17, 18,     16, 18, 19, // right
        20, 21, 22,     20, 22, 23, // left       
    ];

    public void bindShader(Shader sh) {
        this.sh = sh;
    }

    public this() {
        // generate vao
        glGenVertexArrays(1, &vao);
        glBindVertexArray(vao);

        // generate and bind vbo
        glGenBuffers(1, &vbo);
        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER, vertices[0].sizeof * vertices.length, vertices.ptr, GL_STATIC_DRAW);
    
        glGenBuffers(1, &ebo);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices[0].sizeof * indices.length, indices.ptr, GL_STATIC_DRAW);
    

        // we have 3 floats for x, y, z position
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 5 * float.sizeof, cast(void*)0);
        glEnableVertexAttribArray(0);

        // .. and our texture coords


        glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 5 * float.sizeof, cast(void*)(3 * float.sizeof));
        glEnableVertexAttribArray(1);    
    }

    public void render(Shader shader) {
        //glBindVertexArray(vao);
        shader.use();

        glDrawElements(GL_TRIANGLES, vertices.length.to!int, GL_UNSIGNED_INT, null);
        //glDrawArrays(GL_TRIANGLES, 0, vertices.length.to!int);
    }
}
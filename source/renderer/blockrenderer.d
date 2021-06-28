module renderer.blockrenderer;

import engine.shader;
import std.conv : to;
import std.stdio;

import bindbc.opengl;

class BlockRenderer
{
    GLuint vao; // vertex array
    GLuint vbo; // vertex buffer object (sent to gpu)

    GLuint elementBuffer;

    GLfloat[] vertices;
    GLuint[] indices;

    private void setupArrays() {
        vertices = [
            // position
            
            // front
            -1.0, -1.0, 1.0, // bottom left
            1.0, -1.0, 1.0, // bottom right
            1.0,  1.0, 1.0, // top right
            -1.0,  1.0, 1.0, // top left

            // back
            -1.0, -1.0, -1.0, // bottom left
            1.0, -1.0, -1.0, // bottom right
            1.0,  1.0, -1.0, // top right
            -1.0,  1.0, -1.0, // top left
        ];

        indices = [
            // front
            0, 1, 2,
            2, 3, 0,
            // right
            1, 5, 6,
            6, 2, 1,
            // back
            7, 6, 5,
            5, 4, 7,
            // left
            4, 0, 3,
            3, 7, 4,
            // bottom
            4, 5, 1,
            1, 0, 4,
            // top
            3, 2, 6,
            6, 7, 3
        ];
    }

    public this() {
        setupArrays();

        // generate vao
        glGenVertexArrays(1, &vao);
        glBindVertexArray(vao);

        // generate and bind vbo
        glGenBuffers(1, &vbo);
        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER, vertices[0].sizeof * vertices.length, vertices.ptr, GL_STATIC_DRAW);

        // bind element buffer
        glGenBuffers(1, &elementBuffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, elementBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.sizeof, indices.ptr, GL_STATIC_DRAW);

        glBindVertexArray(vao);

        // we have 3 floats for x, y, z position
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * float.sizeof, cast(void*)0);
        glEnableVertexAttribArray(0);
    }

    public void render(Shader shader) {
        shader.use();
        glDrawElements(GL_TRIANGLES, indices.length.to!int, GL_UNSIGNED_INT, null);
    }
}
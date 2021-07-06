module render.blockrenderer;

import engine.shader;
import render.blockmesh;

import std.conv : to;
import std.stdio;

import bindbc.opengl;

class BlockRenderer
{
    private Shader shader;

    /// The associated block mesh
    public BlockMesh mesh;

    // GL internals
    private GLuint vao; // vertex array
    private GLuint vbo; // vertex buffer object (sent to gpu)
    private GLuint ebo;

    private GLfloat[] vertices;
    private GLuint[] indices;

    public this() {
        // generate vao
        glGenVertexArrays(1, &vao);
        glBindVertexArray(vao);

        this.mesh.addFaces([BlockFace.front, 
                            BlockFace.back, 
                            BlockFace.bottom,
                            BlockFace.left,
                            BlockFace.right]);

        writefln("faces: %('%s', %)", mesh.faces);

        this.vertices = mesh.vertices;
        this.indices = mesh.indices;

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
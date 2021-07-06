module render.blockrenderer;

import engine.shader;
import render.vertex;
import render.blockmesh;

import std.conv : to;
import std.stdio;

import bindbc.opengl;

class BlockRenderer
{
    import engine.primitives : Vertex;

    private Shader shader;

    /// The associated block mesh
    public BlockMesh mesh;

    // GL internals
    private GLuint vao; // vertex array
    private GLuint vbo; // vertex buffer object (sent to gpu)
    private GLuint ebo;

    private Vertex[] vertices;
    private GLuint[] indices;

    public this()
    {
        // generate vao
        glGenVertexArrays(1, &vao);
        glBindVertexArray(vao);

        this.mesh.addFace(BlockFace.front);

        this.mesh.addFace(BlockFace.bottom);
        this.mesh.addFace(BlockFace.back);
        this.mesh.addFace(BlockFace.left);
        this.mesh.addFace(BlockFace.right);

        writefln("faces: %('%s', %)", mesh.faces);

        this.vertices = mesh.vertices;
        this.indices = mesh.indices;

        // generate and bind vbo
        glGenBuffers(1, &vbo);
        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER, Vertex.sizeof * vertices.length,
                vertices.ptr, GL_STATIC_DRAW);

        glGenBuffers(1, &ebo);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.sizeof * indices.length,
                indices.ptr, GL_STATIC_DRAW);

        // we have 3 floats for x, y, z position
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, Vertex.sizeof,
                cast(void*) Vertex.position.offsetof);
        glEnableVertexAttribArray(0);

        // .. and our texture coords
        glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, Vertex.sizeof,
                cast(void*) Vertex.texture.offsetof);
        glEnableVertexAttribArray(1);
    }

    public void render(Shader shader)
    {
        //glBindVertexArray(vao);
        shader.use();

        glDrawElements(GL_TRIANGLES, indices.length.to!int, GL_UNSIGNED_INT, null);
        //glDrawArrays(GL_TRIANGLES, 0, vertices.length.to!int);
    }
}

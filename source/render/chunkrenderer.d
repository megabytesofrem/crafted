module render.chunkrenderer;

import engine.primitives;
import engine.shader;
import render.blockmesh;
import world.blockdata;

import std.stdio;
import std.conv : to;
import std.algorithm : canFind;
import dplug.math.vector;
import bindbc.opengl;

class ChunkRenderer
{
    private BlockMesh[] meshes;
    public Block[] chunk;

    // GL internals
    private GLuint vao; // vertex array
    private GLuint vbo; // vertex buffer object (sent to gpu)
    private GLuint ebo;

    private Vertex[] vertices;
    private GLuint[] indices;

    public void generateChunk(float xDepth, float yDepth, float zDepth)
    {
        Block block;

        for (float x = 0; x < xDepth; x++)
        {
            for (float y = 0; y < yDepth; y++)
            {
                for (float z = 0; z < zDepth; z++)
                {

                    block = Block(BlockType.cobble, true, vec3f(x, y, z));
                    if (!chunk.canFind(block))
                    {
                        chunk ~= block;
                    }
                }
            }
        }
    }

    public void setupRenderer()
    {
        // Generate VAO
        glGenVertexArrays(1, &vao);
        glBindVertexArray(vao);

        // Generate meshes
        // TODO: be smart and check for neighbor blocks and only render visible faces

        foreach (Block block; chunk)
        {
            BlockMesh bmesh;
            bmesh.addFaces([
                    BlockFace.top, BlockFace.right, BlockFace.left,
                    BlockFace.bottom, BlockFace.front, BlockFace.back
                    ]);

            foreach (Vertex vtx; bmesh.vertices)
            {
                vtx.position.x += block.position.x + 10;
                vtx.position.y += block.position.y + 10;
                vtx.position.z += block.position.z + 10;

                writefln("vertex pos: %f,%f,%f", vtx.position.x, vtx.position.y, vtx.position.z);
            }

            meshes ~= bmesh;
        }

        // Combine the vertices from the meshes
        foreach (BlockMesh m; meshes)
        {
            vertices ~= m.vertices;
            indices ~= m.indices;
        }

        // Generate and bind VBO
        glGenBuffers(1, &vbo);
        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER, Vertex.sizeof * vertices.length,
                vertices.ptr, GL_STATIC_DRAW);

        glGenBuffers(1, &ebo);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, GLuint.sizeof * indices.length,
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
        shader.use();

        glDrawElements(GL_TRIANGLES, vertices.length.to!int, GL_UNSIGNED_INT, null);
    }
}

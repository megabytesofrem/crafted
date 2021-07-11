module render.chunkrenderer;

import engine.shader;
import render.blockmesh;

import dplug.math.matrix;
import dplug.math.vector;
import bindbc.opengl;

class ChunkRenderer
{
    import std.stdio : writefln;

    import std.conv : to;
    import world.blockdata : Block, BlockType;
    import engine.primitives : Vertex;

    private enum chunkWidth = 5;
    private enum chunkHeight = 5;
    private enum chunkDepth = 5;

    private ubyte[chunkWidth][chunkWidth][chunkWidth] chunk;

    private Shader shader;
    public mat4f modelMatrix;
    private Vertex[] vertices;

    private GLuint vao;
    private GLuint vbo;

    public this()
    {
    }

    public void generate()
    {
        ubyte block = 1;
        for (int z = 0; z < chunkDepth; z++)
        {
            for (int y = 0; y < chunkHeight; y++)
            {
                for (int x = 0; x < chunkWidth; x++)
                {
                    chunk[x][y][z] = block;
                    //writefln("x: %d y: %d z: %d", x, y, z);
                    writefln("%d", x);

                    // Loop through the vertices
                    BlockMesh mesh = new BlockMesh();

                    vec3f offset = vec3f(x, y, z);
                    mesh.buildFace(BlockFace.front, offset);
                    mesh.buildFace(BlockFace.back, offset);
                    mesh.buildFace(BlockFace.left, offset);
                    mesh.buildFace(BlockFace.right, offset);
                    mesh.buildFace(BlockFace.top, offset);
                    mesh.buildFace(BlockFace.bottom, offset);
                    vertices ~= mesh.vertices;
                    
                }
            }
        }
    }

    public void setupRenderer()
    {
        // Generate VAO
        glGenVertexArrays(1, &vao);
        glBindVertexArray(vao);

        this.generate();

        writefln("vertices (setupRenderer):");
        foreach (vtx; vertices)
        {
            writefln("v: %f\t%f\t%f", vtx.position.x, vtx.position.y, vtx.position.z);
        }
    
        // Generate and bind VBO
        glGenBuffers(1, &vbo);
        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER, Vertex.sizeof * vertices.length,
                vertices.ptr, GL_STATIC_DRAW);

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

        glDrawArrays(GL_TRIANGLES, 0, vertices.length.to!int);
    }
}

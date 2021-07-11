module render.chunkrenderer;

import engine.shader;
import render.blockmesh;

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
    public BlockMesh mesh;
    private Vertex[] vertices;

    private GLuint vao;
    private GLuint vbo;

    public this()
    {
        this.mesh = new BlockMesh();
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
                    BlockMesh msh = new BlockMesh();
                    vec3f offset = vec3f(x, y, z);
                    msh.buildFace(BlockFace.front, offset);
                    msh.buildFace(BlockFace.back, offset);
                    msh.buildFace(BlockFace.left, offset);
                    msh.buildFace(BlockFace.right, offset);
                    msh.buildFace(BlockFace.top, offset);
                    msh.buildFace(BlockFace.bottom, offset);
                    vertices ~= msh.vertices;
                    
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

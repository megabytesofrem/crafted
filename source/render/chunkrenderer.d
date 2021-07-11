module render.chunkrenderer;

import engine.shader;
import render.blockmesh;

import bindbc.opengl;

class ChunkRenderer
{
    import std.conv : to;
    import world.blockdata : Block, BlockType;
    import engine.primitives : Vertex;

    private enum chunkWidth = 5;
    private enum chunkHeight = 4;
    private enum chunkDepth = 4;

    private ubyte[chunkDepth][chunkHeight][chunkWidth] chunk;

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
        // Generate a mesh
        this.mesh.buildFace(BlockFace.front);
        this.mesh.buildFace(BlockFace.bottom);
        this.mesh.buildFace(BlockFace.top);
        //this.mesh.buildFace(BlockFace.back);
        this.mesh.buildFace(BlockFace.left);
        //this.mesh.buildFace(BlockFace.right);

        foreach (x; 0 .. chunkWidth)
        {
            foreach (y; 0 .. chunkHeight)
            {
                foreach (z; 0 .. chunkDepth)
                {
                    chunk[x][y][z] = block;

                    // Loop through the vertices
                    foreach (ref vtx; this.mesh.vertices)
                    {
                        vtx.position.x += x;
                        vtx.position.y += y;
                        vtx.position.z += z;
                    }

                    vertices ~= this.mesh.vertices;
                    
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

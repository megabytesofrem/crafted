module render.blockmesh;

import engine.shader;
import engine.primitives;

import dplug.math.vector;
import dplug.math.matrix;
import bindbc.opengl;

enum BlockFace : string
{
    front = "front",
    back = "back",
    top = "top",
    bottom = "bottom",
    left = "left",
    right = "right"
}

struct BlockMesh
{
    private Vertex[] _vertices;
    private GLuint[] _indices;

    public mat4f modelMatrix;

    private BlockFace[] _faces;

    /// The vertices in the mesh
    public @property Vertex[] vertices()
    {
        return this._vertices;
    }

    /// The indices (element buffer array indices) in the mesh
    public @property GLuint[] indices()
    {
        return this._indices;
    }

    public @property void vertices(Vertex[] newVertices)
    {
        this._vertices = newVertices;
    }

    /// The (visible) faces in the mesh
    public @property BlockFace[] faces()
    {
        return this._faces;
    }

    private Vertex[] verticesForFace(BlockFace face)
    {
        Vertex[] verts;

        final switch (face)
        {
        case BlockFace.front:
            //        position                         UV
            verts ~= Vertex(vec3f(-1, -1, 1), vec2f(0.0, 0.0)); // bottom left
            verts ~= Vertex(vec3f(1, -1, 1), vec2f(0.0, 1.0)); // bottom right
            verts ~= Vertex(vec3f(1, 1, 1), vec2f(1.0, 1.0)); // top right
            verts ~= Vertex(vec3f(-1, 1, 1), vec2f(1.0, 0.0)); // top left
            break;
        case BlockFace.back:
            verts ~= Vertex(vec3f(-1, -1, -1), vec2f(0.0, 0.0));
            verts ~= Vertex(vec3f(-1, 1, -1), vec2f(0.0, 1.0));
            verts ~= Vertex(vec3f(1, 1, -1), vec2f(1.0, 1.0));
            verts ~= Vertex(vec3f(1, -1, -1), vec2f(1.0, 0.0));
            break;
        case BlockFace.top:
            verts ~= Vertex(vec3f(-1, 1, -1), vec2f(0.0, 0.0));
            verts ~= Vertex(vec3f(-1, 1, 1), vec2f(0.0, 1.0));
            verts ~= Vertex(vec3f(1, 1, 1), vec2f(1.0, 1.0));
            verts ~= Vertex(vec3f(1, 1, -1), vec2f(1.0, 0.0));
            break;
        case BlockFace.bottom:
            verts ~= Vertex(vec3f(-1, -1, -1), vec2f(0.0, 0.0));
            verts ~= Vertex(vec3f(1, -1, -1), vec2f(0.0, 1.0));
            verts ~= Vertex(vec3f(1, -1, 1), vec2f(1.0, 1.0));
            verts ~= Vertex(vec3f(-1, -1, 1), vec2f(1.0, 0.0));
            break;
        case BlockFace.left:
            verts ~= Vertex(vec3f(-1, -1, -1), vec2f(0.0, 0.0));
            verts ~= Vertex(vec3f(-1, -1, 1), vec2f(0.0, 1.0));
            verts ~= Vertex(vec3f(-1, 1, 1), vec2f(1.0, 1.0));
            verts ~= Vertex(vec3f(-1, 1, -1), vec2f(1.0, 0.0));
            break;
        case BlockFace.right:
            verts ~= Vertex(vec3f(1, -1, -1), vec2f(0.0, 0.0));
            verts ~= Vertex(vec3f(1, 1, -1), vec2f(0.0, 1.0));
            verts ~= Vertex(vec3f(1, 1, 1), vec2f(1.0, 1.0));
            verts ~= Vertex(vec3f(1, -1, 1), vec2f(1.0, 0.0));
            break;
        }

        return verts;
    }

    /++
        Add multiple faces to be rendered to the block mesh.
     +/
    public void addFaces(BlockFace[] faces)
    {
        foreach (face; faces)
        {
            this.addFace(face);
        }
    }

    /++
        Add a single face to the block mesh
     +/
    public void addFace(BlockFace face)
    {
        auto verts = verticesForFace(face);
        GLuint[] indexes;

        final switch (face)
        {
        case BlockFace.front:
            indexes ~= [0, 1, 2, 0, 2, 3];
            break;
        case BlockFace.back:
            indexes ~= [4, 5, 6, 4, 6, 7];
            break;
        case BlockFace.top:
            indexes ~= [8, 9, 10, 8, 10, 11];
            break;
        case BlockFace.bottom:
            indexes ~= [12, 13, 14, 12, 14, 15];
            break;
        case BlockFace.left:
            indexes ~= [20, 21, 22, 20, 22, 23];
            break;
        case BlockFace.right:
            indexes ~= [16, 17, 18, 16, 18, 19];
            break;
        }

        this._faces ~= face;

        this._vertices ~= verts;
        this._indices ~= indexes;
    }
}

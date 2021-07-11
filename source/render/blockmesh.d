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

class BlockMesh
{
    import util.vertexbuilder : VertexBuilder;

    public mat4f modelMatrix;
    public VertexBuilder builder;

    private BlockFace[] _faces;

    this()
    {
        this.builder = new VertexBuilder();
    }

    /// The vertices in the mesh
    public @property Vertex[] vertices()
    {
        return this.builder.vertices;
    }

    /// The (visible) faces in the mesh
    public @property BlockFace[] faces()
    {
        return this._faces;
    }

    public void buildFace(BlockFace face)
    {
        Vertex[] verts;
        //enum1 = 0;

        switch (face)
        {
        case BlockFace.front:
            // dfmt off
            builder.push([
                Vertex(vec3f(0, 0, 1), vec2f(0.0, 1.0)), // 0
                Vertex(vec3f(1, 0, 1), vec2f(1.0, 1.0)), // 1
                Vertex(vec3f(1, 1, 1), vec2f(1.0, 0.0)), // 2
                
                Vertex(vec3f(0, 0, 1), vec2f(0.0, 1.0)), // 0
                Vertex(vec3f(1, 1, 1), vec2f(1.0, 0.0)), // 2
                Vertex(vec3f(0, 1, 1), vec2f(0.0, 0.0)), // 3
            ]);
            // dfmt on
            break;
        case BlockFace.back:
            // dfmt off
            builder.push([
                Vertex(vec3f(1, 1, 0), vec2f(1.0, 0.0)),// 6
                Vertex(vec3f(0, 1, 0), vec2f(0.0, 0.0)),// 5
                Vertex(vec3f(0, 0, 0), vec2f(0.0, 1.0)),// 4

                Vertex(vec3f(1, 0, 0), vec2f(1.0, 1.0)),// 7
                Vertex(vec3f(1, 1, 0), vec2f(1.0, 0.0)),// 6
                Vertex(vec3f(0, 0, 0), vec2f(0.0, 1.0)),// 4
            ]);
            // dfmt on
            break;
        case BlockFace.top:
            // dfmt off
            builder.push([
                Vertex(vec3f(1, 1, 1), vec2f(1.0, 0.0)),// 10
                Vertex(vec3f(0, 1, 1), vec2f(0.0, 0.0)),// 9
                Vertex(vec3f(0, 1, 0), vec2f(0.0, 1.0)),// 8

                Vertex(vec3f(1, 1, 0), vec2f(1.0, 1.0)),// 11
                Vertex(vec3f(1, 1, 1), vec2f(1.0, 0.0)),// 10
                Vertex(vec3f(0, 1, 0), vec2f(0.0, 1.0)),// 8
            ]);
            // dfmt on
            break;
        case BlockFace.bottom:
            // dfmt off
            builder.push([
                Vertex(vec3f(0, 0, 0), vec2f(0.0, 1.0)),// 9
                Vertex(vec3f(0, 0, 1), vec2f(0.0, 0.0)), // 10
                Vertex(vec3f(1, 0, 1), vec2f(1.0, 0.0)), // 11

                Vertex(vec3f(0, 0, 0), vec2f(0.0, 1.0)),// 12
                Vertex(vec3f(1, 0, 1), vec2f(1.0, 0.0)),// 13
                Vertex(vec3f(1, 0, 0), vec2f(1.0, 1.0)) // 14
            ]);
            // dfmt on
            break;
        case BlockFace.left:
            // TODO: fix UVs so they are not mirrored on the Y axis
            // dfmt off
            builder.push([
                Vertex(vec3f(0, 1, 1), vec2f(0.0, 1.0)), // 17
                Vertex(vec3f(0, 0, 1), vec2f(0.0, 0.0)), // 16
                Vertex(vec3f(0, 0, 0), vec2f(1.0, 0.0)), // 15

                Vertex(vec3f(0, 1, 0), vec2f(1.0, 1.0)), // 18
                Vertex(vec3f(0, 1, 1), vec2f(0.0, 1.0)), // 17
                Vertex(vec3f(0, 0, 0), vec2f(1.0, 0.0)), // 15
            ]);
            // dfmt on
            break;
        case BlockFace.right:
            // TODO: fix UVs so they are not mirrored on the Y axis
            // dfmt off
            builder.push([
                Vertex(vec3f(1, 0, 0), vec2f(0.0, 1.0)), // 19
                Vertex(vec3f(1, 1, 0), vec2f(0.0, 0.0)), // 20
                Vertex(vec3f(1, 1, 1), vec2f(1.0, 0.0)), // 21

                Vertex(vec3f(1, 0, 0), vec2f(0.0, 0.0)), // 22
                Vertex(vec3f(1, 1, 1), vec2f(0.0, 1.0)), // 23
                Vertex(vec3f(1, 0, 1), vec2f(1.0, 0.0)), // 24
            ]);
            // dfmt on
            break;
        default:
            break;
        }

        this._faces ~= face;
    }

    /++
        Add multiple faces to be rendered to the block mesh.
     +/
    public void buildFaces(BlockFace[] faces)
    {
        foreach (face; faces)
        {
            this.buildFace(face);
        }
    }
}

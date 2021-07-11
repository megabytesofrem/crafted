module util.vertexbuilder;

import std.container.array;
import engine.primitives : Vertex;

/++
    Utility class to build a mesh from vertices (defined in normalized device coordinates)
 +/
class VertexBuilder 
{
    import std.conv : to;

    private Vertex[] _vertices;

    /// Array of the vertices
    public @property Vertex[] vertices()
    {
        return this._vertices;
    }

    public void push(Vertex v)
    {
        _vertices ~= v;
    }

    public void push(Vertex[] verts)
    {
        foreach (v; verts)
        {
            _vertices ~= v;
        }
    }

    public Vertex pop()
    {
        auto backVertex = _vertices[$ - 1];
        _vertices.length--;

        return backVertex;
    }
}
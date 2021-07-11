module world.blockdata;

import dplug.math.vector;

enum BlockType : string
{
    air     = "air",
    grass   = "grass",
    stone   = "stone",
    cobble  = "cobble",
    wood    = "wood"
}

struct Block
{
    BlockType type;
    bool isVisible;

    vec3f position;

    this(BlockType type, bool isVisible, vec3f position)
    {
        import std.stdio : writefln;
        writefln("block pos (ctor): %f,%f,%f", position.x, position.y, position.z);

        this.type = type;
        this.isVisible = isVisible;
        this.position = position;
    }
}
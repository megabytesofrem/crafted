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
}
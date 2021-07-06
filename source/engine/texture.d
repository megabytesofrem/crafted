module engine.texture;

import std.stdio;
import std.file : getcwd;
import bindbc.opengl;

import dlib.image.io;
import dlib.image;

struct Texture
{
    private int _handle;

    public @property int handle()
    {
        return this._handle;
    }

    /++
        Load a texture from a bitmap file and return a new Texture
     +/
    public static Texture loadBitmap(string path)
    {
        writefln("path is %s", getcwd ~ "/" ~ path);

        auto image = loadBMP(getcwd ~ "/" ~ path);
        auto data = image.data;
        writefln("loaded data: %d size", image.data.length);

        // Generate the textures
        uint textureHandle;
        glGenTextures(1, &textureHandle);
        glBindTexture(GL_TEXTURE_2D, textureHandle);

        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 16, 16, 0, GL_RGB, GL_UNSIGNED_BYTE, data.ptr);

        // Texture wrap and filtering (nearest neighbor)
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_R, GL_REPEAT);

        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

        glGenerateMipmap(GL_TEXTURE_2D);
        return Texture(textureHandle);
    }

    public void use(uint unit)
    {
        glActiveTexture(unit);
        glBindTexture(GL_TEXTURE_2D, this._handle);
    }

    this(int handle)
    {
        this._handle = handle;
    }
}

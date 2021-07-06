module engine.shader;

import std.stdio : writefln;
import std.string : toStringz, fromStringz;
import std.file : readText;

import dplug.math.matrix;
import bindbc.opengl;

struct Shader
{
    private GLint _program;
    private GLuint _vertexShader, _fragmentShader;

    // Properties

    /// The compiled shader program
    public @property int program()
    {
        return this._program;
    }

    /// A reference to the compiled vertex shader
    public @property uint vertexShader()
    {
        return this._vertexShader;
    }

    /// A reference to the compiled fragment shader
    public @property uint fragmentShader()
    {
        return this._fragmentShader;
    }

    /++
        Load the vertex and fragment shaders from the two specified paths and
        link and compile them together into a shader program.
     +/
    public void loadSource(string vtxPath, string fragPath)
    {
        const(char*) vtxSource = readText(vtxPath).toStringz;
        const(char*) frgSource = readText(fragPath).toStringz;

        int vtxSuccess, frgSuccess;

        // Compile the vertex shader
        _vertexShader = glCreateShader(GL_VERTEX_SHADER);
        glShaderSource(_vertexShader, 1, &vtxSource, null);
        glCompileShader(_vertexShader);

        glGetShaderiv(_vertexShader, GL_COMPILE_STATUS, &vtxSuccess);
        if (!vtxSuccess)
            writeInfoLog(GL_VERTEX_SHADER, _vertexShader);

        // Compile the fragment shader
        _fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
        glShaderSource(_fragmentShader, 1, &frgSource, null);
        glCompileShader(_fragmentShader);

        glGetShaderiv(_fragmentShader, GL_COMPILE_STATUS, &frgSuccess);
        if (!frgSuccess)
            writeInfoLog(GL_FRAGMENT_SHADER, _fragmentShader);

        // Create the shader program
        _program = glCreateProgram();

        glAttachShader(program, vertexShader);
        glAttachShader(program, fragmentShader);
        glLinkProgram(program);

        this.freeShaders();
    }

    /++
        Write the provided shaders info log out to standard input.
        Note: shaderType can be either GL_VERTEX_SHADER or GL_FRAGMENT_SHADER. Anything else
        is invalid.
     +/
    public void writeInfoLog(uint shaderType, uint shaderId)
    {
        int len;
        glGetShaderiv(shaderId, GL_INFO_LOG_LENGTH, &len);

        if (len > 0)
        {
            char[] buf = new char[len];
            glGetShaderInfoLog(shaderId, len, null, buf.ptr);

            final switch (shaderType)
            {
            case GL_VERTEX_SHADER:
                writefln("Compile failed for vertex shader: %s", buf);
                break;
            case GL_FRAGMENT_SHADER:
                writefln("Compile failed for fragment shader: %s", buf);
                break;
            }
        }
    }

    /++
        Set a uniform on the shader to a specified value.
     +/
    public void setUniform(string uniform, int value)
    {
        const loc = glGetUniformLocation(this.program, uniform.toStringz);
        glUniform1i(loc, value);
    }

    /// ditto
    public void setUniform(string uniform, float value)
    {
        const loc = glGetUniformLocation(this.program, uniform.toStringz);
        glUniform1f(loc, value);
    }

    /// ditto
    public void setUniform(string uniform, mat4f matrix)
    {
        const loc = glGetUniformLocation(this.program, uniform.toStringz);
        glUniformMatrix4fv(loc, 1, GL_FALSE, matrix.transposed.ptr);
    }

    /++ 
        Set the shader as the current active shader and tell OpenGL to use it.
     +/
    public void use()
    {
        glUseProgram(program);
    }

    private void freeShaders()
    {
        // free the shader manually after being used
        glDeleteShader(vertexShader);
        glDeleteShader(fragmentShader);
    }
}

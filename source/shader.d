module shader;

import std.stdio : writefln;
import std.string : toStringz;
import std.file : readText;

import derelict.opengl;
import derelict.glfw3.glfw3;

/// Manage a shader loaded from a file
struct Shader
{
    private int _program;
    private uint _vertexShader, _fragmentShader;

    // Properties
    public @property int program() { return this._program; }

    public @property uint vertexShader() {
        return this._vertexShader;
    }

    public @property uint fragmentShader() {
        return this._fragmentShader;
    }

    public void loadVertexSource(string vertexPath) {
        auto source = readText(vertexPath);
        const char* csource = cast(const char*)source.toStringz;
    
        // compile the vertex shader
        _vertexShader = glCreateShader(GL_VERTEX_SHADER);
        glShaderSource(vertexShader, 1, &csource, null);

        int success;
        char[512] infoLog;
        glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);

        // check for errors
        if (!success) {
            glGetShaderInfoLog(vertexShader, 512, null, infoLog.ptr);
            writefln("compilation failed for vertex shader: %s", infoLog);
        }
    }

    public void loadFragmentSource(string fragmentPath) {
        auto source = readText(fragmentPath);
        const char* csource = cast(const char*)source.toStringz;
    
        // compile the fragment shader
        _fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
        glShaderSource(fragmentShader, 1, &csource, null);

        int success;
        char[512] infoLog;
        glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);

        // check for errors
        if (!success) {
            glGetShaderInfoLog(fragmentShader, 512, null, infoLog.ptr);
            writefln("compilation failed for fragment shader: %s", infoLog);
        }
    }

    public void applyTransformation4f(string uniform, mat4 transform) {
        this.use();

        int location = glGetUniformLocation(program, uniform);
        if (location != -1)
            glUniformMatrix4fv(location, 1, ROW_MAJOR, transform.value_ptr);
    }

    public void createProgram() {
        _program = glCreateProgram();

        glAttachShader(program, vertexShader);
        glAttachShader(program, fragmentShader);
        glLinkProgram(program);

        freeShaders();
    }

    public void use() {
        glUseProgram(program);
    }

    public void freeShaders() {
        // free the shader manually after being used
        glDeleteShader(vertexShader);
        glDeleteShader(fragmentShader);
    }
}
module engine.shader;

import std.stdio : writefln;
import std.string : toStringz, fromStringz;
import std.file : readText;

import dplug.math.matrix;
import bindbc.opengl;

/**
    Manage a vertex or fragment shader loaded from a file
*/
struct Shader
{
    private GLint _program;
    private GLuint _vertexShader, _fragmentShader;

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
        const char* csource = source.toStringz;
    
        writefln("source: %s", csource.fromStringz);

        // compile the vertex shader
        _vertexShader = glCreateShader(GL_VERTEX_SHADER);
        glShaderSource(_vertexShader, 1, &csource, null);

        glCompileShader(_vertexShader);

        int success;
        glGetShaderiv(_vertexShader, GL_COMPILE_STATUS, &success);

        // check for errors
        if (!success) {
            int bufflen;
            glGetShaderiv(_vertexShader, GL_INFO_LOG_LENGTH, &bufflen);

            char[] buff = new char[bufflen];
            glGetShaderInfoLog(_vertexShader, bufflen, null, buff.ptr);
            writefln!"compilation failed for vertex shader: %s"(buff);
        }

    }

    public void loadFragmentSource(string fragmentPath) {
        auto source = readText(fragmentPath);
        const char* csource = source.toStringz;
    
        // compile the fragment shader
        _fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
        glShaderSource(_fragmentShader, 1, &csource, null);
        glCompileShader(_fragmentShader);

        int success;
        glGetShaderiv(_fragmentShader, GL_COMPILE_STATUS, &success);

        // check for errors
        if (!success) {
            int bufflen;
            glGetShaderiv(_fragmentShader, GL_INFO_LOG_LENGTH, &bufflen);

            char[] buff = new char[bufflen];
            glGetShaderInfoLog(_fragmentShader, bufflen, null, buff.ptr);
            writefln!"compilation failed for fragment shader: %s"(buff);
        }
    }

    public void applyTransformation(string uniform, mat4f transform) {
        // Apply a matrix transformation to the shader
        this.use();

        int location = glGetUniformLocation(program, uniform.toStringz);
        if (location != -1)
            glUniformMatrix4fv(location, 1, GL_TRUE, transform.ptr);
    }

    public void createProgram() {
        // Create the program
        _program = glCreateProgram();

        // Link the vertex and fragment shaders together
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
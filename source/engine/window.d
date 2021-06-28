module engine.window;

import std.stdio : writeln, writefln;
import std.string : toStringz;

import bindbc.opengl;
import bindbc.glfw;
import engine.shader;

/**
    Lightweight wrapper around a native GLFW window
*/
class Window
{
    /// The underlying native GLFW window
    private GLFWwindow *_window;

    private int _width, _height;

    public @property int width() { return this._width; }
    public @property int height() { return this._height; }

    /** Returns the underlying GLFW window pointer */
    public @property GLFWwindow* glfwWindow() { return this._window; }
    
    public @property bool closed() {
        return cast(bool) glfwWindowShouldClose(_window);
    }

    void create(int width, int height, string title) {
        this._width = width;
        this._height = height;

        GLFWSupport hasGlfw = loadGLFW();
        if (hasGlfw != glfwSupport) {
            writefln("GLFW failed to load!");
        }

        if (!glfwInit())
            return;
        
        glfwWindowHint(GLFW_VERSION_MAJOR, 3);
        glfwWindowHint(GLFW_VERSION_MINOR, 3);
        //glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

        _window = glfwCreateWindow(width, height, title.toStringz, null, null);
        if (!_window) {
            writefln("Failed to create window");
            glfwTerminate();
            return;
        }

        glfwMakeContextCurrent(_window);
        GLSupport hasGl = loadOpenGL();
        
        onWindowCreate();
    }

    void runLoop() {
        writeln(_window != null);
        while (!closed) {
            onWindowDraw();
        }

        onWindowClosed();
        glfwTerminate();
        return;
    }

    /// Event stubs for onWindowCreate, onWindowDraw etc
    void onWindowCreate() {}

    /// ditto
    void onWindowDraw() {}

    /// ditto
    void onWindowClosed() {}
}
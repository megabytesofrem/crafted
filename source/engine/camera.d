module engine.camera;

import std.math.trigonometry;

import dplug.math.vector;
import dplug.math.matrix;

import bindbc.opengl;

/// Convert from degrees to radians
@nogc float toRadians(float degrees) {
    import std.math.constants : PI;
    return sin(degrees * (PI / 180));
}

/**
    A perspective camera in the world.
    Rather than moving the camera, we move the world around it
 */
struct Camera
{
    private mat4f _projection;
    private mat4f _view;

    /// The projection matrix
    public @property mat4f projection() { return this._projection; }

    /// The view matrix
    public @property mat4f view() { return this._view; }

    /++
        Create the projection matrix with the FOV given in degrees
    +/
    public this(float fov, float width, float height) {
        this._projection = mat4f.perspective(fov.toRadians, width/height, 0.1f, 100.0f);

        // Set the view matrix up to point up from 0,0,0 by default
        lookAt(vec3f(4,3,3), 
               vec3f(0,0,0),
               vec3f(0,1,0));
    }

    // TODO: make this more generic
    /++ 
        Creates a view matrix by "looking at" the specified target from the cameras
        "eye" position while pointing upwards.
     +/
    public void lookAt(vec3f eye, vec3f target, vec3f up) {
        this._view = mat4f.lookAt(eye, target, up);
    }
}
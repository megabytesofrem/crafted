module log;

import std.stdio;
import bindbc.opengl;

void getError() {
    GLenum ret = glGetError();
    switch (ret) {
        case GL_NO_ERROR:
            writeln("everything is ok");
            break;
        case GL_INVALID_ENUM:
            writeln("invalid enum");
            break;
        case GL_INVALID_VALUE:
            writeln("invalid value");
            break;   
        case GL_INVALID_OPERATION:
            writeln("invalid operation");
            break;   
            case GL_INVALID_FRAMEBUFFER_OPERATION:
            writeln("invalid frame buffer operation");
            break;
            case GL_OUT_OF_MEMORY:
            writeln("out of memory");
            break;
            case GL_STACK_UNDERFLOW:
            writeln("stack underflow");
            break;
            case GL_STACK_OVERFLOW:
            writeln("stack overflow");
            break;
        default: 
            writeln("no");
            break;
    } 
}
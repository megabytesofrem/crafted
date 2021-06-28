import std.stdio;
import std.file : getcwd;

import bindbc.opengl;
import bindbc.glfw;

import game;

GameWindow window;

void main()
{
	window = new GameWindow();
	window.create(640, 480, "crafted v0.0.01");
	
	window.runLoop();
}

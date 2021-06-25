import std.stdio;

import derelict.opengl;
import derelict.glfw3.glfw3;

GLFWwindow* window;

int main()
{
	DerelictGL3.load();
	DerelictGLFW3.load();

	if (!glfwInit())
		return -1;
	
	window = glfwCreateWindow(640, 480, "crafted", null, null);
	if (!window) {
		glfwTerminate();
		return -1;
	}

	glfwMakeContextCurrent(window);

	while (!glfwWindowShouldClose(window)) 
	{
		// Game loop
		glClear(GL_COLOR_BUFFER_BIT);

		// Swap buffers
		glfwSwapBuffers(window);
		
		// Poll events
		glfwPollEvents();
	}

	glfwTerminate();
	return 0;
}

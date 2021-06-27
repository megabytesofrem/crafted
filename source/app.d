import std.stdio;
import std.file : getcwd;

import bindbc.opengl;
import bindbc.glfw;

import shader;
import renderer.blockrenderer;

GLFWwindow* window;
Shader mainShader;

void setupGl() {
	// load shader
	mainShader.loadVertexSource(getcwd ~ "/shaders/shader.vs");
	mainShader.loadFragmentSource(getcwd ~ "/shaders/shader.fs");

	mainShader.createProgram();

	// Set the viewport size
	glViewport(0, 0, 640, 480);

	// Enable alpha channel
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

	// Enable GL_DEPTH_TEST
	glEnable(GL_DEPTH_TEST);
}

int main()
{
	GLFWSupport glfwRet = loadGLFW();
	if (glfwRet != glfwSupport) {
		writefln("glfw failed to load, whatever");
	}

	if (!glfwInit())
		return -1;

	glfwWindowHint(GLFW_RESIZABLE, GLFW_FALSE);
	glfwWindowHint(GLFW_TRANSPARENT_FRAMEBUFFER, GLFW_TRUE);

	window = glfwCreateWindow(640, 480, "crafted", null, null);
	if (!window) {
		glfwTerminate();
		return -1;
	}

	glfwMakeContextCurrent(window);
	GLSupport glRet = loadOpenGL();

	setupGl();

	// not actually a block, ignore the shitty name
	BlockRenderer brend = new BlockRenderer();

	while (!glfwWindowShouldClose(window)) 
	{
		// Game loop

		// Clear with GL_DEPTH_BUFFER_BIT to preserve depth information or something
		glClearColor(0.0, 0.0, 0.0, 1.0);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		brend.render(mainShader);

		// Swap buffers
		glfwSwapBuffers(window);
		
		// Poll events
		glfwPollEvents();
	}

	glfwTerminate();
	return 0;
}

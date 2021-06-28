module game;

import bindbc.opengl;
import bindbc.glfw;

import engine.shader;
import engine.window;
import renderer.testrenderer;

Shader mainShader;

class GameWindow : Window
{
    private TestRenderer rend;

    override void onWindowCreate() {
        // Load the shader
        mainShader.loadVertexSource("shaders/shader.vs");
        mainShader.loadFragmentSource("shaders/shader.fs");

        mainShader.createProgram();

        rend = new TestRenderer();

        // Set the viewport size
        glViewport(0, 0, this.width, this.height);

        glEnable(GL_DEPTH_TEST);
    }

    override void onWindowDraw() {
        glClearColor(0.0, 0.0, 0.0, 1.0);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        rend.render(mainShader);

        glfwSwapBuffers(glfwWindow);
        glfwPollEvents();
    }
}
module game;

import bindbc.opengl;
import bindbc.glfw;

import engine.shader;
import engine.window;
import engine.texture;

import render.blockrenderer;

Shader mainShader;
Texture t;

class GameWindow : Window
{
    private BlockRenderer rend;

    override void onWindowCreate() {
        // Load the shader
        mainShader.loadSource("shaders/shader.vs", "shaders/shader.fs");
        rend = new BlockRenderer();

        // Set the viewport size
        // glfwSwapInterval()
        glViewport(0, 0, this.width, this.height);

        glEnable(GL_TEXTURE_2D);
        glEnable(GL_DEPTH_TEST);
        t = Texture.loadBitmap("textures/grass.bmp");

        mainShader.use();
    }

    override void onWindowDraw() {
        glClearColor(0.0, 0.0, 0.0, 1.0);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        t.use(GL_TEXTURE0);
        mainShader.setUniform("tex", 0);

        rend.render(mainShader);

        glfwSwapBuffers(glfwWindow);
        glfwWaitEvents();
    }
}
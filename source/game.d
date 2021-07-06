module game;

import bindbc.opengl;
import bindbc.glfw;

import dplug.math.vector;
import dplug.math.matrix;


import engine.camera;
import engine.shader;
import engine.window;
import engine.texture;

import render.blockrenderer;

Camera cam;
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
        t = Texture.loadBitmap("textures/cobble.bmp");

        cam = Camera(80.0f, this.width, this.height);
        cam.lookAt(vec3f(0, 0, 3), vec3f(0, 0, 0), vec3f(0, 1, 0));

        mat4f rotate = mat4f.rotateY(toRadians(-45.0f));

        mat4f model = mat4f.identity() * rotate;
        mat4f mvp = cam.projection * cam.view * model;

        mainShader.use();
        mainShader.setUniform("mvp", mvp);
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
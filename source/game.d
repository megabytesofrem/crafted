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
import render.chunkrenderer;

Camera cam;
Shader mainShader;
Texture t;

class GameWindow : Window
{
    private BlockRenderer rend;
    private ChunkRenderer chunkRender;

    override void onWindowCreate()
    {
        // Load the shader
        mainShader.loadSource("shaders/shader.vs", "shaders/shader.fs");
        rend = new BlockRenderer();

        // Set the viewport size
        // glfwSwapInterval()
        glViewport(0, 0, this.width, this.height);

        glEnable(GL_TEXTURE_2D);
        glEnable(GL_DEPTH_TEST);
        t = Texture.loadBitmap("textures/grass.bmp");

        cam = Camera(80.0f, this.width, this.height);
        cam.lookAt(vec3f(0, 0, 3), vec3f(0, 0, 0), vec3f(0, 1, 0));

        mat4f rotate = mat4f.rotateY(toRadians(-45.0f));

        rend.mesh.modelMatrix = mat4f.identity() * rotate;
        rend.mesh.modelMatrix.scale(vec3f(0.5f, 0.5f, 0.5f));

        mat4f mvp = cam.projection * cam.view * rend.mesh.modelMatrix;

        mainShader.use();
        mainShader.setUniform("mvp", mvp);

        chunkRender = new ChunkRenderer();
        chunkRender.generateChunk(5, 5, 5);
        chunkRender.setupRenderer();
    }

    void handleKeyboard()
    {
        import core.stdc.stdlib : exit;

        if (glfwGetKey(this.glfwWindow, GLFW_KEY_ESCAPE))
        {
            glfwTerminate();
            exit(0);
        }
    }

    override void onWindowDraw()
    {
        handleKeyboard();

        glClearColor(0.0, 0.0, 0.0, 1.0);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        t.use(GL_TEXTURE0);
        mainShader.setUniform("tex", 0);

        chunkRender.render(mainShader);

        glfwSwapBuffers(glfwWindow);
        glfwWaitEvents();
    }
}

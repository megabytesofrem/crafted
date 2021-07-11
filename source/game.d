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
    float deltaTime = 0.0f;
    float lastFrame = 0.0f;

    private BlockRenderer rend;
    private ChunkRenderer chunkRender;

    override void onWindowCreate()
    {
        import std.stdio : writeln;

        chunkRender = new ChunkRenderer();

        // Load the shader
        mainShader.loadSource("shaders/shader.vs", "shaders/shader.fs");
        rend = new BlockRenderer();

        // Set the viewport size
        // glfwSwapInterval()
        glViewport(0, 0, this.width, this.height);

        glEnable(GL_TEXTURE_2D);
        glEnable(GL_DEPTH_TEST);
        glEnable(GL_CULL_FACE);

        t = Texture.loadBitmap("textures/brick.bmp");

        cam = Camera(80.0f, this.width, this.height);
        cam.lookAt(vec3f(0, 5, 0), vec3f(0, 10, 0), cam.up);

        //mat4f rotate = mat4f.rotateZ(toRadians(-45.0f));
        writeln(chunkRender);
        chunkRender.modelMatrix = mat4f.identity();
        chunkRender.modelMatrix.scale(vec3f(0.2f, 0.2f, 0.2f));

        mat4f mvp = cam.projection * cam.view * chunkRender.modelMatrix;

        mainShader.use();
        mainShader.setUniform("mvp", mvp);

        chunkRender.setupRenderer();
        // chunkRender.generateChunk(5, 5, 5);
        // chunkRender.setupRenderer();
    }

    void handleKeyboard()
    {
        import core.stdc.stdlib : exit;
        import dplug.math.vector : cross;

        float cameraSpeed = 2.0f * deltaTime;

        if (glfwGetKey(this.glfwWindow, GLFW_KEY_ESCAPE))
        {
            glfwTerminate();
            exit(0);
        }

        // Camera movement
        if (glfwGetKey(glfwWindow, GLFW_KEY_W) == GLFW_PRESS)
        {
            cam.cameraPosition += cameraSpeed * cam.front;
        }
    
        if (glfwGetKey(glfwWindow, GLFW_KEY_S) == GLFW_PRESS)
        {
            cam.cameraPosition -= cameraSpeed * cam.front;
        }

        if (glfwGetKey(glfwWindow, GLFW_KEY_A) == GLFW_PRESS) 
        {
            cam.cameraPosition -= cross(cam.front, cam.up).normalized * cameraSpeed;
        }

        if (glfwGetKey(glfwWindow, GLFW_KEY_D) == GLFW_PRESS) 
        {
            cam.cameraPosition += cross(cam.front, cam.up).normalized * cameraSpeed;
        }

        if (glfwGetKey(glfwWindow, GLFW_KEY_Q) == GLFW_PRESS)
        {
            cam.cameraPosition += cam.up.normalized * cameraSpeed;
        }

        if (glfwGetKey(glfwWindow, GLFW_KEY_E) == GLFW_PRESS)
        {
            cam.cameraPosition -= cam.up.normalized * cameraSpeed;
        }
    }

    override void onWindowDraw()
    {
        // Calculate delta time
        float current = glfwGetTime();
        deltaTime = current - lastFrame;
        lastFrame = current;

        handleKeyboard();

        // Camera stuff
        cam.lookAtCamera();

        mat4f mvp = cam.projection * cam.view * chunkRender.modelMatrix;
        mainShader.setUniform("mvp", mvp);


        glClearColor(0.0, 0.0, 0.0, 1.0);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        t.use(GL_TEXTURE0);
        mainShader.setUniform("tex", 0);

        chunkRender.render(mainShader);
        //chunkRender.render(mainShader);

        glfwSwapBuffers(glfwWindow);
        glfwWaitEvents();
    }
}

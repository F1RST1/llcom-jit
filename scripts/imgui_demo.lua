-- imgui_demo.lua  
local ffi = require "ffi"  
local base = apiGetPath() .. "user_script_run/requires/"  
  
-- MUST keep references — LuaJIT FreeLibrary's ffi.load'ed DLLs  
-- when the returned cdata is garbage-collected  
__loaded_libs = {}  
for _, n in ipairs({  
    "libwinpthread-1",  
    "libgcc_s_dw2-1",  
    "libstdc++-6",  
    "glfw3",  
    "libcimgui",  
}) do  
    local ok, lib = pcall(ffi.load, base .. n)  
    if not ok then  
        log.info("ffi.load failed: " .. n .. " -> " .. tostring(lib))  
        return  
    end  
    __loaded_libs[n] = lib   -- anchor it  
end  
  
local lj_glfw = require "glfw"  
local gl, glc, glu, glfw, glext = lj_glfw.libraries()  
local ig = require "imgui"  
  
glfw.glfwSetErrorCallback(function(error, description)  
    log.info("GLFW error: " .. tostring(error) .. " " ..  
        ffi.string(description or ""))  
end)  
  
lj_glfw.init()  
local window = lj_glfw.Window(700, 500)  
window:makeContextCurrent()  
  
local ig_impl = ig.Imgui_Impl_glfw_opengl3()  
ig_impl:Init(window, true)  
  
local showdemo = ffi.new("bool[1]", false)  
while not window:shouldClose() do  
    lj_glfw.pollEvents()  
    gl.glClear(glc.GL_COLOR_BUFFER_BIT)  
    ig_impl:NewFrame()  
  
    if ig.Button "Hello" then  
        log.info("Hello World!!")  
    end  
    ig.ShowDemoWindow(showdemo)  
  
    ig_impl:Render()  
    window:swapBuffers()  
end  
  
ig_impl:destroy()  
window:destroy()  
lj_glfw.terminate()
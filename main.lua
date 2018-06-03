local scene_manager = require 'scn_scn_manager'

local INITIAL_SCENE_CLASS = require 'scn_game'

function love.load()
    scene_manager.hook()
    scene_manager.setScene(INITIAL_SCENE_CLASS.new())
end

function love.update(dt)
    scene_manager.update(dt)
end

function love.draw()
    scene_manager.draw()
end
local composer = require( "composer" )
local Brick = require( "Brick" )
local physics = require("physics")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------
physics.start()
physics.setGravity( 0, 0 )
physics.setDrawMode( "hybrid" )


local brickOptions = {
    width = 98,
    height = 28,
}

local ball, paddle, playArea
-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    playArea = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    playArea:setFillColor(.3,.3,.3,.7)

    paddle = display.newRect( sceneGroup, display.contentCenterX, display.contentHeight-100, 200, 20 )
    ball   = display.newCircle( sceneGroup, display.contentCenterX, display.contentCenterY, 20 )

    physics.addBody( playArea, "static", {
        chain={ -display.contentCenterX,-display.contentCenterY, display.contentCenterX, -display.contentCenterY, display.contentCenterX,display.contentCenterY, -display.contentCenterX,display.contentCenterY },
        connectFirstAndLastChainVertex = true,
        bounce = 1,
        friction = 0,
    })
    physics.addBody( paddle, "static", {
        friction = 0,
        bounce = 1,
    })
    physics.addBody( ball, "dynamic", {
        radius = 20,
        bounce = 1,
        friction = 0,
    })
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    local colorTable = { [1] = "red", [2] = "blue", [3] = "yellow", [4] = "gray"}
    local brickTable = { ["breakable"] = 16, ["yellow"] = 2, ["gray"] = 6 }
    local totalBricks = 24

    local function createBrickTable()
        if totalBricks <= 24 and totalBricks > 18 then
        elseif 
    end

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        local x, y = 90, 130
        local brick
        for i=1,4 do
            for j=1,6 do
                local brick = Brick:new(brickOptions, x, y, colorTable[math.random(1,4)])
                brick.brick.anchorX = 0; brick.brick.anchorY = 0
                sceneGroup:insert( brick.brick )
                x = x + 100
            end
            if i == 1 or i == 3 then x = 30 else x = 90 end
            y = y + 30
        end


    elseif ( phase == "did" ) then
        --local brick = Brick:new(brickOptions, 100, 100, "red")
        --brick:swapColor()

        ball:applyForce(math.random(-3, 3), math.random(5, 8))
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene
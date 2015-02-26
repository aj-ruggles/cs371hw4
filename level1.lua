local composer = require( "composer" )
local physics = require("physics")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------
physics.start()
physics.setGravity( 0, 0 )
-- physics.setDrawMode( "hybrid" )

local ball, paddle, playArea
local red, blue, yellow, gray = 1, 2, 3, 4
local colorTable = { [1] = "red", [2] = "blue", [3] = "yellow", [4] = "gray" }
local brickTable = {}

local function swapColor( obj )
    if obj.color == red then obj.color = blue; obj:setFillColor(0,0,1)
    elseif obj.color == blue then obj.color = red; obj:setFillColor(1,0,0) 
    end
end
-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    playArea = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    playArea:setFillColor(.3,.3,.3,.7)

    paddle = display.newRect( sceneGroup, display.contentCenterX, display.contentHeight-100, 200, 20 )

    local function move ( event )
        if event.phase == "began" then     
            paddle.markX = paddle.x 
        elseif event.phase == "moved" then     
            local x = (event.x - event.xStart) + paddle.markX     
            if (x <= 20 + paddle.width/2) then
                paddle.x = 20+paddle.width/2;
            elseif (x >= display.contentWidth-20-paddle.width/2) then
                paddle.x = display.contentWidth-20-paddle.width/2;
            else
                paddle.x = x;      
            end
        end
    end


    Runtime:addEventListener("touch", move);




    ball   = display.newCircle( sceneGroup, display.contentCenterX, display.contentCenterY, 20 )

    local function ballCollisionDetected( event )
        if event.phase == "ended" and event.other.color then
            if event.other.color == 1 then
                table.remove(brickTable, event.other.id)
                event.other:removeSelf()
                event.other = nil
            elseif event.other.color == 2 then
                swapColor(event.other)
            elseif event.other.color == 3 then
                for i=1, #brickTable do
                    swapColor(brickTable[i])
                end
            end
        end
        -- body
    end
    ball:addEventListener("collision", ballCollisionDetected )

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
    physics.addBody( ball, "kinimatic", {
        radius = 20,
        bounce = 1,
        friction = 0,
    })
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        
        local function setColor( obj )

        end

        local x, y = 90, 100
        local brickId = 1
        for i=1,4 do
            for j=1,6 do
                brickTable[brickId] = display.newRect(x, y, 98, 38)
                brick = brickTable[brickId]
                brick.anchorX=0;brick.anchorY=0
                brick.id = brickId
                brick.color = 2
                brick:setFillColor(0,0,1)
                physics.addBody(brick, "static" ) 
                sceneGroup:insert( brick )
                x = x + 100; brickId = brickId + 1
            end
            if i == 1 or i == 3 then x = 30 else x = 90 end
            y = y + 40
        end


    elseif ( phase == "did" ) then
        ball:applyForce(0, 8000)
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
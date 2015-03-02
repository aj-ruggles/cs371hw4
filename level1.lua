local composer = require( "composer" )
local physics = require("physics")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------
physics.start()
physics.setGravity( 0, 0 )
--physics.setDrawMode( "hybrid" )

local gameEnded = false

local ball, paddle, playArea, endArea, endText
local red, blue, yellow, gray, death = 1, 2, 3, 4, 5

local numRed = math.random(6, 10)
local numBlue = math.abs(numRed - 16)
local numYellow = 2
local numGray = 6
local totalNumOfBricks = 24
local numOfBircksToWin = 8
local message = "Fail"

local brickTable = {}
local colorTable = {}

local paintGray = {
    type = "gradient",
    color1 = { .4,.4,.4 },
    color2 = { .5,.5,.5 },
    direction = "down"
}

local paintYellow = {
    type = "gradient",
    color1 = { .8,.8,0 },
    color2 = { 1,1,0 },
    direction = "down"
}

local paintRed = {
    type = "gradient",
    color1 = { .8,0,0 },
    color2 = { 1,0,0 },
    direction = "down"
}

local paintBlue = {
    type = "gradient",
    color1 = { 0,0,.8 },
    color2 = { 0,0,1 },
    direction = "down"
}


local function swapColor( obj )
    if obj.color == red then
        obj.color = blue
        obj:setFillColor( paintBlue )
    elseif obj.color == blue then
        obj.color = red
        obj:setFillColor( paintRed )
    end
end

local function endGame()
    physics.setGravity( 0, 5 )
    gameEnded = true
    for i,v in ipairs(brickTable) do
        v.bodyType = "dynamic"
        v:applyForce(math.random(-10, 10), math.random(-10, 10))
    end

    paddle:removeSelf()
    paddle = nil

    ball:removeSelf()
    ball = nil

    if totalNumOfBricks == numOfBircksToWin then
        endText.text = "Win"
    else
        physics.addBody( endText, "dynamic" )
    end
    endText.alpha = 1

end
-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.

    playArea = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    playArea:setFillColor( .15,.15,.15 )

    local options =
    {
        parent = sceneGroup,
        text = message,
        x = display.contentCenterX,
        y = display.contentCenterY-100,
        font = native.systemFont,
        fontSize = 64,
    }
    endText = display.newText( options )
    endText.alpha = 0

    endArea = display.newRect( sceneGroup, display.contentCenterX, display.contentHeight-1, display.contentWidth, 2 )
    endArea.color = 5

    paddle = display.newRect( sceneGroup, display.contentCenterX, display.contentHeight-100, 200, 20 )
    paddle.markX = paddle.x
    local function move( event )
        if gameEnded == true then
            Runtime:removeEventListener("touch", move)
        elseif event.phase == "began" then
            paddle.markX = paddle.x
        elseif event.phase == "moved" then
            local x = (event.x - event.xStart) + paddle.markX
            if (x <= 20 + paddle.width/2) then
                paddle.x = 20+paddle.width/2
            elseif (x >= display.contentWidth-20-paddle.width/2) then
                paddle.x = display.contentWidth-20-paddle.width/2
            else
                paddle.x = x
            end
        end
    end
    Runtime:addEventListener("touch", move)

    ball = display.newCircle( sceneGroup, display.contentCenterX, display.contentCenterY-200, 20 )
    local function ballCollisionDetected( event )
        if event.phase == "ended" and event.other.color then
            if event.other.color == 1 then
                table.remove(brickTable, table.indexOf(brickTable, event.other))
                event.other:removeSelf()
                event.other = nil
                totalNumOfBricks = totalNumOfBricks - 1
            elseif event.other.color == 2 then
                swapColor(event.other)
            elseif event.other.color == 3 then
                for i,v in ipairs(brickTable) do
                    swapColor(v)
                end
            elseif event.other.color == 5 then
                timer.performWithDelay(1, endGame, 1)
            end

            if totalNumOfBricks == numOfBircksToWin then
                timer.performWithDelay(1, endGame, 1)
            end
        end
    end
    ball:addEventListener("collision", ballCollisionDetected )

    physics.addBody( playArea, "static", {
        chain={ -display.contentCenterX,-display.contentCenterY, display.contentCenterX, -display.contentCenterY, display.contentCenterX,display.contentCenterY, -display.contentCenterX,display.contentCenterY },
        connectFirstAndLastChainVertex = true,
    })
    physics.addBody( ball, "kinimatic", {
        radius = 20,
        bounce = 1,
    })
    physics.addBody( endArea, "static", {
        bounce = 0,
        friction = 1
    })

    physics.addBody( paddle, "static", {
        bounce = 0,
        friction = 1
    })

    for i=1,totalNumOfBricks do
        if i <= numRed then colorTable[i] = red
        elseif i <= numRed+numBlue then colorTable[i] = blue
        elseif i <= numRed+numBlue+numYellow then colorTable[i] = yellow
        else colorTable[i] = gray
        end
    end

end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).

        local function setColor( obj, row )
            local idx = math.random(1,table.getn(colorTable))
            obj.color = colorTable[idx]
            table.remove(colorTable, idx)
            if obj.color == red then obj:setFillColor( paintRed )
            elseif obj.color == blue then obj:setFillColor( paintBlue )
            elseif obj.color == yellow then obj:setFillColor( paintYellow )
            elseif obj.color == gray then obj:setFillColor( paintGray )
            end
        end

        local x, y = 90, 100
        local brickId = 1
        for i=1,4 do
            for j=1,6 do
                brickTable[brickId] = display.newRoundedRect(x, y, 98, 38, 6)
                brick = brickTable[brickId]
                brick.anchorX=0;brick.anchorY=0
                setColor( brick, i )
                physics.addBody( brick, "static" )
                sceneGroup:insert( brick )
                x = x + 100; brickId = brickId + 1
            end
            if i == 1 or i == 3 then x = 30 else x = 90 end
            y = y + 60
        end


    elseif ( phase == "did" ) then
        ball:applyForce(2, 10)
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

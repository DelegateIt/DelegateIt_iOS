local composer = require( "composer" )
local myData = require( "myData" )
local scene = composer.newScene()

--Variables

local background
local backBtn
local backText
local menuText
local line

-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   print("creating scene1")

   background = display.newRect( myData.width/2,myData.height/2, myData.width, myData.height)
   sceneGroup:insert( background )


   backBtn = display.newImageRect(sceneGroup,"backBtn.png",13/1.3,20/1.3)
   backBtn.x = myData.width * .046
   backBtn.y = myData.height * .056

   backText = display.newText(sceneGroup,"Back", myData.width*.12, myData.height*.055, "Prelo-Light", myData.width/20)
   backText:setTextColor(0)


   menuText = display.newText(sceneGroup,"RESET PASSWORD", myData.width*.5, myData.height*.055, "Prelo-Bold", myData.width/18)
   menuText:setTextColor(0)

   line = display.newImageRect(sceneGroup,"line.png",myData.width,1)
   line.x = myData.width * .5
   line.y = myData.height *.092

   backText:addEventListener("tap",gotoLogin)

end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
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

function gotoLogin()
   options = {
      effect = "slideRight",
      time = 400,
   }
   composer.gotoScene( "login",options)
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
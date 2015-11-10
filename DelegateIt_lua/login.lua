display.setStatusBar( display.DarkStatusBar )

local composer = require( "composer" )
local myData = require( "myData" )
local scene = composer.newScene()

--Variables
local bg

local backBtn
local backText
local menuText
local line

local fbBtn
local fbText

local line1
local line2
local orText

local emailbox
local emailText
local emailField

local passwordBox
local passwordText
local passwordField

local forgotPasswordText

local loginBtn
local loginText

--Logic
local keyboardUp = false

-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   print("creating scene1")

   bg = display.newRect(sceneGroup,myData.width/2,myData.height/2,myData.width,myData.height)

   --debug mode only
   local startBg = display.newImageRect(sceneGroup,"startBg.jpg",myData.width,myData.height)
   startBg.x = myData.width/2
   startBg.y = myData.height/2
   startBg.alpha = 0

   backBtn = display.newImageRect(sceneGroup,"backBtn.png",13/1.3,20/1.3)
   backBtn.x = myData.width * .046
   backBtn.y = myData.height * .056

   backText = display.newText(sceneGroup,"Back", myData.width*.12, myData.height*.055, "Prelo-Light", myData.width/20)
   backText:setTextColor(0)


   menuText = display.newText(sceneGroup,"LOGIN", myData.width*.5, myData.height*.055, "Prelo-Bold", myData.width/18)
   menuText:setTextColor(0)

   line = display.newImageRect(sceneGroup,"line.png",myData.width,1)
   line.x = myData.width * .5
   line.y = myData.height *.092

   fbBtn = display.newImageRect(sceneGroup,"fbBtn.png",myData.width * .8,50)
   fbBtn.x = myData.width * .5
   fbBtn.y = myData.height * .5 - 120
   fbBtn.alpha = 1

   fbText = display.newText(sceneGroup,"LOGIN WITH FACEBOOK", myData.width*.5, myData.height*.5 - 120, "Prelo-Bold", myData.width/20)

   line1 = display.newImageRect(sceneGroup,"line2.png",myData.width * .36,1)
   line1.x = myData.width * .28
   line1.y = myData.height *.5 - 70

   line2 = display.newImageRect(sceneGroup,"line2.png",myData.width * .36,1)
   line2.x = myData.width - (myData.width * .28)
   line2.y = myData.height *.5 - 70

   orText = display.newText(sceneGroup,"or", myData.width*.5, myData.height *.5 - 70, "Prelo-Light", myData.width/22)
   orText:setTextColor(0)

   emailbox = display.newImageRect(sceneGroup,"emailTextField.png", myData.width*.8,48)
   emailbox.x = myData.width * .5 
   emailbox.y = myData.height * .5 - 28

   passwordBox = display.newImageRect(sceneGroup,"passwordTextField.png", myData.width*.8,48)
   passwordBox.x = myData.width * .5 
   passwordBox.y = myData.height * .5 + 32


   forgotPasswordText = display.newText(sceneGroup,"Forgot your password?", myData.width*.5, myData.height*.5 + 76, "Prelo-Light", myData.width/30)
   forgotPasswordText:setTextColor(0)

   loginBtn = display.newImageRect(sceneGroup,"loginBtn.png",myData.width * .42, 40)
   loginBtn.x = myData.width * .5
   loginBtn.y = myData.height * .5 + 120

   loginText = display.newText(sceneGroup,"LOGIN", myData.width*.5, myData.height *.5 + 120, "Prelo-Bold", myData.width/22) 


   emailField = native.newTextField(myData.width*.56, myData.height*.5  -28, myData.width*.6, myData.height*.04)
   emailField.font = native.newFont( "Prelo-Light", myData.width/20)
   emailField:setTextColor(0)
   emailField.text = ""
   emailField.placeholder = "Email"
   emailField.inputType = "email"
   emailField.align = "left"
   emailField.hasBackground = false

   emailField:addEventListener( "userInput", onEmail )

   sceneGroup:insert( emailField )


   passwordField = native.newTextField(myData.width*.56, myData.height*.5  + 32, myData.width*.6, myData.height*.04)
   passwordField.font = native.newFont( "Prelo-Light", myData.width/20)
   passwordField.align = "left"
   passwordField.placeholder = "Password"
   passwordField.text = ""
   passwordField.hasBackground = false
   passwordField:addEventListener( "userInput", onPassword )

   sceneGroup:insert( passwordField )

   forgotPasswordText:addEventListener("tap",gotoForgotPassword)
   backText:addEventListener("tap",gotoStart)
   bg:addEventListener("tap",showEverything)
   loginBtn:addEventListener("tap",gotoHome)

   
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

   Runtime:removeEventListener("enterFrame",slideDown)

   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end

--Keyboard
function onEmail( event )
    if ( "began" == event.phase ) then
        -- This is the "keyboard appearing" event.
        -- In some cases you may want to adjust the interface while the keyboard is open.
    emailLoginOnly()
        

   elseif ( "submitted" == event.phase ) then
        -- Automatically tab to password field if user clicks "Return" on virtual keyboard.
        print(emailField.text)
        native.setKeyboardFocus( passwordField )
   elseif("editing" == event.phase) then
      local txt = event.text            
      if(string.len(txt)>0)then
         validUsername = true
      else 
         validUsername = false
      end
   
   end
end

function onPassword( event )
    -- Hide keyboard when the user clicks "Return" in this field
    if ( "began" == event.phase ) then
      passwordField.isSecure = true
      emailLoginOnly()
   end
    if ( "submitted" == event.phase ) then
        print(passwordField.text)
        native.setKeyboardFocus( nil )  
    end
   if("editing" == event.phase) then
      local txt = event.text            
      if(string.len(txt)>0)then
         validPassword = true
      else 
         validPassword = false
      end
   end
end

function emailLoginOnly()
  if(not keyboardUp) then
   hideExtra()
   Runtime:addEventListener("enterFrame",slideUp)
   keyboardUp = true
  end
end

function showEverything()
  if(keyboardUp) then
    Runtime:addEventListener("enterFrame",slideDown)
    keyboardUp = false
    native.setKeyboardFocus( nil )
  end
end

function hideExtra()
  fbBtn.alpha = 0
  fbText.alpha = 0
  line1.alpha = 0
  line2.alpha = 0
  orText.alpha = 0
  forgotPasswordText.alpha = 0
end

function slideUp()
  print(emailbox.y)
   if(emailbox.y < 120) then
      Runtime:removeEventListener("enterFrame",slideUp)
   else
      emailbox.y = emailbox.y -8
      passwordBox.y = passwordBox.y -8
      loginBtn.y = loginBtn.y -8
      loginText.y = loginText.y -8
      emailField.y = emailField.y -8
      passwordField.y = passwordField.y -8
   end
end

function slideDown()
  print(emailbox.y)
   if(emailbox.y + 8 > myData.height * .5 - 28) then
      Runtime:removeEventListener("enterFrame",slideDown)
      fbBtn.alpha = 1
      fbText.alpha = 1
      line1.alpha = 1
      line2.alpha = 1
      orText.alpha = 1
      forgotPasswordText.alpha = 1
   else
      emailbox.y = emailbox.y +8
      passwordBox.y = passwordBox.y +8
      loginBtn.y = loginBtn.y +8
      loginText.y = loginText.y +8
      emailField.y = emailField.y +8
      passwordField.y = passwordField.y +8
   end
end

function gotoStart()
   showEverything()
   options = {
      effect = "slideRight",
      time = 400,
   }
   composer.gotoScene( "start",options)
end

function gotoHome()
   showEverything()
   options = {
      effect = "fade",
      time = 200,
   }
   composer.gotoScene( "home",options)
end

function gotoForgotPassword()
   showEverything()
   options = {
      effect = "slideLeft",
      time = 400,
   }
   composer.gotoScene( "forgotpassword",options)
end


---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
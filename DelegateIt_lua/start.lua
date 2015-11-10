

local composer = require( "composer" )
local myData = require( "myData" )
local scene = composer.newScene()

--Variables

local bg

local logo

local registerText
local registerTextSignUp

local fbBtn
local fbText

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

local textCount


local myTextBoxSample

-- "scene:create()"
function scene:create( event )
   print("creating start")
   local sceneGroup = self.view

   bg = display.newImageRect(sceneGroup,"bg.png",myData.width,myData.height)
   bg.x = myData.xmid
   bg.y = myData.ymid
   bg.alpha = .83

   logo = display.newImageRect(sceneGroup,"logo.png",myData.width/3,(myData.width/3)/1.104)
   logo.x = myData.width * .5
   logo.y = myData.height * .15


   fbBtn = display.newImageRect(sceneGroup,"fbBg.png",myData.width * .8,40)
   fbBtn.x = myData.width * .5
   fbBtn.y = myData.height * .5 + 100
   fbBtn.alpha = 1

   fbText = display.newText(sceneGroup,"LOGIN WITH FACEBOOK", myData.width*.5, myData.height*.5 + 100, "Prelo-Bold", myData.width/20)

   orText = display.newText(sceneGroup,"or", myData.width*.5, myData.height *.5 + 60, "Prelo-Light", myData.width/22)
   orText:setTextColor(1)

   emailbox = display.newImageRect(sceneGroup,"emailTextField.png", myData.width*.8,50)
   emailbox.x = myData.width * .5 
   emailbox.y = myData.height * .5 - 80

   passwordBox = display.newImageRect(sceneGroup,"passwordTextField.png", myData.width*.8,50)
   passwordBox.x = myData.width * .5 
   passwordBox.y = myData.height * .5 - 29


   forgotPasswordText = display.newText(sceneGroup,"Forgot your password?", myData.width*.5, myData.height*.88, "Prelo-Light", myData.width/30)
   forgotPasswordText:setTextColor(1)

   registerText = display.newText(sceneGroup,"Dont't have an account?", myData.width*.5 - 25, myData.height*.94, "Prelo-Light", myData.width/24)
   registerTextSignUp = display.newText(sceneGroup,"Sign up", myData.width*.5 + 82, myData.height*.94, "Prelo-Bold", myData.width/24)

   --Tap events
   registerText:addEventListener("tap",gotoRegister)

   loginBtn = display.newImageRect(sceneGroup,"loginBtn.png",myData.width * .8, 40)
   loginBtn.x = myData.width * .5
   loginBtn.y = myData.height * .5 + 17

   loginText = display.newText(sceneGroup,"LOGIN", myData.width*.5, myData.height *.5 + 17, "Prelo-Bold", myData.width/22) 

   emailText = display.newText(sceneGroup,"email", myData.width*.17, myData.height*.5  - 80, "Prelo-Light", myData.width/28)
   emailText:setTextColor(0)

   --textCount = display.newText(sceneGroup,"Count", myData.width*.5, myData.height *.26, "Prelo-Bold", myData.width/10)


   emailField = native.newTextField(myData.width*.6, myData.height*.5  - 80, myData.width*.56,myData.height*.04)
   --emailField.isEditable = true
   emailField.font = native.newFont("Prelo-Light", myData.width/20)
   emailField:setTextColor(0)
   emailField.text = ""
  -- emailField.placeholder = "ben.wernsman@me.com"
   --emailField.inputType = "email"
   emailField.align = "left"
   emailField.hasBackground = false
  
   emailField:addEventListener( "userInput", onEmail )

   sceneGroup:insert( emailField )

   passwordText = display.newText(sceneGroup,"password", myData.width*.2, myData.height*.5  - 29, "Prelo-Light", myData.width/28)
   passwordText:setTextColor(0)

   passwordField = native.newTextField(myData.width*.6, myData.height*.5  - 29, myData.width*.56, myData.height*.04)
   passwordField.isEditable = true
   passwordField.font = native.newFont( "Prelo-Light", myData.width/20)
   passwordField.align = "left"
   --passwordField.placeholder = "Password"
   passwordField.text = ""
   passwordField.hasBackground = false
   passwordField:addEventListener( "userInput", onPassword )

   sceneGroup:insert( passwordField )

   forgotPasswordText:addEventListener("tap",gotoForgotPassword)
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

   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end

---------------------------------------------------------------------------------

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
      print(string.len(txt)) 
      

       --emailField.height = getTextHeight(txt)
           
      if(string.len(txt)>26)then
    
        -- emailField.height = 80
         validUsername = true


      else 
        --emailField.height = 50
         validUsername = false
      end
   
   end
end

function getTextHeight(txt)
  display.remove(myTextBoxSample)
    local options = 
{
    --parent = textGroup,
    text = txt,     
    x = 100,
    y = 200,
    width = myData.width*.6,     --required for multi-line and alignment
    font = native.systemFontBold,   
    fontSize = myData.width/20,
    align = "center"  --new alignment parameter
}

 myTextBoxSample = display.newText( options )

 return(myTextBoxSample.height * 1.2)

end

function onPassword( event )
    -- Hide keyboard when the user clicks "Return" in this field
    if ( "began" == event.phase ) then
      passwordField.isSecure = true
      emailLoginOnly()
   end
    if ( "submitted" == event.phase ) then
        print(passwordField.text)
        showEverything()
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
   --Runtime:addEventListener("enterFrame",slideUp)
   keyboardUp = true
  end
end

function showEverything()
  if(keyboardUp) then
    showExtra()
    --Runtime:addEventListener("enterFrame",slideDown)
    keyboardUp = false
    native.setKeyboardFocus( nil )
  end
end

function hideExtra()
  fbBtn.alpha = 0
  fbText.alpha = 0
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

function showExtra( ... )
  fbBtn.alpha = 1
  fbText.alpha = 1
  orText.alpha = 1
  forgotPasswordText.alpha = 1
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

function gotoForgotPassword()
   showEverything()
   options = {
      effect = "slideLeft",
      time = 400,
   }
   composer.gotoScene( "forgotpassword",options)
end

function gotoRegister()
   options = {
      effect = "slideLeft",
      time = 400,
   }
   composer.gotoScene( "register",options)
end

function gotoHome()
   showEverything()
   options = {
      effect = "fade",
      time = 200,
   }
   composer.gotoScene( "home",options)
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
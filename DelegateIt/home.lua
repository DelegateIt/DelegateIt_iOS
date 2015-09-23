local composer = require( "composer" )
local myData = require( "myData" )
local tableView = require("tableView")
local ui = require("ui")
local scene = composer.newScene()


--initial values
local screenOffsetW, screenOffsetH = display.contentWidth -  display.viewableContentWidth, display.contentHeight - display.viewableContentHeight

local myList, backBtn, detailScreenText

local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
background:setFillColor(0)

--Uncomment the line below to see a background image
--local background = display.newImage("coffeeBg.png",display.contentWidth,display.contentHeight)

--setup a destination for the list items
local detailScreen = display.newGroup()

local detailBg = display.newRect(0,0,display.contentWidth,display.contentHeight-display.screenOriginY)
detailBg:setFillColor(255,255,255)
detailScreen:insert(detailBg)

detailScreenText = display.newText("You tapped item", 0, 0, native.systemFontBold, 12)
detailScreenText:setTextColor(0, 0, 0)
detailScreen:insert(detailScreenText)
detailScreenText.x = math.floor(display.contentWidth/2)
detailScreenText.y = math.floor(display.contentHeight/2)    
detailScreen.x = display.contentWidth
 
--setup the table
local data = {}  --note: the declaration of this variable was moved up higher to broaden its scope

--iPad: setup a color fill for selected items
local selected = display.newRect(0, 0, 50, 50)  --add acolor fill to show the selected item
selected:setFillColor(67,141,241,180)  --set the color fill to light blue
selected.isVisible = false  --hide color fill until needed

local topBoundary = display.screenOriginY + 160
local bottomBoundary = -500

local menuBox

local makeOrder
local makeOrderText
local plusBtn

local listviewBtn
local recentordersBtn
local addBtn
local groupBtn
local aboutBtn



-- "scene:create()"
function scene:create( event )
   composer.removeScene("login")
   composer.removeScene("start")

   local sceneGroup = self.view

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   print("creating scene1")

   local background = display.newRect( myData.width/2,myData.height/2, myData.width, myData.height)
   sceneGroup:insert( background )


   menuText = display.newText(sceneGroup,"HOME", myData.width*.5, myData.height*.055, "Prelo-Bold", myData.width/18)
   menuText:setTextColor(0)

   local imagesScaled = {}


   --setup each row as a new table, then add title, subtitle, and image
   data[1] = {}
   data[1].title = "POPULAR ORDER"
   data[1].subtitle = "1 Large Pepperoni Pizza"
   data[1].image = "pizza.png"

   data[2] = {}
   data[2].title = "SUGGESTED ORDER"
   data[2].subtitle = "One 32oz Coffee"
   data[2].image = "coffee.png"

   data[3] = {}
   data[3].title = "YOUR LATEST ORDER"
   data[3].subtitle = "A 6-pack of Bud Light"
   data[3].image = "budlight.png"

   data[4] = {}
   data[4].title = "GO FURTHER"
   data[4].subtitle = "A Plane Ticket"
   data[4].image = "plane.png"

   --data[5] = {}
   --data[5].title = "Latte"
   --data[5].subtitle = "More milk and less froth"
   --data[5].image = "listItemBg_over.png"

   --For Duplicates
   for i=1, 4 do
      table.insert(data, data[i])
   end
   

   -- create the list of items
   myList = tableView.newList{
      data=data, 
      --default="listItemBg.png",
      default="listItemBg_white.png",
      over="listItemBg_over.png",
      onRelease=listButtonRelease,
      width = 100,
      height = 330,
      top=topBoundary,
      bottom=bottomBoundary,
      callback = function( row )
                            local g = display.newGroup()

                            local img = display.newImage(row.image)
                            g:insert(img)
                            img.x = display.contentWidth/2
                            img.y = 0 
                            img.width = display.contentWidth
                            img.height = 160

                            local title =  display.newText( row.title, 0, 0, "Prelo-Light", myData.width/20 )
                            title:setTextColor(1)
                            g:insert(title)
                            title.x = display.contentWidth/2
                            title.y = -20

                            local subtitle =  display.newText( row.subtitle, 0, 0, "Prelo-Bold", myData.width/12 )
                            subtitle:setTextColor(1)
                            g:insert(subtitle)
                            subtitle.x = display.contentWidth/2
                            subtitle.y = 20

                            return g   
                     end 
   }


   --Setup the back button
   backBtn = ui.newButton{ 
      default = "backButton.png", 
      over = "backButton_over.png", 
      onRelease = backBtnRelease
   }
   backBtn.x = math.floor(backBtn.width/2) + backBtn.width + screenOffsetW
   backBtn.y = 100
   backBtn.alpha = 0

   --Add a white background to the list.  
   --It didn't move with the list when it appeared on the larger screen of the iPad.
   local listBackground = display.newRect(0, 0, myList.width, myList.height )
   listBackground:setFillColor(255,255,255)
   myList:insert(1,listBackground)


   --menuBox = display.newImageRect("menuBtn.png",myData.width,myData.height*.15)
   --menuBox.x = myData.width/2
   --menuBox.y = myData.height*.05

   --makeOrder = display.newImageRect("makeAnOrderBox.png",myData.width*.86,myData.height*.07)
   --makeOrder.x = myData.width/2
   --makeOrder.y = myData.height*.07

   --makeOrderText = display.newText("MAKE AN ORDER", myData.width*.54, myData.height*.07, "Prelo-Bold", myData.width/20)
   --makeOrderText:setTextColor(0)

   --plusBtn = display.newImageRect("plus.png",32/2,30/2)
   --plusBtn.x = myData.width*.3
   --plusBtn.y = myData.height*.07

   print(myData.width*.2)

   listviewBtn = display.newImageRect("listviewBtn.png",myData.width*.2,47)
   listviewBtn.x = myData.width*.1
   listviewBtn.y = myData.height - (47/2)

   recentordersBtn = display.newImageRect("recentordersBtn.png",myData.width*.2,47)
   recentordersBtn.x = myData.width*.3
   recentordersBtn.y = myData.height - (47/2)

   addBtn = display.newImageRect("addBtn.png",myData.width*.2,52)
   addBtn.x = myData.width*.5
   addBtn.y = myData.height - (52/2)

   profileBtn = display.newImageRect("profileBtn.png",myData.width*.2,47)
   profileBtn.x = myData.width*.7
   profileBtn.y = myData.height - (47/2)

   aboutBtn = display.newImageRect("aboutBtn.png",myData.width*.2,47)
   aboutBtn.x = myData.width*.9
   aboutBtn.y = myData.height - (47/2)
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

function listButtonRelease( event )
   self = event.target
   local id = self.id
   print(self.id)
   
   detailScreenText.text = "You tapped ".. data[id].subtitle --added this line to make the right side of the screen more interesting
   --check for screen width of the iPad
   if system.getInfo("model") == "iPad" then       
      selected.width, selected.height = self.width, self.height --iPad: set the color fill width and height
      selected.y = self.y + self.height*0.5 --iPad: move the color fill to wherever the user tapped
      selected.isVisible = true --iPad: show the fill color
   else
      transition.to(myList, {time=400, x=display.contentWidth*-1, transition=easing.outExpo })
      transition.to(detailScreen, {time=400, x=0, transition=easing.outExpo })
      transition.to(backBtn, {time=400, x=math.floor(backBtn.width/2) + screenOffsetW*.5 + 6, transition=easing.outExpo })
      transition.to(backBtn, {time=400, alpha=1 })
   
      delta, velocity = 0, 0
   end
end

function backBtnRelease( event )
   print("back button released")
   transition.to(myList, {time=400, x=0, transition=easing.outExpo })
   transition.to(detailScreen, {time=400, x=display.contentWidth, transition=easing.outExpo })
   transition.to(backBtn, {time=400, x=math.floor(backBtn.width/2)+backBtn.width, transition=easing.outExpo })
   transition.to(backBtn, {time=400, alpha=0 })

   delta, velocity = 0, 0
end

function scrollToTop()
   myList:scrollTo(topBoundary-1)
end




---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
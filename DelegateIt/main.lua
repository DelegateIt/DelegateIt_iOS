--Starting Code for DelegateIt
--Created by: Benjamin Wernsman
-------------------------------

display.setStatusBar( display.TranslucentStatusBar )

--Load Required Files
local composer = require( "composer" )
local myData = require( "myData" )

--Variables
local options


function Main()	
	loadOptions()
	composer.gotoScene( "start",options) --change back to start
end


function loadOptions()
	options = {
    	effect = "fade",
   		time = 1200,
	}
end

Main()
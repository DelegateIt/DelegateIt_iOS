local localSave = require( "locals" )

local M = {}

local _W =  display.contentWidth
local _H =  display.contentHeight

M.width = _W
M.height = _H
M.xmid = _W/2
M.ymid = _H/2

function M.set()
	print("Making stuff")
end

return M
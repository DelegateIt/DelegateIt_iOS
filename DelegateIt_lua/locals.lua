local json = require( "json" )

local userData = {}

function makeUser()

end

function getUser(phone_number)
	return network.request( "http://52.24.58.77:80/customer/"..phone_number, "GET", networkListener, params )
end

function networkListener( event )
    if ( event.isError ) then
        print( "Network error!" )
    else
        print ( "RESPONSE: " .. event.response )
        local decoded = json.decode(event.response)
        print(decoded)
        print(decoded["first_name"])
        print(decoded["last_name"])
        print(decoded["phone_number"])
        print(decoded["result"])
        if(decoded["result"] == 1) then
        	print("Customer is not valid")
        	loggingIn = false
        	badLogin()
        elseif(decoded["result"] == 0) then
        	print("Customer is valid")
        	createJSON(decoded["phone_number"],decoded["first_name"],decoded["last_name"])
        	saveJSON()
        	gotoHome()
        end 
    end
end

--Create JSON
function createJSON(phone,first_name,last_name)
	print("creating JSON")
	userData.phone = phone
	userData.first_name = first_name
	userData.last_name = last_name
end

--Save JSON
function saveJSON()
	saveTable(userData, "user.json")
end

--load JSON
function loadJSON()
    print("Loading JSOn")
	userData = loadTable("user.json")
	phoneJSON = userData.phone
	first_nameJSON = userData.first_name
	last_nameJSON = userData.last_name
end

--JSON save
function saveTable(t, filename)
    local path = system.pathForFile( filename, system.DocumentsDirectory)
    local file = io.open(path, "w")
    if file then
        local contents = json.encode(t)
        file:write( contents )
        io.close( file )
        return true
    else
        return false
    end
end

--JSON load
function loadTable(filename)
    local path = system.pathForFile( filename, system.DocumentsDirectory)
    local contents = ""
    local myTable = {}
    local file = io.open( path, "r" )
    if file then
         -- read all contents of file into a string
         local contents = file:read( "*a" )
         myTable = json.decode(contents);
         io.close( file )
         return myTable 
    end
    return nil
end


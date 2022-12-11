show={}
systemBG = true 
darkBG = true 
searchFUNC = true 
sortBY = "name" 
show["3.0"] = true 
show["2.0"] = true 
show["1.x"] = true 
show["noScratchLink"] = true 
show["wScratchLink"] = true 
wrnNGPLAYER = false --set to true and it will annoy u every time u open it up
wrnNGPPPASTED = false --set it to true and it will annoy u every time u try to open .swf scratch mods
updateONstart = false --set it to true and it will update avalible mods every time you open it up
startTAB = "Launch" 
changeSTNGSonEXIT = false 
if darkBG then
    love.graphics.setBackgroundColor(0.2,0.2,0.2)
else
    love.graphics.setBackgroundColor(0.8,0.8,0.8)
end
if systemBG then
    local filename = (nativefs.getDirectoryItems(love.filesystem.getUserDirectory().."AppData\\Roaming\\Microsoft\\Windows\\Themes\\CachedFiles"))[1]
    if filename then
        --love.filesystem.write(filename,nativefs.read(love.filesystem.getUserDirectory().."AppData\\Roaming\\Microsoft\\Windows\\Themes\\CachedFiles\\"..filename))
        bg = nativefs.newFileData(love.filesystem.getUserDirectory().."AppData\\Roaming\\Microsoft\\Windows\\Themes\\CachedFiles\\"..filename)
        bg = love.graphics.newImage(bg)
    else
        systemBG = false
    end
end
if uDW then
    dw = uDW
end
if uDH then
    dh = uDH
end

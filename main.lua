--uses Squeak 3.7.1 VM for Win32 (works on 64 bit systems too) for launching 1.x scratch mods
nativefs = require"nativefs" nativefs.remove("download test")
--http = require"socket.http"
dofile("utf8 2.lua")
function update(v)end
function love.load()
    dofile("settings.lua")
    version = {}
    version.build = "2"
    version.date = "11.12.2022"
    bottom = {"Launch","Discover","Settings","img",["icons"]={[4]=love.graphics.newImage("icons/open path.png")}}
    if updateONstart then
        dupdatelua()
        if not((curentv.date == version.date)and(curentv.build == version.build)) then
            local a = love.window.showMessageBox("Update avalible","Update avalible",{"Download page","Install","ok"})
            if a==1 then
                love.system.openURL("https://github.com/Foxi135/ScratchModLauncher/releases")
            end
            if a==2 then
                local url = "http://github.com/Foxi135/ScratchModLauncher/blob/main/update.exe?raw=true"
                nativefs.remove("update.exe")
                os.execute("cd \""..nativefs.getWorkingDirectory()..'" && powershell "Invoke-WebRequest '..url..' -O update.exe"')
                os.execute("cd \""..nativefs.getWorkingDirectory()..'" && start update.exe')
                love.event.quit()
            end
        end
    end
    function setsettingstable()
        dw,dh = love.window.getDesktopDimensions()
        settings = {
            {"Set system background as background (beta)",systemBG,"bool","systemBG"},
            {"Dark background",darkBG,"bool","darkBG"},
            {"","","empty"},
            {"Search function",searchFUNC or true,"bool","searchFUNC"},
            {"Sort by",table.noOfItem({"name","version"},sortBY),"list","sortBY",["content"]={"name","version"},["rightclick"]={["x"]=50,["y"]=50,["allClicked"]=function(i) settings[5][2]=i end,{"name"},{"version"}}},
            {"Show","","empty"},
            {"     3.0 mods",show["3.0"],"bool",'show["3.0"]'},
            {"     2.0 mods",show["2.0"],"bool",'show["2.0"]'},
            {"     1.x mods",show["1.x"],"bool",'show["1.x"]'},
            {"     mods with no link to Scratch",show["noScratchLink"],"bool",'show["noScratchLink"]'},
            {"     mods with link to Scratch",show["wScratchLink"],"bool",'show["wScratchLink"]'},
            {"","","empty"},
            {"Warn if NG player will be needed on start",wrnNGPLAYER,"bool","wrnNGPLAYER","--set to true and it will annoy u every time u open it up"},
            {"Say that path has been copied when NG player starts",wrnNGPPPASTED,"bool","wrnNGPPPASTED","--set it to true and it will annoy u every time u try to open .swf scratch mods"},
            {"Look for updates on start",updateONstart,"bool","updateONstart","--set it to true and it will update avalible mods every time you open it up"},
            {"On start open tab",table.noOfItem({"Launch","Discover","Settings"},startTAB),"list","startTAB",["content"]={"Launch","Discover","Settings"},["rightclick"]={["x"]=50,["y"]=50,["allClicked"]=function(i) settings[15][2]=i end,{"Launch"},{"Discover"},{"Settings (if you need this XD)"}}},
            {"","","empty"},
            {"Desktop width",uDW or dw,"number","uDW"},
            {"Desktop height",uDH or dh,"number","uDH"},
            {"","","empty"},
            {"Look for updates",function() dupdatelua(true) end,"buttn"},
            {"Update list of mods",function() dupdatelua(false) end,"buttn"},
            {"Install new update (experimental)",function()
                    local url = "http://github.com/Foxi135/ScratchModLauncher/blob/main/update.exe?raw=true"
                    nativefs.remove("update.exe")
                    os.execute("cd \""..nativefs.getWorkingDirectory()..'" && powershell "Invoke-WebRequest '..url..' -O update.exe"')
                    os.execute("cd \""..nativefs.getWorkingDirectory()..'" && start update.exe')
                    love.event.quit()
                end,"buttn"},
            {"version "..version.date.." (build "..version.build..") by Foxi135",function() love.system.openURL("https://scratch.mit.edu/users/Foxi135") love.system.openURL("https://scratch.mit.edu/discuss/topic/642055") end,"buttn"},
            {"","","empty"},
            {"Refresh plugins",function() setsettingstable() loadplugns() end,"buttn"},
            {"Save settings when closing settings tab",changeSTNGSonEXIT or false,"bool","changeSTNGSonEXIT"},
            {"Save changes",function() changestngs() end,"buttn"},
            {"Quit",function() love.event.quit() end,"buttn"},
            --[[
            {"test",table.noOfItem({"a","b"},test),"list","test",["content"]={"a","b"},["rightclick"]=
                {["x"]=50,["y"]=50,
                {"a",["clicked"]=function() settings[15][2]=1 end},
                {"b",["clicked"]=function() settings[15][2]=2 end}}}
                ]]
        }
    end
    setsettingstable()
    font = love.graphics.newFont("Secular_One/SecularOne-Regular.ttf",25)
    unsupported = love.graphics.newFont("Noti Sans JP/NotoSansJP-Bold.otf",20)
    love.graphics.setFont(font)
    love.graphics.setDefaultFilter("nearest","nearest")
    dwnlddico = love.graphics.newImage("icons/downloaded.png")
    scratchfrmico = love.graphics.newImage("icons/Glow-S.png")
    magnfierico = love.graphics.newImage("icons/search.png")
    msv = {["1.x"]=love.graphics.newImage("icons/1.x.png"),["2.0"]=love.graphics.newImage("icons/2.0.png"),["3.0"]=love.graphics.newImage("icons/3.0.png")}
    load()
    clicked = false
    scroll = 0
    txt = nil
    rightclick = nil--{["x"]=50,["y"]=50,{"a",["hold"]="",["clicked"]=function() print("hello") end}}
    search = ""
    tab = 100
    tab = (({["Launch"]=1,["Discover"]=2,["Settings"]=3})[startTAB] or 1)*100
    --dofile("plugins/plugins.lua")
    --loadplugns()
end
--function plugindraw() end function loadplugns() end
function sortmbv() --sort mods by version (1.x,2.0,3.0)
    local output = {}
    for _,version in pairs({"1.x","2.0","3.0"}) do
        for k, v in ipairs(avalible) do
            if avalible[v]["defold"] == version then
                table.insert(output,v)
            end
        end
    end
    return output
end
function table.noOfItem(t,i)
    local hold
    for k, v in ipairs(t) do
        if v == i then
            hold = k
        end
    end
    return hold
end
function love.quit()
end
function changestngs()
    local file = ""
    for k, v in pairs(settings) do
        if (v[3] == "string") then
            file = file..v[4].." = \""..v[2].."\" "..(v[5] or "").."\n"
        elseif (v[3] == "number") then
            file = file..v[4].." = "..tostring(v[2]).." "..(v[5] or "").."\n"
        elseif (v[3] == "bool") then
            file = file..v[4].." = "..({[true]="true",[false]="false"})[v[2]].." "..(v[5] or "").."\n"
        elseif v[4]=="language" then
            file = file..v[4].." = \""..langs.short[v[2]].."\" "..(v[5] or "").."\n"
        elseif (v[3] == "list") then
            file = file..v[4].." = \""..v["content"][v[2]].."\" "..(v[5] or "").."\n"
        end
    end
    file = file..[[
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
]]  local presbg = systemBG
    local prelng = language 
    io.write(file)
    nativefs.write("settings.lua","show={}\n"..file)
    dofile("settings.lua")
    if not (prelng == language) then
        if love.filesystem.isFused() then
            if love.window.showMessageBox("Restart?","To change language you need to restart program.\nRestart?",{"yes","no"})==1 then
                os.execute("start \"\" \""..nativefs.getWorkingDirectory().."\\SML.exe\"")
                love.event.quit()
            end
        else
            love.window.showMessageBox("Not fused","This program is not fused\nyou'll need to restart program manually")
        end
    end
end
function dupdatelua(updatever)--downloads update.lua
    local url = "https://raw.githubusercontent.com/Foxi135/ScratchModLauncher/main/update.lua"
    nativefs.write("avalible-old.lua",nativefs.read("avalible.lua"))
    nativefs.remove("avalible.lua")
    os.execute("cd \""..nativefs.getWorkingDirectory().."\" && curl "..url.." -o avalible.lua")
    if (nativefs.read("avalible.lua") == "")or(nativefs.read("avalible.lua") == "404: Not Found") then
        love.window.showMessageBox("Failed","Failed to download\nupdate.lua from Github")
        nativefs.write("avalible.lua",nativefs.read("avalible-old.lua"))
    else
        local pngp = wrnNGPLAYER
        wrnNGPLAYER = false
        load()
        wrnNGPLAYER = pngp
        if updatever then
            if (curentv.date == version.date)and(curentv.build == version.build) then
                love.window.showMessageBox("Up to date","Your program is up to date")
            else
                local a = love.window.showMessageBox("Update avalible","Update avalible",{"Download page","Install","ok"})
                if a==1 then
                    love.system.openURL("https://github.com/Foxi135/ScratchModLauncher/releases")
                end
                if a==2 then
                    local url = "http://github.com/Foxi135/ScratchModLauncher/blob/main/update.exe?raw=true"
                    nativefs.remove("update.exe")
                    os.execute("cd \""..nativefs.getWorkingDirectory()..'" && powershell "Invoke-WebRequest '..url..' -O update.exe"')
                    os.execute("cd \""..nativefs.getWorkingDirectory()..'" && start update.exe')
                    love.event.quit()
                end
            end
        end
    end
end
function graphicprint(text,x,y,size)
    if not size then
        size = 1
    end
    local p = {""}
    local shift = 0
    local shifty = 0
    for i = 1,string.utf8len(text) do
        local c = string.utf8sub(text,i,i)
        if (not font:hasGlyphs(c)) or (c == "\n") then
            table.insert(p,c)
            table.insert(p,"")
        else
            p[#p] = p[#p]..c
        end
    end
    for i, v in pairs(p) do
        if (i%2)==0 then
            love.graphics.setFont(unsupported)
            love.graphics.print(v,x+shift,y,nil,size)
            shift = shift+unsupported:getWidth(v)*size
        else
            love.graphics.setFont(font)
            love.graphics.print(v,x+shift,y+shifty,nil,size)
            shift = shift+font:getWidth(v)*size
        end
        if v == "\n" then
            shifty = shifty+font:getHeight()*size
            shift = 0
        end
    end
    love.graphics.setFont(font)
end
function load()
    dofile("avalible.lua")
    local a = nativefs.getDirectoryItems("mods")
    mods = {["folders"]={},["all"]={}}
    local warned = false
    for k, v in pairs(a) do
        local ignorefile = nativefs.load(nativefs.getWorkingDirectory().."\\mods\\"..v.."\\modlaunch.lua")
        if ignorefile then
            ignorefile()
            if (openin[1] == "NGPlayer") and (not warned) and (wrnNGPLAYER) then
                warned = true
                if love.window.showMessageBox("NGPlayer","Some mods will later\nrequire Newgrounds Flash Player,\ndo you have it installed?",{"yes","Ignore","Download page"}) == 3 then
                    love.system.openURL("https://www.newgrounds.com/flash/player")
                end
            end
            if mods[identification["folder"]]==nil then
                mods[identification["folder"]]={}
                table.insert(mods["folders"],identification["folder"])
            end
            local icon = ""
            if identification["icon"] then
                icon = nativefs.getWorkingDirectory().."\\mods\\"..v.."\\"..identification["icon"]
            else
                icon = "undefined.png"
            end
            icon = nativefs.newFileData(icon)
            icon = love.graphics.newImage(icon)
            table.insert(mods[identification["folder"]],{identification["name"] or v,v,["icon"]=icon,["description"]=identification["description"]})
            table.insert(mods["all"],v)
        end
    end
    avalibleByV = sortmbv()
end
function openmod(open)
    local ignorefile = nativefs.load(nativefs.getWorkingDirectory().."\\mods\\"..open.."\\modlaunch.lua")
    ignorefile()
    if openin[1] == "SqueakVM" then
        os.execute("echo loading.. && cd \""..nativefs.getWorkingDirectory().."\\mods\\"..open.."\" && start \"\" \""..nativefs.getWorkingDirectory().."\\SqueakVM\\squeak.exe\"")
    end
    if openin[1] == "NGPlayer" then
        love.system.setClipboardText(nativefs.getWorkingDirectory().."\\mods\\"..open.."\\"..openin[2])
        if wrnNGPPPASTED then
            love.window.showMessageBox("Path copied!","Path has been copied to clipboard\nNewgrounds Flash player will now open")
        end
        os.execute("echo loading.. && start \"\" \"C:\\Program Files (x86)\\Newgrounds\\Newgrounds Player\\Newgrounds Player.exe")
    end
    if openin[1] == "custom" then
        os.execute("cd \""..nativefs.getWorkingDirectory().."\\mods\\"..open.."\" && start \"\" \""..openin[2].."\"")
    end
    love.window.minimize()
end
local function setColor(r,g,b,a)
    if darkBG then
        love.graphics.setColor(r,g,b,a)
    else
        love.graphics.setColor(1-r,1-g,1-b,a)
    end
end
function love.draw()
    love.graphics.setColor(1,1,1)
    ww,wh = love.graphics.getDimensions()
    if systemBG and bg then
        local wx,wy = love.window.getPosition()
        local bw,bh = bg:getWidth(),bg:getHeight()
        love.graphics.draw(bg,-wx,-wy,nil,dw/bw)
    end
    mx,my = love.mouse.getPosition()
    fh = font:getHeight()
    love.graphics.setColor(0,0,0)
    local shift = 0+(scroll*fh)
    if tab == 1 then --launch
        setColor(1,1,1,0.5)
        if (not txt) and searchFUNC then
            love.graphics.rectangle("fill",0,wh-fh*0.75,font:getWidth(search)*0.75+fh*0.75,fh*0.75)
            setColor(0,0,0,0.75)
            love.graphics.print(search,fh*0.75-4,wh-fh*0.75,nil,0.75)
            if love.mouse.isDown(1) and (not clicked) and inBox(0,wh-fh*0.75,font:getWidth(search)*0.75+fh*0.75,fh*0.75) then
                clicked = true
                txt = {["x"]=0,["y"]=love.graphics.getHeight()-font:getHeight()*0.75,["hold"]="",["txt"]=search,["done"]=function(txt,hold) search=txt  scroll=0 end}
            end
            setColor(0,0,0,0.75)
            love.graphics.draw(magnfierico,0,wh-fh*0.75,nil,fh*0.75/(magnfierico:getHeight()))
        end
        local count = 0
        for k, v in pairs(mods["folders"]) do
            setColor(1,1,1,0.2)
            graphicprint(v,12,shift+2)
            local mt = count
            setColor(1,1,1)
            graphicprint(v,10,shift)
            shift = shift+fh
            for l, w in pairs(mods[v]) do
                local matched = false
                if searchFUNC then
                    local exploded = string.explode(search or ""," ")
                    for k, l in pairs(exploded) do
                        if string.find(string.lower(w[1].." "..(w["name"] or "").." "..(w["description"] or "")),string.lower(l)) then
                            matched = true
                        end
                    end
                else
                    matched = true
                end
                if matched or(search=="") then
                    count = count+1
                    love.graphics.setColor(1,1,1)
                    love.graphics.draw(w["icon"],0,shift,nil,(fh/w["icon"]:getHeight()))
                    setColor(1,1,1,0.2)
                    graphicprint(w[1],fh+2,shift+2)
                    setColor(1,1,1)
                    graphicprint(w[1],fh,shift)
                    if (my>shift)and(my<fh+shift)and(my<wh-20) then
                        love.graphics.setColor(1,1,1,0.2)
                        if love.mouse.isDown(1) then
                            love.graphics.setColor(1,1,1,0.5)
                            if (not clicked) then
                                openmod(w[2])
                            end
                        end
                        if love.mouse.isDown(2) then
                            rightclick = {["x"]=mx,["y"]=my,
                            {"Open path in file explorer",["clicked"]=function()os.execute("start explorer \""..nativefs.getWorkingDirectory().."\\mods\\"..w[2].."\"")end},
                            {"Copy path",["clicked"]=function()love.system.setClipboardText(nativefs.getWorkingDirectory().."\\mods\\"..w[2])end},                        
                        }
                        end
                        love.graphics.rectangle("fill",fh,shift,ww,fh)
                        if w["description"] then
                            local hold = string.explode(w["description"] or "","\n")
                            hold = #hold
                            love.graphics.setColor(0,0,0,0.5)
                            love.graphics.rectangle("line",mx-3,my-1,(font:getWidth(w["description"] or "")*0.5+2)*-1,(fh*0.5*hold+2))
                            love.graphics.setColor(0.7,0.7,0.7,0.8)
                            love.graphics.rectangle("fill",mx-4,my,font:getWidth(w["description"] or "")*-0.5,fh*0.5*hold)
                            love.graphics.setColor(0,0,0)
                            graphicprint(w["description"] or "",mx-3-font:getWidth(w["description"] or "")*0.5,my,0.5)
                        end
                    end
                    shift = shift+fh
                end
            end
        end
        setColor(1,1,1,0.5)
        local p = count.." items"
        love.graphics.print(p,(ww-font:getWidth(p)*0.4)/2,shift+2,nil,0.4)
    end
    if tab == 2 then --discover
        setColor(1,1,1,0.5)
        if (not txt) and searchFUNC then
            love.graphics.rectangle("fill",0,wh-fh*0.75,font:getWidth(search)*0.75+fh*0.75,fh*0.75)
            setColor(0,0,0,0.75)
            love.graphics.print(search,fh*0.75-4,wh-fh*0.75,nil,0.75)
            if love.mouse.isDown(1) and (not clicked) and inBox(0,wh-fh*0.75,font:getWidth(search)*0.75+fh*0.75,fh*0.75) then
                clicked = true
                txt = {["x"]=0,["y"]=love.graphics.getHeight()-font:getHeight()*0.75,["hold"]="",["txt"]=search,["done"]=function(txt,hold) search=txt scroll=0 end}
            end
            setColor(0,0,0,0.75)
            love.graphics.draw(magnfierico,0,wh-fh*0.75,nil,fh*0.75/(magnfierico:getHeight()))
        end
        local a
        if sortBY == "version" then
            a = avalibleByV
        else
            a = avalible
        end
        local count = 0
        for k, v in ipairs(a) do
            local conditions = ((((avalible[v]["Scratch"] ~= nil)and show["wScratchLink"])or
            ((avalible[v]["Scratch"] == nil)and show["noScratchLink"]))and
            (((avalible[v]["defold"] == "3.0")and show["3.0"])or
            ((avalible[v]["defold"] == "2.0")and show["2.0"])or
            ((avalible[v]["defold"] == "1.x")and show["1.x"])))
            local matched = false
            if searchFUNC then
                local exploded = string.explode(search or ""," ")
                for k, l in ipairs(exploded) do
                    if string.find(string.lower(v),string.lower(l)) then
                        matched = true
                    end
                end
            else
                matched = true
            end
            if (conditions and matched) or (search=="") or (search==nil) then 
                count = count+1
                setColor(1,1,1,0.2)
                graphicprint(v,12,shift+2)
                setColor(1,1,1)
                graphicprint(v,10,shift)
                if (my>shift)and(my<fh+shift)and(mx<ww-fh)and(my<wh-20) then
                    love.graphics.setColor(1,1,1,0.2)
                    if love.mouse.isDown(1) then
                        love.graphics.setColor(1,1,1,0.5)
                        if (not clicked) then
                            love.system.openURL(avalible[v]["url"])
                        end
                    end
                    if love.mouse.isDown(2) then
                        local a
                        if nativefs.getInfo(nativefs.getWorkingDirectory().."\\mods\\"..v) then
                            a = "Open path in file explorer"
                        else
                            a = "Setup a directory for mod"
                        end
                        rightclick = {["x"]=mx,["y"]=my,
                        {a,["hold"]=v,["clicked"]=function(hold) discopenmod(hold)end},
                        {"Copy URL",["clicked"]=function()love.system.setClipboardText(avalible[v]["url"])end},                        
                    }
                    end
                    love.graphics.rectangle("fill",0,shift,ww-fh,fh)
                end
                if (avalible[v] or {})["Scratch"] then
                    if (my>shift)and(my<fh+shift)and(mx>ww-fh)and(my<wh-20) then
                        love.graphics.setColor(1,1,1,0.2)
                        if love.mouse.isDown(1) then
                            love.graphics.setColor(1,1,1,0.5)
                            if (not clicked) then
                                love.system.openURL(avalible[v]["Scratch"])
                            end
                        end
                        if love.mouse.isDown(2) then
                            rightclick = {["x"]=mx,["y"]=my,
                            {"Copy URL",["clicked"]=function()love.system.setClipboardText(avalible[v]["Scratch"])end},                        
                        }
                        end
                        love.graphics.rectangle("fill",ww-fh,shift,fh,fh)
                    end
                    love.graphics.setColor(1,1,1)
                    love.graphics.draw(scratchfrmico,ww-fh,shift,nil,fh/scratchfrmico:getWidth())
                end
                if table.find(mods["all"],v) then
                    love.graphics.setColor(0.5,0.8,0.5)
                    love.graphics.draw(dwnlddico,font:getWidth(v)+25,shift+5,nil,(fh-10)/dwnlddico:getWidth())
                end
                if (avalible[v] or {})["defold"] then
                    love.graphics.setColor(1,1,1,0.5)
                    love.graphics.draw(msv[avalible[v]["defold"]],ww-fh*2,shift+5,nil,(fh-10)/msv[avalible[v]["defold"]]:getWidth())
                end
                shift = shift+fh
            end
        end
        setColor(1,1,1,0.5)
        local p = count.." items"
        love.graphics.print(p,(ww-font:getWidth(p)*0.4)/2,shift+2,nil,0.4)
    end
    if tab == 3 then --settings
        local bts = {[true]="yes",[false]="no"}
        local ffh = fh*0.75
        local shift = scroll*ffh
        for k, v in pairs(settings) do
            setColor(1,1,1)
            love.graphics.print(v[1] or "",5,shift,nil,0.75)
            if v[3] == "bool" then
                love.graphics.print(bts[v[2]] or "",ww-font:getWidth(bts[v[2]] or "")*0.75-5,shift,nil,0.75)
                if (my>shift)and(my<ffh+shift)and(my<wh-20) then
                    love.graphics.setColor(1,1,1,0.2)
                    if love.mouse.isDown(1) then
                        love.graphics.setColor(1,1,1,0.5)
                        if (not clicked) then
                            settings[k][2] = not settings[k][2]
                        end
                    end
                    love.graphics.rectangle("fill",0,shift,ww,ffh)
                end
                shift = shift+ffh
            end
            if v[3] == "string" then
                love.graphics.print(v[2],ww-font:getWidth(v[2])*0.75-5,shift,nil,0.75)
                setColor(1,1,1,0.8)
                love.graphics.rectangle("fill",ww-font:getWidth(v[2])*0.75-5,shift+ffh-2,font:getWidth(v[2])*0.75,2)
                if (my>shift)and(my<ffh+shift)and(my<wh-20) then
                    love.graphics.setColor(1,1,1,0.2)
                    if love.mouse.isDown(1) then
                        love.graphics.setColor(1,1,1,0.5)
                        if (not clicked) then
                            txt = {["x"]=10+font:getWidth(v[1])*0.75,["y"]=shift,["hold"]=k,["txt"]=v[2],["done"]=function(txt,hold) settings[k][2] = txt changed = true end}
                        end
                    end
                    love.graphics.rectangle("fill",0,shift,ww,ffh)
                end
                shift = shift+ffh
            end  
            if v[3] == "number" then
                love.graphics.print(tostring(v[2]),ww-font:getWidth(tostring(v[2]))*0.75-5,shift,nil,0.75)
                setColor(1,1,1,0.8)
                love.graphics.rectangle("fill",ww-font:getWidth(tostring(v[2]))*0.75-5,shift+ffh-2,font:getWidth(tostring(v[2]))*0.75,2)
                if (my>shift)and(my<ffh+shift)and(my<wh-20) then
                    love.graphics.setColor(1,1,1,0.2)
                    if love.mouse.isDown(1) then
                        love.graphics.setColor(1,1,1,0.5)
                        if (not clicked) then
                            txt = {["x"]=10+font:getWidth(v[1])*0.75,["y"]=shift,["hold"]=k,["txt"]=tostring(v[2]),["done"]=function(txt,hold) settings[k][2] = tonumber(txt) changed = true end}
                        end
                    end
                    love.graphics.rectangle("fill",0,shift,ww,ffh)
                end
                shift = shift+ffh
            end            
            if v[3] == "list" then
                love.graphics.print(v["content"][v[2]] or "",ww-font:getWidth(v["content"][v[2]] or "")*0.75-5,shift,nil,0.75)
                if (my>shift)and(my<ffh+shift)and(my<wh-20) then
                    love.graphics.setColor(1,1,1,0.2)
                    if love.mouse.isDown(1) then
                        love.graphics.setColor(1,1,1,0.5)
                        if (not clicked) then
                            rightclick = v["rightclick"]
                            rightclick.x = font:getWidth(v[1])
                            rightclick.y = shift
                        end
                    end
                    love.graphics.rectangle("fill",0,shift,ww,ffh)
                end
                shift = shift+ffh
            end
            if v[3] == "empty" then
                if v[1] == "" then
                    setColor(0,0,0,0.2)
                    love.graphics.rectangle("fill",ffh/8-1,shift+ffh/8-1,ww-(ffh/8-1)*2,2)
                    shift = shift+ffh/4
                else
                    setColor(0,0,0,0.3)
                    setColor(1,1,1)
                    love.graphics.print(v[1] or "",6,shift,nil,0.75)
                    shift = shift+ffh
                end
            end
            if v[3] == "buttn" then
                if (my>shift)and(my<ffh+shift)and(my<wh-20) then
                    love.graphics.setColor(1,1,1,0.2)
                    if love.mouse.isDown(1) then
                        love.graphics.setColor(1,1,1,0.5)
                        if (not clicked) then
                            v[2]()
                        end
                    end
                    love.graphics.rectangle("fill",0,shift,ww,ffh)
                end
                shift = shift+ffh
            end
        end
    end
    --plugindraw()
    if txt then
        love.graphics.setColor(0.9,0.9,0.9)
        love.graphics.rectangle("fill",txt.x-2.5,txt.y,font:getWidth(txt.txt)*0.75+5,fh*0.75)
        love.graphics.setColor(0,0,0)
        love.graphics.print(txt.txt,txt.x,txt.y,nil,0.75)
        function love.textinput(t)
            txt.txt = txt.txt..t
        end
    end
    if true then --wrap
        local width = 0
        for k, v in ipairs(bottom) do
            if not (v == "img") then
                width = width+font:getWidth(v)*0.75+12
            else
                width=width+22
            end
        end
        local shift = (ww-width)/2
        for k, v in ipairs(bottom) do
            local fw = font:getWidth(v)*0.75

            if inBox(shift,wh-20,fw+10,20) then
                if love.mouse.isDown(1) and (not clicked) then
                    if (tab==3) and changeSTNGSonEXIT then
                        changestngs() setsettingstable() loadplugns()
                    end
                    tab = k*100
                end
            end
            if not (v == "img") then
                local y
                if tab == k then
                    y = 22
                    love.graphics.setColor(0.9,0.9,0.9)
                else
                    y = 20
                    love.graphics.setColor(0.9,0.9,0.9,0.75)
                end
                love.graphics.rectangle("fill",shift,wh-y,fw+10,y)
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.print(v,shift+5,wh-y,nil,0.75)
                shift = shift+fw+12
            else
                local y = 20
                love.graphics.setColor(0.9,0.9,0.9,0.75)
                love.graphics.rectangle("fill",shift,wh-20,20,20)
                love.graphics.rectangle("fill",shift,wh-y,y,y)
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.draw(bottom.icons[k],shift+(y-15)/2,wh-20+(20-15)/2,nil,(15/(bottom.icons[k]):getWidth()))
                shift = shift+22
            end
        end
    end
    if tab>99 then
        tab = tab/100
        love.window.setTitle("Scratch mod launcher"..(({""," - ".."Discover"," - ".."Settings",""})[tab] or ""))
        scroll = 0
    end
    if tab == 4 then
        tab = 1
        os.execute("start explorer \""..nativefs.getWorkingDirectory().."\"")
    end
    if love.mouse.isDown(1) then
        clicked = true
    else
        clicked = false
    end
    if rightclick then
        clicked = true
        local shift = rightclick.y
        local ffh = fh*0.5
        local w = 0
        local h = 0
        for i, v in ipairs(rightclick) do
            if w<font:getWidth(v[1])*0.5 then
                w=font:getWidth(v[1])*0.5
            end
            h=h+ffh
        end
        w=w+4
        love.graphics.setColor(0.2,0.2,0.2)
        love.graphics.rectangle("fill",rightclick.x-2,shift,w,h+2)
        for k, v in ipairs(rightclick) do
            love.graphics.setColor(1,1,1)
            love.graphics.print(v[1],rightclick.x,shift,nil,0.5)
            if inBox(rightclick.x,shift,w,ffh) then
                love.graphics.setColor(1,1,1,0.2)
                love.graphics.rectangle("fill",rightclick.x-2,shift,w,ffh)
            end
            shift = shift+ffh
        end
    end
    local _, _, flags = love.window.getMode()
    local width, height = love.window.getDesktopDimensions(flags.display)
    love.graphics.print(("display %d: %d x %d"):format(flags.display, width, height), 4, 10)
end
function love.mousepressed(mx,my,button)
    if rightclick then
        local inbox = false
        local shift = rightclick.y
        local ffh = fh*0.5
        local w = 0
        for i, v in ipairs(rightclick) do
            if w<font:getWidth(v[1]) then
                w=font:getWidth(v[1])
            end
        end
        w=w+4
        for k, v in ipairs(rightclick) do
            if inBox(rightclick.x,shift,w,ffh) then
                if rightclick.allClicked~=nil then
                    (rightclick.allClicked)(k)
                else
                    (v["clicked"])(v.hold)
                end
            end
            shift = shift+ffh
        end
        rightclick = nil
    end
end
function string.explode(str, div)
    assert(type(str) == "string" and type(div) == "string", "invalid arguments")
    local o = {}
    while true do
        local pos1,pos2 = str:find(div)
        if not pos1 then
            o[#o+1] = str
            break
        end
        o[#o+1],str = str:sub(1,pos1-1),str:sub(pos2+1)
    end
    return o
end
function inBox(x,y,xs,ys)
    return (mx>x)and(my>y)and(mx<x+xs)and(my<y+ys)and love.window.hasMouseFocus()
end
function discopenmod(v)
    if nativefs.getInfo(nativefs.getWorkingDirectory().."\\mods\\"..v) then
        os.execute("start explorer \""..nativefs.getWorkingDirectory().."\\mods\\"..v.."\"")
    else
        --love.window.minimize()
        nativefs.createDirectory(nativefs.getWorkingDirectory().."\\mods\\"..v)
        local data = 'name = "'..v..'"\n defold = "'..(avalible[v]["defold"] or "undefined")..'"'
        nativefs.write(nativefs.getWorkingDirectory().."\\mods\\"..v.."\\new.lua",data)
        os.execute("start \"\" \""..nativefs.getWorkingDirectory().."\\modsetup.exe\"")
    end
end
function love.keypressed(key)
    --pluginkeypressed(key)
    if txt then
        if key=="return" then
            txt.done(txt.txt,txt.hold)
            txt = nil
        end
        if key=="backspace" then
            txt.txt = string.utf8sub(txt.txt,1,string.utf8len(txt.txt)-1)
        end
    end
    if love.keyboard.isDown("lctrl") then
        if key=="r" then
            load()
        end
        if key=="c" then
            if tab == 2 then
                local shift = 0+(scroll*fh)
                for k, v in ipairs(avalible) do
                    if (my>shift)and(my<fh+shift)and(mx<ww-fh) then
                        love.system.setClipboardText((avalible[v] or {})["url"] or "")
                    end
                    if (my>shift)and(my<fh+shift)and(mx>ww-fh) then
                        love.system.setClipboardText((avalible[v] or {})["Scratch"] or "")
                    end
                shift = shift+fh
                end
            end
            if tab == 1 then
                local shift = 0
                for k, v in pairs(mods["folders"]) do
                    shift = shift+fh
                    for l, w in pairs(mods[v]) do
                        if (my>shift)and(my<fh+shift) then
                            love.system.setClipboardText(nativefs.getWorkingDirectory().."\\mods\\"..w[2])
                        end
                        shift = shift+fh
                    end
                end
            end
        end
        if key=="o" then
            if tab == 2 then
                local shift = 0+(scroll*fh)
                for k, v in ipairs(avalible) do
                    if (my>shift)and(my<fh+shift)and avalible[v] then
                        discopenmod(v)
                    end
                shift = shift+fh
                end
            end
            if tab == 1 then
                local shift = 0
                for k, v in pairs(mods["folders"]) do
                    shift = shift+fh
                    for l, w in pairs(mods[v]) do
                        if (my>shift)and(my<fh+shift) then
                            os.execute("start explorer \""..nativefs.getWorkingDirectory().."\\mods\\"..w[2].."\"")
                        end
                        shift = shift+fh
                    end
                end
            end
        end
    end
end
function love.wheelmoved(x,y)
    scroll=scroll+y
    if scroll>0 then
        scroll = 0
    end
    --pluginscrollwheel(x,y)
end
function table.find(t, s, o)
    o = o or 1
    assert(s ~= nil, "second argument cannot be nil")
    for i = o, #t do
        if t[i] == s then
            return i
        end
    end
end

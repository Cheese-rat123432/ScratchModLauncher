--uses Squeak 3.7.1 VM for Win32 (works on 64 bit systems too) for launching 1.x scratch mods
nativefs = require"nativefs"
dofile("utf8 2.lua")
function love.load()
    dofile("whoasked.lua")
    font = love.graphics.newFont("Secular_One/SecularOne-Regular.ttf",25)
    unsupported = love.graphics.newFont("Noti Sans JP/NotoSansJP-Bold.otf",25)
    love.graphics.setFont(font)
    love.graphics.setDefaultFilter("nearest","nearest")
    opnpthico = love.graphics.newImage("icons/open path.png")
    dwnlddico = love.graphics.newImage("icons/downloaded.png")
    scratchfrmico = love.graphics.newImage("icons/Glow-S.png")
    msv = {["1.x"]=love.graphics.newImage("icons/1.x.png"),["2.0"]=love.graphics.newImage("icons/2.0.png"),["3.0"]=love.graphics.newImage("icons/3.0.png")}
    load()
    clicked = false
    scroll = 0
    tab = 10
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
            if openin[1] == "NGPlayer" and not warned and wrnNGPLAYER then
                warned = true
                if love.window.showMessageBox("NGPlayer","Some mods will later\nrequire Newgrounds Flash Player,\ndo you have it installed?",{"Yes","Ignore","Download page"}) == 3 then
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
function love.draw()
    mx,my = love.mouse.getPosition()
    ww,wh = love.graphics.getDimensions()
    fh = font:getHeight()
    love.graphics.setBackgroundColor(0.8,0.8,0.8)
    love.graphics.setColor(0,0,0)
    local shift = 0+(scroll*fh)
    if tab == 1 then
        for k, v in pairs(mods["folders"]) do
            love.graphics.setColor(0,0,0,0.2)
            graphicprint(v,12,shift+2)
            love.graphics.setColor(0,0,0)
            graphicprint(v,10,shift)
            shift = shift+fh
            for l, w in pairs(mods[v]) do
                love.graphics.setColor(1,1,1)
                love.graphics.draw(w["icon"],0,shift,nil,(fh/w["icon"]:getHeight()))
                love.graphics.setColor(0,0,0,0.2)
                graphicprint(w[1],fh+2,shift+2)
                love.graphics.setColor(0,0,0)
                graphicprint(w[1],fh,shift)
                if (my>shift)and(my<fh+shift)and(my<wh-20) then
                    love.graphics.setColor(1,1,1,0.2)
                    if love.mouse.isDown(1) then
                        love.graphics.setColor(1,1,1,0.5)
                        if (not clicked) then
                            openmod(w[2])
                        end
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
        if true then --wrap
            local w = font:getWidth("Discover")
            love.graphics.setColor(0,0,0)
            love.graphics.print("Discover",(ww-w*0.75-20)/2,wh-20,nil,0.75)
            if inBox((ww-w-20)/2,wh-20,w,20) then
                love.graphics.setColor(1,1,1,0.4)
                if love.mouse.isDown(1) then
                    if not clicked then
                        tab = 20
                    end
                end
            else
                love.graphics.setColor(1,1,1,0.2)
            end
            love.graphics.rectangle("fill",(ww-w-20)/2,wh-20,w,20)
            love.graphics.setColor(0,0,0)
            love.graphics.draw(opnpthico,(ww-w-13)/2+w,wh-16,nil,15/opnpthico:getWidth())
            if inBox((ww-w-18)/2+w,wh-20,20,20) then
                love.graphics.setColor(1,1,1,0.4)
                if love.mouse.isDown(1) then
                    if not clicked then
                        os.execute("start explorer \""..nativefs.getWorkingDirectory().."\"")
                    end
                end
            else
                love.graphics.setColor(1,1,1,0.2)
            end
            love.graphics.rectangle("fill",(ww-w-18)/2+w,wh-20,20,20)
        end
    end
    if tab == 2 then
        for k, v in ipairs(avalible) do
            love.graphics.setColor(0,0,0,0.2)
            graphicprint(v,12,shift+2)
            love.graphics.setColor(0,0,0)
            graphicprint(v,10,shift)
            if (my>shift)and(my<fh+shift)and(mx<ww-fh)and(my<wh-20) then
                love.graphics.setColor(1,1,1,0.2)
                if love.mouse.isDown(1) then
                    love.graphics.setColor(1,1,1,0.5)
                    if (not clicked) then
                        love.system.openURL(avalible[v]["url"])
                    end
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
        if true then --wrap
            local w = font:getWidth("Launch")
            love.graphics.setColor(0,0,0)
            love.graphics.print("Launch",(ww-w*0.75-20)/2,wh-20,nil,0.75)
            if inBox((ww-w-20)/2,wh-20,w,20) then
                love.graphics.setColor(1,1,1,0.4)
                if love.mouse.isDown(1) then
                    if not clicked then
                        tab = 10
                    end
                end
            else
                love.graphics.setColor(1,1,1,0.2)
            end
            love.graphics.rectangle("fill",(ww-w-20)/2,wh-20,w,20)
            love.graphics.setColor(0,0,0)
            love.graphics.draw(opnpthico,(ww-w-13)/2+w,wh-16,nil,15/opnpthico:getWidth())
            if inBox((ww-w-18)/2+w,wh-20,20,20) then
                love.graphics.setColor(1,1,1,0.4)
                if love.mouse.isDown(1) then
                    if not clicked then
                        os.execute("start explorer \""..nativefs.getWorkingDirectory().."\"")
                    end
                end
            else
                love.graphics.setColor(1,1,1,0.2)
            end
            love.graphics.rectangle("fill",(ww-w-18)/2+w,wh-20,20,20)
        end
    end
    if tab>9 then
        tab = tab/10
        love.window.setTitle("Scratch mod launcher"..({""," - Discover"})[tab])
        scroll = 0
    end
    local bottomtxt = "version 17.11.2022 (build 1.2) by Foxi135"
    love.graphics.setColor(0,0,0,0.2)
    love.graphics.print(bottomtxt,ww-font:getWidth(bottomtxt)*0.4,wh-font:getHeight()*0.4,nil,0.4)
    if (mx>(ww-font:getWidth(bottomtxt)*0.5)) and (my>(wh-font:getHeight()*0.5)) then
        if love.mouse.isDown(1) and (not clicked) then
            love.system.openURL("https://scratch.mit.edu/users/Foxi135")
            love.system.openURL("https://scratch.mit.edu/discuss/topic/642055")
        end
    end
    if love.mouse.isDown(1) then
        clicked = true
    else
        clicked = false
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
function love.keypressed(key)
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
    end
    if key=="o" then
        if tab == 2 then
            local shift = 0+(scroll*fh)
            for k, v in ipairs(avalible) do
                if (my>shift)and(my<fh+shift)and avalible[v] then
                    if nativefs.getInfo(nativefs.getWorkingDirectory().."\\mods\\"..v) then
                        os.execute("start explorer \""..nativefs.getWorkingDirectory().."\\mods\\"..v.."\"")
                    else
                        if 1==love.window.showMessageBox("Does not exist","Directory\n"..nativefs.getWorkingDirectory().."\\mods\\"..v.."\n does not exist, do you want to create one?",{"Create","Ignore"}) then
                            love.window.minimize()
                            nativefs.createDirectory(nativefs.getWorkingDirectory().."\\mods\\"..v)
                            local comment = "--[["..
[[
u have 3 options:
1 SqueakVM
2 custom
    and executable name (with ".exe" at the end)
3 NGPlayer (Newgrounds Flash player)
    and .swf name
example: openin={"custom","Turbowarp.exe"}
]].."]]"
                            local data = "openin={\"\"}"..comment.."\nidentification={[\"name\"]=\""..v.."\",[\"folder\"]=\""..avalible[v]["defold"].."\"}--theres also an option for [\"description\"], check Scratch60 for example\n"
                            nativefs.write(nativefs.getWorkingDirectory().."\\mods\\"..v.."\\modlaunch.lua",data)
                            os.execute("start explorer \""..nativefs.getWorkingDirectory().."\\mods\\"..v.."\"")
                            os.execute("start notepad \""..nativefs.getWorkingDirectory().."\\mods\\"..v.."\\modlaunch.lua\"")
                        end
                    end
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
function love.wheelmoved(x,y)
    scroll=scroll+y
    if scroll>0 then
        scroll = 0
    end
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

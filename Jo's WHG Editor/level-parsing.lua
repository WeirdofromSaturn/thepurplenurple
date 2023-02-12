--[[
level = {
    {
        {
            {
                {
                    {} -- level x axis
                } -- level y axis
            } -- layer
        } -- multiarea x axis
    }, -- multiarea y axis
    {
        movement = "jo560hs"
    } -- level options
} -- the level
--]]

level = {
    {
        {
            {
                {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
                {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
                {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
                {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
                {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
                {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
                {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
                {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
                {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
                {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
                {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
                {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
                {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
                {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
                {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
                {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
                {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
                {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
                {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
                {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
                {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},
                {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
                {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
                {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
            } -- layer
        } -- multiarea x axis
    }, -- multiarea y axis
    {
        {}
    }, -- symbols
    {
        movement = "jo560hs"
    } -- level options
} -- the level

function splitstr(inputstr, sep)
    if sep == nil then
       sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
       table.insert(t, str)
    end
    return t
 end
 
 -- test = splitstr("I,am,a,test", ",")

function genlevel()
    levelstr = ""
    for a = 1 , #level do
        levelstra = ""
        if not (levelstra == "") then
            levelstra = levelstra .. "|"
        end
        for b = 1 , #level[a] do
            levelstrb = ""
            if not (levelstrb == "") then
                levelstrb = levelstrb .. ";"
            end
            for c = 1 , #level[a][b] do
                levelstrc = ""
                if not (levelstrc == "") then
                    levelstrc = levelstrc .. ":"
                end
                for d = 1 , #level[a][b][c] do
                    levelstrd = ""
                    if not (levelstrd == "") then
                        levelstrd = levelstrd .. "."
                    end
                    for e = 1 , #level[a][b][c][d] do
                        levelstre = ""
                        if not (levelstre == "") then
                            levelstre = levelstre .. ","
                        end
                        levelstre = levelstre .. level[a][b][c][d][e]
                        levelstr = levelstr .. levelstre
                    end
                    levelstrd = levelstrd .. level[a][b][c][d]
                    levelstr = levelstr .. levelstrd
                end
                levelstrc = levelstrc .. level[a][b][c]
                levelstr = levelstr .. levelstrc
            end
            levelstrb = levelstrb .. level[a][b]
            levelstr = levelstr .. levelstrb
        end
        levelstra = levelstra .. level[a]
        levelstr = levelstr .. levelstra
    end
    return levelstr
end

-- split operators: | ; : . ,

function getlevel(str)
    level={}
    for a=1,#level do
        level[a]=splitstr(level[a], "|")
        for b=1,#level[a] do
            level[a][b]=splitstr(level[a][b], ";")
            for c=1,#level[a][b] do
                level[a][b][c]=splitstr(level[a][b][c], ":")
                for d=1,#level[a][b][c] do
                    level[a][b][c][d]=splitstr(level[a][b][c][d], ".")
                    for e=1,#level[a][b][c][d] do
                        level[a][b][c][d][e]=splitstr(level[a][b][c][d][e], ",")
                    end
                end
            end
        end
    end
end

return level
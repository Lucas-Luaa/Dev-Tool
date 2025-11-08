local K = {
    ["and"]=true,["break"]=true,["do"]=true,["else"]=true,["elseif"]=true,["end"]=true,
    ["false"]=true,["for"]=true,["function"]=true,["if"]=true,["in"]=true,["local"]=true,
    ["nil"]=true,["not"]=true,["or"]=true,["repeat"]=true,["return"]=true,["then"]=true,
    ["true"]=true,["until"]=true,["while"]=true,["continue"]=true
}
local E = {
    ["\""]="\\\"",["\\"]="\\\\",["\a"]="\\a",["\b"]="\\b",["\t"]="\\t",["\n"]="\\n",
    ["\v"]="\\v",["\f"]="\\f",["\r"]="\\r",["\0"]="\\x00"
}
for i = 1, 31   do local c = string.char(i) if not E[c] then E[c] = "\\x"..string.format("%02X", i) end end
for i = 127, 255 do local c = string.char(i) E[c] = "\\x"..string.format("%02X", i) end
local function S(s)
    return '"' .. string.gsub(s, '[\\"\0-\31\127-\255]', E) .. '"'
end

local function PathOf(obj, root)
    if obj == game then return "game" end
    if obj == workspace then return "workspace" end
    if not obj then return "nil" end

    local path, cur = {}, obj
    local base = root or game

    while cur do
        local n, c, p = cur.Name, cur.ClassName, cur.Parent
        local key = (K[n] or not n:match("^[%a_][%w_]*$") or n == "") and "["..S(n).."]" or "."..n
        table.insert(path, 1, key)

        if p == game and pcall(game.FindService, game, c) then
            table.insert(path, 1, ":GetService("..S(c)..")")
            table.insert(path, 1, "game")
            return table.concat(path)
        end
        if p == workspace then
            table.insert(path, 1, "workspace")
            return table.concat(path)
        end
        cur = p
    end

    local ctx = getthreadcontext()
    setthreadcontext(8)
    local id = shared.UseDebugId and obj.GetDebugId and obj:GetDebugId() or obj.Name
    setthreadcontext(ctx)
    return `<{obj.ClassName} {id}>`
end

return PathOf

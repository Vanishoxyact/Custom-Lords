--v function(list: vector<string>, value: string) --> boolean
function listContains(list, value)
    for i, listValue in ipairs(list) do
        if listValue == value then
            return true;
        end
    end
    return false;
end

--v function(list: vector<string>, toRemove: string)
function removeFromList(list, toRemove)
    for i, value in ipairs(list) do
        if value == toRemove then
            table.remove(list, i);
            return;
        end
    end
end

--v [NO_CHECK] function(t: WHATEVER, order: function(WHATEVER, WHATEVER, WHATEVER) --> boolean)
function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end
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
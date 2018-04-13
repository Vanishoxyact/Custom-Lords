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

--v function(buttons: vector<TEXT_BUTTON>)
function setUpSingleButtonSelectedGroup(buttons)
    for i, button in ipairs(buttons) do
        button:RegisterForClick(
            function(context)
                for i, otherButton in ipairs(buttons) do
                    if button.name == otherButton.name then
                        otherButton:SetState("selected_hover");
                    else
                        otherButton:SetState("active");
                    end
                end
            end
        );
    end
end

--v function(buttons: vector<BUTTON>)
function setUpSingleButtonSelectedGroupButton(buttons)
    for i, button in ipairs(buttons) do
        button:RegisterForClick(
            function(context)
                for i, otherButton in ipairs(buttons) do
                    if button.name == otherButton.name then
                        otherButton:SetState("selected_hover");
                    else
                        otherButton:SetState("active");
                    end
                end
            end
        );
    end
end

function detectBeta()
    local file = io.open("custom_lords_beta_key.txt", "rb")
    if not file then 
        CLC_BETA = false;
    else
        local content = file:read "*a"
        if content == "09bNNrmFsJ78c41iZB6H" then
            CLC_BETA = true;
        else
            CLC_BETA = false;
        end
        file:close()
    end
end
local is_ontop = false
local was_ontop = false


-- toggle ontop 
function toggle_ontop()
    if is_ontop then 
        mp.set_property_bool("ontop", false)
        is_ontop = false
    else
        mp.set_property_bool("ontop", true)
        is_ontop = true
    end
end

-- disable ontop when in fullscreen mode
function disable_ontop(name, value)
    if is_ontop then
        was_ontop = true
    else
        was_ontop = false
    end

    if value then
        if mp.get_property_bool("ontop") then
            mp.set_property_bool("ontop", false)
            if is_ontop then
                    is_ontop = false
            end
        end
    end

end

-- toggle ontop on after exiting fullscreen
function revert_ontop(name, value)
    if not value then
        if was_ontop then
            mp.set_property_bool("ontop", true) 
            is_ontop = true
            was_ontop = false
        end
    end
end

mp.add_key_binding("t", "ontop", toggle_ontop)
mp.observe_property("fullscreen", "bool", revert_ontop)
mp.observe_property("fullscreen", "bool", disable_ontop)
 
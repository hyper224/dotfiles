local is_shuffled = false
local shuffle_mode = nil

function shuffle_playlist()
    if is_shuffle then
        mp.command("playlist-unshuffle")
        shuffle_mode = "Off"
        mp.osd_message(string.format("Shuffle: %s", shuffle_mode))
        is_shuffle = false
    else
        mp.command("playlist-shuffle")
        shuffle_mode = "On"
        mp.osd_message(string.format("Shuffle: %s", shuffle_mode))
        is_shuffle = true        
    end
    -- mp.osd_message(string.format("Shuffle: %s", is_turned_on), 3)
end

mp.add_key_binding("r", "shuffle", shuffle_playlist)
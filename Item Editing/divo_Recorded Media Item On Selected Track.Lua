-- package.cpath = package.cpath .. ";" .. reaper.GetResourcePath() ..'/Scripts/Lua Sockets/socket module/?.dll'    -- WINDOWS ONLY: Add socket module path for .dll files
-- package.path = package.path .. ";" .. reaper.GetResourcePath()   ..'/Scripts/Lua Sockets/socket module/?.lua'      -- Add all lua socket modules to the path  
-- require("mobdebug").start()

-- @description Move Recorded MediaItem on Selected Track from Target Rec Track 
-- @author divohub
-- @version 0.0.1

local section = "RecTrackStore"
local key = "rec_track_guid"

function GetTrackbySavedGUID()
    local _, rec_guid = reaper.GetProjExtState(0, section, key)
    if not rec_guid or rec_guid == "" then
        reaper.ShowMessageBox("Не найден сохраненный трек, пожалуйста, сохарните трек с помощью скрипта настройки", "Ошибка", 0)
        return nil
    end
    local track_count = reaper.CountTracks(0)

    for i = 0, track_count - 1 do 
        local track = reaper.GetTrack(0, i)
        local guid = reaper.GetTrackGUID(track)
        if guid == rec_guid then 
            return track
        end
    end
    return nil

    
end


function MoveLastRecordedItem(track)
    if not track then return end

    local dist_track = reaper.GetSelectedTrack(0,0)
    local items_count = reaper.CountTrackMediaItems(track)
    if items_count == 0 then
        reaper.ShowMessageBox("No Recorded Items on Rec Track!", "Error", 0)
        return
    end
    local last_position = 0
    local last_item = nil

    for i = 0, items_count - 1  do 
        local item = reaper.GetTrackMediaItem(track, i)
        local position = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        if position > last_position then
            last_item = item
        end
    end
    reaper.Undo_BeginBlock()
    reaper.MoveMediaItemToTrack(last_item, dist_track)
    reaper.Undo_EndBlock("Move last recorded item to selected track", -1)
    reaper.SetMediaItemSelected(last_item, true)
    reaper.UpdateArrange()

end

local track = GetTrackbySavedGUID()
MoveLastRecordedItem(track)



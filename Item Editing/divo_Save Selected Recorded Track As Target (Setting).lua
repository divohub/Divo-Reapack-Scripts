-- @description A script for selecting a target rec track for a project (works with Recorded Media Item On Selected Track) 
-- @author divohub
-- @version 1.1



-- package.cpath = package.cpath .. ";" .. reaper.GetResourcePath() ..'/Scripts/Lua Sockets/socket module/?.dll'    -- WINDOWS ONLY: Add socket module path for .dll files
-- package.path = package.path .. ";" .. reaper.GetResourcePath()   ..'/Scripts/Lua Sockets/socket module/?.lua'      -- Add all lua socket modules to the path  
-- require("mobdebug").start()



local section = "RecTrackStore"
local key = "rec_track_guid"

function SaveSelectedTrackGUID()
    
    local track = reaper.GetSelectedTrack(0, 0)

    if not track then
        reaper.ShowMessageBox("Track is not selected","Ошибка", 0)
        return
    end

    local guid = reaper.GetTrackGUID(track)
    if not guid or guid == "" then 
        reaper.ShowMessageBox("No GUID", "Ошибка", 0)
        return
    end
    
    reaper.SetProjExtState(0, section, key, guid)
    local _, rec_guid = reaper.GetProjExtState(0, section, key)
    if rec_guid == guid then
        reaper.ShowMessageBox("Selected Track is now Target Rec Track", "Готово", 0)
    end

end

SaveSelectedTrackGUID()


-- package.cpath = package.cpath .. ";" .. reaper.GetResourcePath() ..'/Scripts/Lua Sockets/socket module/?.dll'    -- WINDOWS ONLY: Add socket module path for .dll files
-- package.path = package.path .. ";" .. reaper.GetResourcePath()   ..'/Scripts/Lua Sockets/socket module/?.lua'      -- Add all lua socket modules to the path  
-- require("mobdebug").start()

-- @description A script for selecting a target rec track for a project (works with Recorded Media Item On Selected Track) 
-- @author divohub
-- @version 0.0.1

local section = "RecTrackStore"
local key = "rec_track_guid"

function SaveSelectedTrackGUID()
    
    local track = reaper.GetSelectedTrack(0, 0)

    if not track then
        reaper.ShowMessageBox("Ошибка не выбран трек","Ошибка", 0)
        return
    end

    local guid = reaper.GetTrackGUID(track)
    if not guid or guid == "" then 
        reaper.ShowMessageBox("Guid не получен", "Ошибка", 0)
        return
    end
    
    reaper.SetProjExtState(0, section, key, guid)
    local _, rec_guid = reaper.GetProjExtState(0, section, key)
    if rec_guid == guid then
        reaper.ShowMessageBox("GUID успешно сохранён", "Готово", 0)
    end

end

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

SaveSelectedTrackGUID()


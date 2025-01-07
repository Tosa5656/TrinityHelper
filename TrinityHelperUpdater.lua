script_name("Trinity Helper Updater")
script_author("Tosa | lugovojs.")
script_version("1.0")

require "lib.moonloader"
local dlstatus = require('moonloader').download_status

resources_dir = getGameDirectory() .. "//moonloader//resource//trinity_helper//"

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end

    check_update_script()

    sampRegisterChatCommand("update", update_script)

    while true do wait(0) end
end

function printChatMessage(message)
    if message == nil then
        print("Error! Message = nil. From printChatMessage")
        return
    end
    sampAddChatMessage("{EE9611}" .. message, 0xFF9900)
end

function check_update_script()
    downloadUrlToFile('https://raw.githubusercontent.com/Tosa5656/TrinityHelper/refs/heads/master/resource/trinity_helper/version.txt', resources_dir .. "new_version.txt", function(id, status, p1, p2) 
        if status == dlstatus.STATUS_DOWNLOADINGDATA then
            sampAddChatMessage(string.format('Загружено %d из %d.', p1, p2))
        elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
            actual_version_file = io.open(resources_dir .. "version.txt")
            actual_version = actual_version_file:read("*a")
            actual_version_file:close()

            downloaded_version_file = io.open(resources_dir .. "new_version.txt")
            downloaded_version = downloaded_version_file:read("*a")
            downloaded_version_file:close()

            if actual_version ~= downloaded_version then
                printChatMessage("[Trinity Helper] " .. "Обнаружено обновление скрипта, используйте /trphelper для обновления.")
            end
        end
    end)
end

function update_script()
    os.remove(getGameDirectory() .. "//moonloader//TrinityHelper.lua")
    downloadUrlToFile('https://raw.githubusercontent.com/Tosa5656/TrinityHelper/refs/heads/master/TrinityHelper.lua', getGameDirectory() .. "//moonloader//TrinityHelper.lua", function(id, status, p1, p2) end)
    os.remove(resources_dir .. "new_version.txt")
    printChatMessage(downloaded_version)
    actual_version_file = io.open(resources_dir .. "version.txt", "w")
    actual_version_file:write(downloaded_version)
    actual_version_file:close()
end
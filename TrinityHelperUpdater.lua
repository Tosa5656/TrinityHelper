script_name("Trinity Helper Updater")
script_author("Tosa | lugovojs.")
script_version("3.0")

require "lib.moonloader"
local dlstatus = require('moonloader').download_status

local encoding = require "encoding"
encoding.default = "CP1251"
u8 = encoding.UTF8
cp1251 = encoding.CP1251

resources_dir = getGameDirectory() .. "//moonloader//resource//trinity_helper//"

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end

    check_update_script()

    sampRegisterChatCommand("trphelperupdate", update_script)

    while true do wait(0) end
end

function printChatMessage(message)
    if message == nil then
        print("Error! Message = nil. From printChatMessage")
        return
    end
    sampAddChatMessage("{EE9611}" .. "[Trinity Helper] " .. cp1251:encode(message, "UTF-8"), 0xFF9900)
end

function check_update_script()
    downloadUrlToFile('https://github.com/Tosa5656/TrinityHelper/raw/refs/heads/master/resource/trinity_helper/version.txt', resources_dir .. "new_version.txt", function(id, status, p1, p2) 
        if status == dlstatus.STATUS_DOWNLOADINGDATA then
            sampAddChatMessage(string.format('Загруженно %d изВ %d.', p1, p2))
        elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
            actual_version_file = io.open(resources_dir .. "version.txt")
            actual_version = actual_version_file:read("*a")
            actual_version_file:close()

            downloaded_version_file = io.open(resources_dir .. "new_version.txt")
            downloaded_version = downloaded_version_file:read("*a")
            downloaded_version_file:close()

            if actual_version ~= downloaded_version then
                printChatMessage("Обнаружено обновление скрипта, используйте /trphelper для обновления.")
            end
        end
    end)
end

function update_script()
    os.remove(getGameDirectory() .. "//moonloader//TrinityHelper.lua")
    downloadUrlToFile('https://raw.githubusercontent.com/Tosa5656/TrinityHelper/refs/heads/master/TrinityHelper.lua', getGameDirectory() .. "//moonloader//TrinityHelper.lua", function(id, status, p1, p2) end)
    os.remove(resources_dir .. "new_version.txt")
    printChatMessage("Скрипт обновлен до версии: " .. downloaded_version)
    actual_version_file = io.open(resources_dir .. "version.txt", "w")
    actual_version_file:write(downloaded_version)
    actual_version_file:close()
end
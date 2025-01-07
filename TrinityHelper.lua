script_name("Trinity Helper")
script_author("Tosa | lugovojs.")
script_version("4.0")

require "lib.moonloader"
local sampev = require "lib.samp.events"
local imgui = require "imgui"
local encoding = require "encoding"
encoding.default = "CP1251"
u8 = encoding.UTF8

resources_dir = getGameDirectory() .. "//moonloader//resource//trinity_helper//"

last_id = nil
answers_count = 0

local show_main_window = imgui.ImBool(false)
local flags_main_window = imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse

DescriptionId = 1
DescriptionFiles = {"desc1.txt", "desc2.txt", "desc3.txt", "desc4.txt", "desc5.txt"}

desc1 = {"", ""}
desc2 = {"", ""}
desc3 = {"", ""}
desc4 = {"", ""}
desc5 = {"", ""}

local fontsize = nil
local fontsize_basic = nil

function imgui.OnDrawFrame()
    if show_main_window then
        imgui.SetNextWindowSize(imgui.ImVec2(800, 600), imgui.Cond.Always)
        local sizeX, sizeY = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin("Trinity Helper", show_main_window, flags_main_window)
        imgui.BeginChild("##buttonslist",imgui.ImVec2(170 ,565), true)
        if imgui.Button(u8"Î ñêðèïòå", imgui.ImVec2(160, 35)) then
            DescriptionId = 1
        end

        if imgui.Button(u8"Èíôîðìàöèÿ\näëÿ õåëïåðîâ", imgui.ImVec2(160, 35)) then
            DescriptionId = 2
        end

        if imgui.Button(u8"Íàñòðîéêè", imgui.ImVec2(160, 35)) then
            DescriptionId = 3
        end

        if imgui.Button(u8"Ïðåäëîæåíèÿ\n  ïî ñêðèïòó", imgui.ImVec2(160, 35)) then
            DescriptionId = 4
        end

        if imgui.Button(u8"Îáðàòíàÿ ñâÿçü", imgui.ImVec2(160, 35)) then
            DescriptionId = 5
        end
        imgui.EndChild()
        imgui.SameLine()
        --imgui.PopStyleColor(1)
        imgui.BeginChild("##descriptionlist",  imgui.ImVec2(610, 565), true)
        
        if DescriptionId == 1 then
            imgui.PushFont(fontsize)
            imgui.Text(desc1[1])
            imgui.PopFont()
            
            imgui.PushFont(fontsize_basic)
            imgui.Text(desc1[2])
            imgui.PopFont()
        end

        if DescriptionId == 2 then
            imgui.PushFont(fontsize)
            imgui.Text(desc2[1])
            imgui.PopFont()
            
            imgui.PushFont(fontsize_basic)
            imgui.Text(desc2[2])
            imgui.PopFont()
        end

        if DescriptionId == 3 then
            imgui.PushFont(fontsize)
            imgui.Text(desc3[1])
            imgui.PopFont()
            
            imgui.PushFont(fontsize_basic)
            imgui.Text(desc3[2])
            imgui.PopFont()
        end

        if DescriptionId == 4 then
            imgui.PushFont(fontsize)
            imgui.Text(desc4[1])
            imgui.PopFont()
            
            imgui.PushFont(fontsize_basic)
            imgui.Text(desc4[2])
            imgui.PopFont()
        end

        if DescriptionId == 5 then
            imgui.PushFont(fontsize)
            imgui.Text(desc5[1])
            imgui.PopFont()
            
            imgui.PushFont(fontsize_basic)
            imgui.Text(desc5[2])
            imgui.PopFont()
        end

        imgui.EndChild()
        imgui.End()
    end
end

function imgui.BeforeDrawFrame()
    if fontsize == nil then
        fontsize = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 30.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic()) -- âìåñòî 30 ëþáîé íóæíûé ðàçìåð
    end

    if fontsize_basic == nil then
        fontsize_basic = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 16.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
    end
end

function printChatMessage(message)
    if message == nil then
        print("Error! Message = nil. From printChatMessage")
        return
    end
    sampAddChatMessage("{EE9611}" .. message, 0xFF9900)
end

function readDescription(number)
    file = io.open(resources_dir .. "desc" .. number.. ".txt")
    local first_line = ""
    local rest_lines = ""
    local line_count = 0

    for line in file:lines() do
        line_count = line_count + 1
        if line_count == 1 then
            first_line = line
        else
            rest_lines = rest_lines .. line .. "\n"
        end
    end
    file:close()
    return {first_line, rest_lines}
end

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    sampRegisterChatCommand("trphelper", trphelper_func)
    sampRegisterChatCommand("answhelp.print", answhelp_print)
    sampRegisterChatCommand("answhelp.reset", answhelp_reset)

    loadAnswersCount()

    desc1 = readDescription("1")
    desc2 = readDescription("2")
    desc3 = readDescription("3")
    desc4 = readDescription("4")
    desc5 = readDescription("5")

    printChatMessage("[Trinity Helper] " .. "Ñêðèïò äëÿ õåëïåðà Trinity GTA" .. " v" ..  thisScript().version .. " " .. "îò Tosa | lugovojs." .. " áûë çàïóùåí. Àêòèâàöèÿ - /trphelper.")

    imgui.Process = true

    while true do wait(0) 
        imgui.Process = show_main_window.v
        if  wasKeyPressed(VK_1) and isKeyDown(VK_MENU) then
            if last_id == nil then
                printChatMessage("Íå íàéäåíî ïîñëåäíåãî âîïðîñà è åãî ID.")
            else
                sampSetChatInputText('/answ '..last_id..' ')
                sampSetChatInputEnabled(true)
            end
        end
    end
end

function sampev.onServerMessage(color, text)
    if text:match('Âîïðîñ%sîò%s.*%sID%s%d+:.*') then
        last_id = text:match('Âîïðîñ%sîò%s.*%sID%s(%d+):.*')
    end

    if text:match('Îò%sManny_Westfall%säëÿ%s.*:%s*') then
        answers_count = answers_count + 1
        saveAnswers()
    end
end

function loadAnswersCount()
    file = io.open(resources_dir .. "answers.txt", "r")
    answers_count = file:read("*a")
    file:close()
end

function saveAnswers(count)
    file = io.open(resources_dir .. "answers.txt", "w")
    file:write(answers_count)
    file:close()
end

function trphelper_func()
    show_main_window = imgui.ImBool(true)
end

function answhelp_print()
    file = io.open(resources_dir .. "answers.txt", "r")
    printChatMessage("Âàøå êîëè÷åñòâî îòâåòîâ: " .. answers_count)
    file:close()
end

function answhelp_reset()
    file = io.open(resources_dir .. "answers.txt", "w")
    file:write("0")
    file:close()
    loadAnswersCount()
    printChatMessage("Ñ÷¸ò÷èê îòâåòîâ óñïåøíî îáíóë¸í.")
end

function updateScript()
    downloadUrlToFile('ññûëêà', 'ïóòü ê ñîõðàíåíèþ ôàéëà', function(id, status, p1, p2) end)
end

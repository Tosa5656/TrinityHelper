script_name("Trinity Helper")
script_author("Tosa | lugovojs.")
script_version("4.5")

require "lib.moonloader"
local sampev = require "lib.samp.events"
local imgui = require "imgui"
local encoding = require "encoding"
encoding.default = "CP1251"
u8 = encoding.UTF8
cp1251 = encoding.CP1251

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
desc5 = {"", " "}

local fontsize_basic = nil
local fonsize_medium = nil
local fontsize = nil

function imgui.OnDrawFrame()
    if show_main_window then
        imgui.SetNextWindowSize(imgui.ImVec2(800, 600), imgui.Cond.Always)
        local sizeX, sizeY = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin("Trinity Helper", show_main_window, flags_main_window)

        local titlebarBgColor = imgui.GetStyleColorVec4(imgui.Col.TitleBg)

        imgui.BeginChild("##buttonslist",imgui.ImVec2(170 ,565), true)
        imgui.PushStyleColor(imgui.Col.Button, titlebarBgColor)
        if imgui.Button("О скрипте", imgui.ImVec2(160, 35)) then
            DescriptionId = 1
        end
        imgui.PopStyleColor(1)

        imgui.PushStyleColor(imgui.Col.Button, titlebarBgColor)
        if imgui.Button("Информация\nдля хелперов", imgui.ImVec2(160, 35)) then
            DescriptionId = 2
        end
        imgui.PopStyleColor(1)

        imgui.PushStyleColor(imgui.Col.Button, titlebarBgColor)
        if imgui.Button("Настройки", imgui.ImVec2(160, 35)) then
            DescriptionId = 3
        end
        imgui.PopStyleColor(1)

        imgui.PushStyleColor(imgui.Col.Button, titlebarBgColor)
        if imgui.Button("Предложения\n  по скрипту", imgui.ImVec2(160, 35)) then
            DescriptionId = 4
        end
        imgui.PopStyleColor(1)

        imgui.PushStyleColor(imgui.Col.Button, titlebarBgColor)
        if imgui.Button("Обратная связь", imgui.ImVec2(160, 35)) then
            DescriptionId = 5
        end
        imgui.PopStyleColor(1)
        imgui.EndChild()
        imgui.SameLine()
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

            imgui.PushFont(fontsize)
            imgui.Text("Answers Helper")
            imgui.PopFont()

            imgui.Text('Количество ответов: ' .. answers_count)
            imgui.PushStyleColor(imgui.Col.Button, titlebarBgColor)
            if imgui.Button('Сбросить счётчик ответов') then
                answhelp_reset()
            end
            imgui.PopStyleColor(1)
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
        fontsize = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 30.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic()) -- Ð“ÑžÐ“Â¬Ð“ÒÐ“Â±Ð“Ð†Ð“Â® 30 Ð“Â«Ð“Ñ•Ð“ÐŽÐ“Â®Ð“Â© Ð“Â­Ð“Ñ–Ð“Â¦Ð“Â­Ð“Â»Ð“Â© Ð“Â°Ð“Â Ð“Â§Ð“Â¬Ð“ÒÐ“Â°
    end

    if fontsize_basic == nil then
        fontsize_basic = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 16.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
    end

    if fontsize_medium == nil then
        fontsize_medium = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 20.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
    end
end

function printChatMessage(message)
    if message == nil then
        print("Ошибка! Message = nil. От printChatMessage")
        return
    end
    sampAddChatMessage("{EE9611}" .. "[Trinity Helper] " .. cp1251:encode(message, "UTF-8"), 0xFF9900)
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

    loadAnswersCount()

    desc1 = readDescription("1")
    desc2 = readDescription("2")
    desc3 = readDescription("3")
    desc4 = readDescription("4")
    desc5 = readDescription("5")

    printChatMessage("Скрипт для хелперов Trinity GTA" .. " v" ..  thisScript().version .. " " .. " от Tosa | lugovojs" .. " был запущен. Активация - /trphelper.")

    imgui.Process = true

    while true do wait(0) 
        imgui.Process = show_main_window.v
        if  wasKeyPressed(VK_1) and isKeyDown(VK_MENU) then
            if last_id == nil then
                printChatMessage("Не найдено последного вопроса и его ID.")
            else
                sampSetChatInputText('/answ '..last_id..' ')
                sampSetChatInputEnabled(true)
            end
        end
    end
end

function sampev.onServerMessage(color, text)
    if text:match(cp1251:encode('Вопрос%sот%s.*%sID%s%d+:.*', 'UTF-8')) then
        last_id = text:match(cp1251:encode('Вопрос%sот%s.*%sID%s(%d+):.*', 'UTF-8'))
    end

    if text:match(cp1251:encode('От%sManny_Westfall%sдля%s.*:%s*', 'UTF-8')) then
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
    printChatMessage("Количество ваших ответов: " .. answers_count)
    file:close()
end

function answhelp_reset()
    file = io.open(resources_dir .. "answers.txt", "w")
    file:write("0")
    file:close()
    loadAnswersCount()
    printChatMessage("Счетчик ответов был обнулён.")
end

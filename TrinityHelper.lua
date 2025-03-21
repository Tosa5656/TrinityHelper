script_name("Trinity Helper")
script_author("Tosa | lugovojs.")
script_version("5.4")

require "lib.moonloader"
local dlstatus = require('moonloader').download_status
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
desc5 = {"", ""}

local fontsize_basic = nil
local fonsize_medium = nil
local fontsize = nil

actual_version = nil

nick_input_buffer = imgui.ImBuffer(256)
nick = ""

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
        if imgui.Button("Обновление", imgui.ImVec2(160, 35)) then
            DescriptionId = 4
        end
        imgui.PopStyleColor(1)

        imgui.PushStyleColor(imgui.Col.Button, titlebarBgColor)
        if imgui.Button("История обновлений", imgui.ImVec2(160, 35)) then
            DescriptionId = 5
        end
        imgui.PopStyleColor(1)

        imgui.PushStyleColor(imgui.Col.Button, titlebarBgColor)
        if imgui.Button("Предложения\n  по скрипту", imgui.ImVec2(160, 35)) then
            DescriptionId = 6
        end
        imgui.PopStyleColor(1)

        imgui.PushStyleColor(imgui.Col.Button, titlebarBgColor)
        if imgui.Button("Обратная связь", imgui.ImVec2(160, 35)) then
            DescriptionId = 7
        end
        imgui.PopStyleColor(1)

        imgui.EndChild()
        imgui.SameLine()
        imgui.BeginChild("##descriptionlist",  imgui.ImVec2(610, 565), true)
        
        if DescriptionId == 1 then
            imgui.PushFont(fontsize)
            imgui.Text("О скрипте")
            imgui.PopFont()
            
            imgui.PushFont(fontsize_basic)
            imgui.Text("Данный скрипт был написан специально для хелперов Trinity GTA. Пока что скрипт\nнаходиться на стадии активной разработки.\n")
            imgui.Text("В скрипте присутствует АвтоИД(ALT + 1), счётчик количества ваших ответов\n(чтобы увидеть количества ответов или сбросить их, откройте настройки),\nGUI интерфейс скрипта.\n")
            imgui.Text("В данный скрипт будут добавлены все основные функции проекта.\nСкрипт подходить для всех серверов Trinity(RP и RPG).")
            imgui.Text("Так как скрипт разрабатывается двумя людьми, он будет обновлятся,\nпо мере успеваемости.")
            imgui.PopFont()

            imgui.PushFont(fontsize_medium)
            imgui.Text("Интерфейс")
            imgui.PopFont()

            imgui.PushFont(fontsize_basic)
            imgui.Text("Кратко про интерфейс:\nСлева расположенно меню, где вы можете переключаться между разделами скрипта,\nа справа содержимое этих разделов.")
            imgui.Text("О скрипте - краткая информация про скрипт, и как им пользоваться.")
            imgui.Text("Информация для хелперов - команды и макросы для хелперов.")
            imgui.Text("Настройки - управление модулями скрипта.")
            imgui.Text("Обновление - обновление скрипта.")
            imgui.Text("Предложения по скрипту - информация о том, куда можно написать своё предложение по скрипту.")
            imgui.Text("Обратная связь - связь с создателями скрипта.")
            imgui.PopFont()
        end

        if DescriptionId == 2 then
            imgui.PushFont(fontsize)
            imgui.Text("Информация для хелперов")
            imgui.PopFont()
            
            imgui.PushFont(fontsize_basic)
            imgui.Text("В разделе приведены примеры нужных команд и макросов для хелперов.\n/answ [текст]- Ответить на вопрос игрока.\n/hc [текст] - Отправить сообщение в чат хелперов.\n/helpers - Список хелперов онлайн.\n")
            imgui.Text("Далее приведены макросы:\n/tf - Сообщение игроку о разделе FAQ на форуме.\n/tb - Сообщение игроку о теме 'Баги и грамматические ошибки'.\n/geo - Сообщение игроку о странах и городах на сервере.")
            imgui.Text("/grup - Сообщение игроку о подробностях в официальной группе ВК проекта.\n/sgrup - Сообщение игроку о подробностях в официальной группе ВК сервера.\n/art - Сообщение игроку о справочных статьях в /mm.")
            imgui.Text("/rpg - Сообщение игроку об отличиях RPG и RP серверов проекта.\n/don - Сообщение игроку с адресом страницы доната.\n/fad - Сообщение игроку о командах для подачи рекламы на радио.\n/bsp - Сообщение игроку с инструкцией по игре в баскетбол.")
            imgui.Text("/qp - Сообщение игроку об обмене квестпоинтов на игровой опыт.\n/rec - Сообщение игроку о способностях восстановления аккаунта.\n/chip - Сообщение игроку о фишках.\n/lch - Сообщение игроку о лаунчере Trinity GTA.")
            imgui.PopFont()
        end

        if DescriptionId == 3 then
            imgui.PushFont(fontsize)
            imgui.Text("Настройки")
            imgui.PopFont()

            imgui.PushStyleColor(imgui.Col.Button, titlebarBgColor)
            if imgui.Button('Сбросить счётчик ответов') then
                answhelp_reset()
            end
            imgui.PopStyleColor(1)
        end

        if DescriptionId == 4 then
            imgui.PushFont(fontsize)
            imgui.Text("Обновление")
            imgui.PopFont()

            imgui.PushFont(fontsize_basic)
            imgui.Text('Установленная версия скрипта: ' .. actual_version)
            imgui.PopFont()
            imgui.PushStyleColor(imgui.Col.Button, titlebarBgColor)
            if imgui.Button('Обновить', imgui.ImVec2(160, 35)) then
                update_updater()
                sampProcessChatInput('/trphelperupdate')
            end
            imgui.PopStyleColor(1)
        end

        if DescriptionId == 5 then
            imgui.PushFont(fontsize)
            imgui.Text("История обновлений")
            imgui.PopFont()

            imgui.PushFont(fontsize_basic)
            imgui.Text("5.3 - исправлен GUI некоторых вкладок, добавлена история обновлений.")
            imgui.Text("5.1-5.2 - полный переход на кодировку  UTF-8, переход на MimGUI, добавлены настро-\nйки, обновления, исправление работы менеджера обновлений, исправление крити-\nческой ошибки.")
            imgui.Text("4.x - исправление ошибок кодировки, рабочая система автообновления.")
            imgui.Text("3.x - первая открытая версия.")
            imgui.Text(" ")
            imgui.Text("Текущая версия скрипта: " .. actual_version .. " от 07.01.2025")
            imgui.PopFont()
        end

        if DescriptionId == 6 then
            imgui.PushFont(fontsize)
            imgui.Text("Предложения по скрипту")
            imgui.PopFont()
            
            imgui.PushFont(fontsize_basic)
            imgui.Text("В данном разделе вы можете связаться с нами и рассказать свою идею по улучшению\nили исправлению какой-либо системы в скрипте.\n\nVK - @heaviside666")
            imgui.PopFont()
        end

        if DescriptionId == 7 then
            imgui.PushFont(fontsize)
            imgui.Text("Контакты разработчиков")
            imgui.PopFont()
            
            imgui.PushFont(fontsize_basic)
            imgui.Text("В данном разделе представлены контакты разработчиков для обратной связи.")
            imgui.PushStyleColor(imgui.Col.Button, titlebarBgColor)
            if imgui.Button('VK', imgui.ImVec2(160, 35)) then
                os.execute('explorer https://vk.com/heaviside666')
            end

            if imgui.Button('GitHub', imgui.ImVec2(160, 35)) then
                os.execute('explorer https://github.com/Tosa5656/TrinityHelper')
            end
            imgui.PopStyleColor(1)
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

    version_file = io.open(resources_dir .. "version.txt")
    actual_version = version_file:read("*a")

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
    printChatMessage("Счетчик ответов был обнулён. ")
end

function update_updater()
    os.remove(getGameDirectory() .. "//moonloader//TrinityHelperUpdater.lua")
    downloadUrlToFile('https://raw.githubusercontent.com/Tosa5656/TrinityHelper/refs/heads/master/TrinityHelperUpdater.lua', getGameDirectory() .. "//moonloader//TrinityHelperUpdater.lua", function(id, status, p1, p2) end)
    printChatMessage("Менеджер обновлений был успешно обновлён. ")
end

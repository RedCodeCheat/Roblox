local RedCodeConsoleRunner = {}
local currentProcess = nil
local logFile = "rcc_console.log"

local function execute(cmd)
    if syn and syn.run then
        return syn.run(cmd, {}, getexecutordir())
    elseif fluxus and fluxus.execute then
        return fluxus.execute(cmd)
    else
        warn("Komut çalıştırma desteklenmiyor!")
        return false
    end
end

local function setupConsole()
    writefile(logFile, "") -- Log dosyasını sıfırla
    execute([[powershell -Command "Start-Process cmd.exe -ArgumentList '/k', 'title RedCodeConsole && mode con: cols=100 lines=30 && color 0A'" ]])
end

function RedCodeConsoleRunner.open()
    setupConsole()
    wait(1)
    print("RedCode Console başlatıldı! (v1.0)")
end

function RedCodeConsoleRunner.sendmsg(msg, color)
    local colorCodes = {
        red = "4E",
        yellow = "6E",
        white = "0F",
        blue = "3F"
    }
    
    execute([[powershell -Command "$ws = New-Object -ComObject WScript.Shell; $ws.SendKeys(']].. 
    "echo ["..os.date("%H:%M:%S").."] "..msg:gsub("'", "''").." && color "..(colorCodes[color] or "0F").."^&cls'" .. 
    [[')" ]])
end

function RedCodeConsoleRunner.runCommand(cmd)
    execute("cmd /c "..cmd)
end

function RedCodeConsoleRunner.runScript(script)
    if script:match(".bat$") then
        writefile("temp_script.bat", script)
        execute("start temp_script.bat")
    else
        warn("Sadece .bat scriptleri destekleniyor!")
    end
end

function RedCodeConsoleRunner.loadRConsole()
    local originalPrint = print
    print = function(...)
        local args = {...}
        local msg = table.concat(args, " ")
        originalPrint(msg)
        RedCodeConsoleRunner.sendmsg(msg, "white")
    end

    -- Hata yakalama
    local originalError = error
    error = function(msg, level)
        RedCodeConsoleRunner.sendmsg("[HATA] "..msg, "red")
        originalError(msg, level)
    end

    -- Uyarılar
    local originalWarn = warn
    warn = function(msg)
        RedCodeConsoleRunner.sendmsg("[UYARI] "..msg, "yellow")
        originalWarn(msg)
    end
end

function RedCodeConsoleRunner.close()
    execute("taskkill /f /im cmd.exe")
    delfile(logFile)
end

return RedCodeConsoleRunner

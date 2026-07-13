-- Скрипт автоматической очистки декалей каждые 5 секунд
-- Оптимизирован для минимальной нагрузки на ПК

local CLEAR_INTERVAL = 5.0 -- Интервал в секундах

-- Функция очистки декалей
local function clear_decals()
    client.exec("r_cleardecals")
end

-- Запускаем таймер, который будет вызывать очистку каждые 5 секунд
client.set_timer(CLEAR_INTERVAL, function()
    clear_decals()
    -- Возвращаем true, чтобы таймер продолжал работать бесконечно
    return true
end)

-- Выводим сообщение о загрузке
client.log("FPS Boost Cleaner loaded: Decals will be cleared every " .. CLEAR_INTERVAL .. " seconds.\n")

local toggle_alacritty = function()
    local appName = "Alacritty"
    local app = hs.application.get(appName)

    if app == nil or app:isHidden() or not(app:isFrontmost()) then
        hs.application.launchOrFocus(appName)
    else
        app:hide()
    end
end
-- 「Ctrl+t」のショートカットで表示／非表示を切り替える場合の設定
hs.hotkey.bind({"ctrl"}, "t", toggle_alacritty)


hs.hotkey.bind({ "ctrl", "alt" }, ".", function()
    local window = hs.window.frontmostWindow()

    hs.eventtap.keyStroke({}, "space", 0)

    hs.timer.doAfter(0.04, function()
        hs.eventtap.keyStroke({}, "space", 0)
    end)
end)

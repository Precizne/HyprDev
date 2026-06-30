-- ##################################################
-- Debug Configuration (Run in Nested Setup Only!!!)
-- ##################################################

-- Configuration
hl.config({
    ------------------------------------------------
    env = {
        "XCURSOR_SIZE,24",
        "HYPRCURSOR_SIZE,24"
    },

    ------------------------------------------------
    input = {
        follow_mouse = 2
    },

    ------------------------------------------------
    cursor = {
        no_warps = true
    },

    ------------------------------------------------
    general = {
        layout = "scrolling",
        border_size = 4,
        col = {
            active_border = {
                colors = {
                    "rgba(64DDE8ff)",
                    "rgba(C166FFff)",
                },
                angle = 45
            },
            inactive_border = "rgba(293042aa)"
        }
    },

    ------------------------------------------------
    scrolling = {
        wrap_focus = false,
        wrap_swapcol = false
    }
})

-- Monitors
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto"
})

-- Window Rules
hl.window_rule({ name = "browser_width", match = { class = "^(firefox|chrome|Brave-browser|zen)$" }, scrolling_width = 1 })
hl.window_rule({ name = "special_width", match = { class = "^(notion|obs)$" }, scrolling_width = 1 })
hl.window_rule({ name = "term_width", match = { class = "^(foot|kitty|Alacritty)$" }, scrolling_width = 0.5 })

-- Keybinds
hl.bind("ALT + T", hl.dsp.exec_cmd("kitty"))
hl.bind("ALT + Q", hl.dsp.window.close())
hl.bind("ALT + SHIFT + Q", hl.dsp.exit())

-- Focus
for i = 1, 4 do
    local arrowkey = { "Left", "Right", "Up", "Down" }
    local focusdir = { "l", "r", "u", "d" }
    hl.bind("ALT + " .. arrowkey[i], hl.dsp.layout("focus " .. focusdir[i]),
        {
            description = "Window: Focus " .. arrowkey[i],
            repeating = true
        }
    )
end

-- Swap columns
for i = 1, 2 do
    local arrowkey = { "Left", "Right" }
    local focusdir = { "l", "r" }
    hl.bind("ALT + SHIFT + " .. arrowkey[i], hl.dsp.layout("swapcol " .. focusdir[i]),
        {
            description = "Window: Swap colums " .. arrowkey[i],
            repeating = true
        }
    )
end

-- Move columns to workspace
for i = 1, 2 do
    local arrowkey = { "Up", "Down" }
    local focusdir = { "-1", "+1" }
    hl.bind("ALT + SHIFT + " .. arrowkey[i], hl.dsp.layout("move_col_to_ws r" .. focusdir[i]),
        {
            description = "Window: Move column to workspace " .. arrowkey[i],
            repeating = true
        }
    )
end

-- Consume or expel
for i = 1, 2 do
    local arrowkey = { "BracketLeft", "BracketRight" }
    local focusdir = { "prev", "next" }
    hl.bind("ALT + " .. arrowkey[i], hl.dsp.layout("consume_or_expel " .. focusdir[i]),
        {
            description = "Window: Consume or expel " .. arrowkey[i],
            repeating = true
        }
    )
end

-- Consume in or expel out
hl.bind("ALT + Y", hl.dsp.layout("consume"), { repeating = true })
hl.bind("ALT + U", hl.dsp.layout("expel"), { repeating = true })

-- Column resize
hl.bind("ALT + Semicolon", hl.dsp.layout("colresize -0.1"), { repeating = true })
hl.bind("ALT + Apostrophe", hl.dsp.layout("colresize +0.1"), { repeating = true })
hl.bind("ALT + O", hl.dsp.layout("colresize -conf"), { repeating = true })
hl.bind("ALT + P", hl.dsp.layout("colresize +conf"), { repeating = true })

-- Workspace switching
for i = 1, 10 do
    hl.bind("ALT + " .. (i % 10), function()
        hl.dispatch(hl.dsp.focus({ workspace = i }))
    end, { description = "Workspace: Focus " .. i })
end

for i = 1, 10 do
    local numberkey = { 10, 11, 12, 13, 14, 15, 16, 17, 18, 19 }
    hl.bind("ALT + code:" .. numberkey[i], function()
        hl.dispatch(hl.dsp.focus({ workspace = i }))
    end)
end

for i = 1, 10 do
    local numpadkey = { 87, 88, 89, 83, 84, 85, 79, 80, 81, 90 }
    hl.bind("ALT + code:" .. numpadkey[i], function()
        hl.dispatch(hl.dsp.focus({ workspace = i }))
    end)
end

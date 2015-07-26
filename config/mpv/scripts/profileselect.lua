local msg = require 'mp.msg'

if mp.get_property_bool("option-info/vo/set-from-commandline") == true then
    return
end


local hdtv = "HDTV"
local hdbd = "BD"
local hs = "HorribleSubs"
local sd = "SD"
local vo = {}
local vo_opts = {}
local options = {}

function determine_level()
    -- default level
    local level = hdtv
    
    -- getting video info
    local name = mp.get_property_osd("filename")
    local width = mp.get_property("video-params/w", 1280)
    local height = mp.get_property_number("video-params/h", 720)

    print("current filename" .. name)
    if string.find (name, 'HorribleSubs') then
        msg.log("info", "Crunchyroll encoding detected, switching to deband_high.")
        level = hs
    elseif string.find (name, 'BD') then
        msg.log("info", "Bluray sourced file detected (or checksum containing BD)")
        level = hdbd
    elseif string.find (name, '720p') or string.find (name, '1080p') then
        msg.log("info", "Regular file detected")
        level = hdtv
    end
    
    -- call an external bash function determining if this is a desktop or mobile computer
    --loc = {}
    --loc.args = {"bash", "-c", 'source "$HOME"/local/shell/location-detection && is-desktop'}
    --loc_ret = utils.subprocess(loc)

    -- something went wrong
    --if loc_ret.error then
    --    return level
    --end

    -- desktop -> hq
    --if loc_ret.status == 0 then
    --    level = hq
    -- mobile  -> mq/lq
    --elseif loc_ret.status == 1 then
    --    level = mq
        -- go down to lq when we are on battery
    --    bat = {}
    --    bat.args = {"/usr/bin/pmset", "-g", "ac"}
    --    bat_ret = utils.subprocess(bat)
    --    if bat_ret.stdout == "No adapter attached.\n" then
    --        level = lq
    --    end
    --else
    --    print("unable to determine location, using default level: " .. level)
    --end

    return level
end


function vo_property_string(level)
    -- use `vo` and `vo_opts` to build a `vo=key1=val1:key2=val2:key3=val3` string
    local result = {}
    for k, v in pairs(vo_opts[level]) do
        if v and v ~= "" then
            table.insert(result, k .. "=" ..v)
        else
            table.insert(result, k)
        end
    end
    return vo[level] .. (next(result) == nil and "" or (":" .. table.concat(result, ":")))
end


-- Define VO sub-options for different levels.

vo = {
    [hdtv] = "opengl-hq",
    [hdbd] = "opengl-hq",
    [hs] = "opengl-hq",
    [sd] = "opengl-hq",
}

vo_opts[hdtv] = {
    ["scale"]  = "ewa_lanczossharp",
    ["cscale"] = "ewa_lanczossoft",
    ["dscale"] = "mitchell",
    ["tscale"] = "oversample",
    ["scale-antiring"]  = "0.8",
    ["cscale-antiring"] = "0.9",

    ["dither-depth"]        = "auto",
    ["target-prim"]         = "bt.709",
    --["gamma"]               = "0.9338",
    ["scaler-resizes-only"] = "",
    ["sigmoid-upscaling"]   = "",
    ["interpolation"]       = "",

    ["fancy-downscaling"] = "",
    ["source-shader"]     = "~~/shaders/deband.glsl",
    ["temporal-dither"]   = "",
    ["pbo"] = "",
}

vo_opts[hdbd] = {
    ["scale"]  = "ewa_lanczossharp",
    ["cscale"] = "ewa_lanczossoft",
    ["dscale"] = "mitchell",
    ["tscale"] = "oversample",
    ["scale-antiring"]  = "0.8",
    ["cscale-antiring"] = "0.9",

    ["dither-depth"]        = "auto",
    ["target-prim"]         = "bt.709",
    --["gamma"]               = "0.9338",
    ["scaler-resizes-only"] = "",
    ["sigmoid-upscaling"]   = "",
    ["interpolation"]       = "",

    ["fancy-downscaling"] = "",
    ["source-shader"]     = "~~/shaders/deband.glsl",
    ["temporal-dither"]   = "",
    ["pbo"] = "",
}

vo_opts[hs] = {
    ["scale"]  = "ewa_lanczossharp",
    ["cscale"] = "ewa_lanczossoft",
    ["dscale"] = "mitchell",
    ["tscale"] = "oversample",
    ["scale-antiring"]  = "0.8",
    ["cscale-antiring"] = "0.9",

    ["dither-depth"]        = "auto",
    ["target-prim"]         = "bt.709",
    ["scaler-resizes-only"] = "",
    ["sigmoid-upscaling"]   = "",
    ["interpolation"]       = "",

    ["fancy-downscaling"] = "",
    ["source-shader"]     = "~~/shaders/deband_high.glsl",
    --["icc-cache-dir"]     = "~~/icc-cache",
    --["3dlut-size"]        = "256x256x256",
    ["temporal-dither"]   = "",
    ["pbo"] = "",
}

vo_opts[sd] = {
    ["scale"]  = "lanczos",
    ["dscale"] = "mitchell",
    ["tscale"] = "oversample",
    ["scale-radius"] = "2",

    ["dither-depth"]        = "auto",
    ["target-prim"]         = "bt.709",
    --["gamma"]               = "0.9338",
    ["scaler-resizes-only"] = "",
    ["sigmoid-upscaling"]   = "",
    ["interpolation"]       = "",
}


-- Define mpv options for different levels. 
-- Option names are given as strings, values as functions without parameters.

options[hdtv] = {
    ["options/vo"] = function () return vo_property_string(hdtv) end,
}

options[hdbd] = {
    ["options/vo"] = function () return vo_property_string(hdbd) end,
}

options[hs] = {
    ["options/vo"] = function () return vo_property_string(hs) end,
}

options[sd] = {
    ["options/vo"] = function () return vo_property_string(sd) end,
    ["options/hwdec"] = function () return "auto" end,
}

function profile_select()
--     local name = mp.get_property_osd("filename")
--     local width = mp.get_property("video-params/w")
--     local height = mp.get_property_number("height")
--     
--     msg.log("info", name)
--     msg.log("info", width)
--     if string.find (name, 'HorribleSubs') then
--         -- set deband high here
--         msg.log("info", "Crunchyroll encoding detected")
--     elseif height < 720 then
--         -- set deband normal here
--         msg.log("info", "height is < 720p")
--     end
    level = determine_level()
    local err_occ = false
    for k, v in pairs(options[level]) do
        local val = v()
        success, err = mp.set_property(k, val)
        err_occ = err_occ or not (err_occ or success)
        if success then
            print("Set '" .. k .. "' to '" .. val .. "'")
        else
            print("Failed to set '" .. k .. "' to '" .. val .. "'")
            print(err)
        end
    end
end

mp.register_event("start-file", profile_select)

function print_status(name, value)
    if not value then
        return
    end

    local duration = 2
    if err_occ then
        print("Error setting level: " .. level)
        mp.osd_message("Error setting level: " .. level, duration)
    else
        print("Active level: " .. level)
        mp.osd_message("Profile: " .. level, duration)
    end
    mp.unobserve_property(print_status)
end

mp.observe_property("vo-configured", "bool", print_status)
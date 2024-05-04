--[[
    special thanks LUCHARE (https://www.blast.hk/threads/167290/)
]]

script_name("Off Radar")
script_author("cuzavr & MrLomaster")
script_description("Выключает/Включает радар при нажатии на M") -- Turns off/on the radar when you press M

-- Coding
local encoding = require 'encoding'
encoding.default = 'CP1251'

-- Library
local vkeys = require 'vkeys' 
local ffi = require 'ffi'
local mem = require 'memory'

-- Other
local isRadarEnabled = true
local nop = 0x90
local samp = getModuleHandle('samp.dll')
local addr = { -- All versions SAMP 0.3.7
    [0x31DF13] = {0x9D31A,0x9D329}, -- R1
    [0x3195DD] = {0x9D3CA,0x9D3D9}, -- R2
    [0xCC4D0] = {0xA168A,0xA1699}, -- R3
    [0xCBCB0] = {0xA1DCA,0xA1DD9}, -- R4
    [0xCBC90] = {0xA1DBA,0xA1DC9}, -- R5
    [0xFDB60] = {0xA1BDA,0xA1BE9}, -- DL
}

function main()
    local nt_header = samp + ffi.cast("long*", samp + 60)[0]
    local entry_point_addr = ffi.cast("unsigned int*", nt_header + 40)[0]
    while true do
        wait(0)
        if isKeyJustPressed(vkeys.VK_M) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
            if addr[entry_point_addr] ~= nil then
                mem.fill(samp + addr[entry_point_addr][1], nop, 12, true) -- Radar
                mem.fill(samp + addr[entry_point_addr][2], nop, 12, true) -- Hud
            end
		    isRadarEnabled = not isRadarEnabled
            displayRadar(isRadarEnabled)
        end
    end
end
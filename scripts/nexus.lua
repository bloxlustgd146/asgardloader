ffi.cdef("    typedef struct {\n        char  pad_0000[20];\n        int m_nOrder;\n        int m_nSequence;\n        float m_flPrevCycle;\n        float m_flWeight;\n        float m_flWeightDeltaRate;\n        float m_flPlaybackRate;\n        float m_flCycle;\n        void *m_pOwner;\n        char  pad_0038[4];\n    } CAnimationLayer;\n")
math.randomseed(common.get_unixtime())

local v1 = (function()
	ffi.cdef("        typedef struct {\n            long long QuadPart;\n        } LARGE_INTEGER;\n        int QueryPerformanceCounter(LARGE_INTEGER* lpPerformanceCount);\n        int QueryPerformanceFrequency(LARGE_INTEGER* lpFrequency);\n        uint64_t GetTickCount64(void);\n        uint32_t timeGetDevCaps(void* ptc, uint32_t cbtc);\n    ")

	local v383 = ffi.new("LARGE_INTEGER")
	local v384 = ffi.new("LARGE_INTEGER")

	if ffi.C.QueryPerformanceFrequency(v383) ~= 1 then
		return function()
			return ffi.C.GetTickCount64() / 1000
		end
	end

	local num = tonumber(v383.QuadPart)

	return function()
		-- upvalues: v384 (copy), num (copy)
		if ffi.C.QueryPerformanceCounter(v384) ~= 1 then
			return ffi.C.GetTickCount64() / 1000
		end

		return tonumber(v384.QuadPart) / num
	end
end)()
local smoothy, pui, floor, v21, v22, v23, t2, v28, u37, t9, t18, t19, t22, u87, v89, t27, t50, t58, settings, v194, v195, n17, u200, t59, t64, t67, t68, t72, t73, t74, t75, t76, t77, t78, t79, t80

do
	local normalize_yaw, abs, clamp, t5, v33

	do
		local v24, t8, t15

		do
			local events = require("neverlose/events")
			local t3, n15, v97, t38, v142, v143, t39, t40, t41, t42, t45, t46, t47, t48

			do
				local v98, t29

				do
					local clipboard = require("neverlose/clipboard")

					smoothy = require("neverlose/smoothy")

					local t23, v93, TABS, v104

					do
						local base64 = require("neverlose/base64")

						pui = require("neverlose/pui")

						do
							local _ = math.random
						end

						normalize_yaw = math.normalize_yaw
						abs = math.abs

						do
							local _ = math.ceil
						end

						do
							local _ = math.cos
						end

						floor = math.floor

						do
							local _ = math.fmod
						end

						do
							local _ = math.max
						end

						do
							local _ = math.min
						end

						do
							local _ = math.rad
						end

						do
							local _ = math.sin
						end

						do
							local _ = math.sqrt
						end

						clamp = math.clamp

						do
							local concat = table.concat

							function math.round(p1)
								return p1 and math.floor(p1 + 0.5) or 0
							end
							function v21(p2, p3, p4)
								return p2 + (p3 - p2) * p4
							end
							function v22(p5, p6)
								for _, v in ipairs(p5) do
									if v == p6 then
										return true
									end
								end

								return false
							end
							function v23(p7, p8, p9, p10)
								-- upvalues: concat (copy)
								if p7 and p7 ~= "" then
									local t1 = {}
									local v408 = string.len(p7) > 1 and 1 / (string.len(p7) - 1) or 1

									for match in p7:gmatch(".[\128-\191]*") do
										local v410 = p8 % 2

										if v410 > 1 then
											local v411 = 2 - v410

											if v411 then
												v410 = v411
											end
										end

										local v412 = p9.r + (p10.r - p9.r) * v410
										local v413 = p9.g + (p10.g - p9.g) * v410
										local v414 = p9.b + (p10.b - p9.b) * v410
										local v415 = p9.a + (p10.a - p9.a) * v410

										t1[#t1 + 1] = "\a" .. color(v412, v413, v414, v415):to_hex() .. match
										p8 = p8 + v408
									end

									return concat(t1)
								end

								return ""
							end
						end

						function v24(p11)
							return (p11:lower():gsub("\a%x%x%x%x%x%x%x%x", ""):gsub("\a{[^}]+}", ""):gsub("\a", ""):gsub("\t", ""):gsub("[\240-\244][\128-\191][\128-\191][\128-\191]", ""):gsub("[\224-\239][\128-\191][\128-\191]", ""):gsub("[\192-\223][\128-\191]", ""):gsub("default%s*", ""):gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1"))
						end

						t2 = {
							icon = "atom",
							name = "nexus",
							sidebar_name = "Nexus",
							branch = "release"
						}
						t3 = {
							[1] = "Default",
							[2] = "Standing",
							[3] = "Running",
							[4] = "Slowwalking",
							[5] = "Ducking",
							[6] = "Sneaking",
							[7] = "In Air",
							[8] = "In Air & Crouching"
						};
						({}).player_state = {
							[1] = "Default",
							[2] = "Standing",
							[3] = "Running",
							[4] = "Slowwalking",
							[5] = "Ducking",
							[6] = "Sneaking",
							[7] = "In Air",
							[8] = "In Air & Crouching"
						}

						do
							local t4 = {
								FL_ONGROUND = bit.lshift(1, 0),
								FL_FROZEN = bit.lshift(1, 5)
							}

							v28 = render.screen_size()
							t5 = {}

							do
								local s1 = "ui/beepclear.wav"
								local s2 = "resource/warning.wav"
								local playvol = cvar.playvol

								function t5.success(...)
									-- upvalues: playvol (copy), s1 (copy)
									playvol:call(s1, 1)
								end
								function t5.failure(...)
									-- upvalues: playvol (copy), s2 (copy)
									playvol:call(s2, 1)
								end
								function t5.click()
									-- upvalues: playvol (copy)
									playvol:call(string.format("ui\\csgo_ui_contract_type%d", math.random(1, 10)), 1)
								end
							end

							function v33(p12, p13, p14)
								-- upvalues: pui (copy)
								pui.sidebar("##nexus_notification", pui.string(p12))
								common.add_notify(pui.string(p13), pui.string(p14))
							end

							do
								local t6 = {
									map = {},
									performance = {},
									setup = {}
								}
								local t7 = {
									set = function(p15, p16)
										-- upvalues: t6 (copy)
										if not t6.setup[p15.name] then
											t6.setup[p15.name] = {}
										end

										if p15.handlers[p16] then
											return false
										end

										table.insert(t6.setup[p15.name], p16)
										p15.handlers[p16] = p16

										return true
									end,
									unset = function(p17, p18)
										if not p17.handlers[p18] then
											return false
										end

										p17.handlers[p18] = nil

										return true
									end,
									call = function(p19, ...)
										-- upvalues: events (copy)
										local v427 = events[p19.name]

										if v427 then
											v427:call(...)
										end
									end
								}

								local function v36(p20, p21)
									-- upvalues: events (copy), t6 (copy), v1 (copy)
									if type(p20) == "string" then
										events[p20](function(...)
											-- upvalues: p20 (copy), t6 (copy), p21 (copy), v1 (copy)
											if not EXPIRED or (not (TRIAL_REMAINING <= 0) or p20 == "shutdown") then
												t6.performance[p20] = {}
												xpcall(function(...)
													-- upvalues: p21 (copy), v1 (copy), t6 (copy), p20 (copy)
													for _, v in pairs(p21) do
														local v1361 = v1()

														v(...)
														t6.performance[p20][v] = (v1() - v1361) * 1000
													end
												end, function(err)
													-- upvalues: p20 (copy)
													print(string.format("[%s] Error: %s", p20, err))
												end, ...)

												return
											end
										end)
									end
								end

								u37 = events

								if false then
									u37 = setmetatable({}, {
										__index = function(_, p23)
											-- upvalues: t6 (copy), t7 (copy), v36 (copy)
											local v432 = t6.map[p23]

											if not v432 then
												print(string.format("Registering new event: %s", p23))
												v432 = setmetatable({
													handlers = {},
													name = p23
												}, {
													__index = t7,
													__call = function(p24, p25, p26)
														if p26 == nil then
															p26 = true
														end

														p24[p26 and "set" or "unset"](p24, p25)
													end
												})
												t6.map[p23] = v432
												v36(p23, v432.handlers)
											end

											return v432
										end
									})

									local n1 = 3
									local n2 = 16

									events.render(function()
										-- upvalues: t6 (copy), n1 (copy), n2 (copy)
										local v433 = render.screen_size()
										local v434 = vector(5, v433.y * 0.25)

										for k, v in pairs(t6.performance) do
											render.text(n1, v434, color(255, 255, 255), nil, k)
											v434.y = v434.y + n2

											for i, v2 in ipairs(t6.setup[k] or {}) do
												local v439 = v[v2] or 0
												local v440 = string.format("  [%d]: %.3fms", i, v439)
												local v441 = v439 > 1 and color(255, 100, 100) or color(255, 255, 255)

												render.text(n1, v434, v441, nil, v440)
												v434.y = v434.y + n2
											end

											v434.y = v434.y + 8
										end
									end)
								end
							end

							t8 = {
								list = {}
							}
							t8.__index = t8

							function t8.new(p27, p28)
								-- upvalues: t8 (copy), smoothy (copy)
								if not p28 then
								end

								if t8.list[p27] == nil then
									t8.list[p27] = smoothy.new(0)
								end

								return setmetatable({
									name = p27
								}, t8)
							end
							function t8.update(p29, p30, p31)
								-- upvalues: t8 (copy)
								local v447 = t8.list[p29.name]

								v447:update(p30, p31)

								return v447
							end
							function t8.clear(p32)
								-- upvalues: t8 (copy)
								for k, _ in pairs(t8.list) do
									if k:find(p32) then
										t8.list[k] = nil
									end
								end
							end

							t9 = {}

							do
								local t10 = {}
								local u43 = nil
								local u44 = nil
								local v45 = pui.create("##WINDOWS")

								v45:visibility(false)

								local v46 = smoothy.new(0)

								local function v47(...)
									local ok, result = pcall(json.parse, ...)

									if not ok then
										return nil
									end

									return result
								end
								local function v48(...)
									return json.stringify(...)
								end
								local function v49(p33, p34, p35)
									return p33.x >= p34.x and (p33.x <= p34.x + p35.x and (p33.y >= p34.y and not (p33.y > p34.y + p35.y)))
								end
								local function v50(p36, p37, p38)
									-- upvalues: clamp (copy)
									return vector(clamp(p36.x, p37.x, p38.x), clamp(p36.y, p37.y, p38.y))
								end

								local t11 = {
									pos = vector(),
									prev_pos = vector(),
									delta = vector(),
									down = false,
									clicked = false,
									down_duration = 0
								}

								function t11.update()
									-- upvalues: t11 (copy)
									local v459 = ui.get_mouse_position()
									local v460 = common.is_button_down(1)

									t11.prev_pos = t11.pos
									t11.pos = v459
									t11.delta = t11.pos - t11.prev_pos
									t11.down = v460
									t11.clicked = v460 and not (t11.down_duration >= 0)

									local v461 = t11
									local g462 = nil
									local g464 = nil
									local n3 = nil

									repeat
										if g462 or not v460 then
											g462 = false
											n3 = -1
											g464 = true
										end

										if g464 then
											break
										end

										if not (t11.down_duration < 0) then
											n3 = t11.down_duration + 1

											if not n3 then
												g462 = true
											end
										else
											n3 = 0
										end
									until not g462

									g464 = false
									v461.down_duration = n3
								end

								local t13 = {
									get_pos = function(p39, p40)
										-- upvalues: v47 (copy)
										local v467 = v47(p39.item:get())

										if v467 then
											if not p40 then
												return vector(v467.x, v467.y)
											end

											return v467[p40]
										end

										return vector()
									end,
									set_pos = function(p41, p42, p43)
										-- upvalues: v48 (copy)
										if type(p42) ~= "number" then
											p41.pos = p42
											p41.item:set(v48({
												x = p41.pos.x,
												y = p41.pos.y
											}))
										else
											if p43 ~= "x" then
												if p43 == "y" then
													p41.pos.y = p42
												end
											else
												p41.pos.x = p42
											end

											p41.item:set(v48({
												x = p41.pos.x,
												y = p41.pos.y
											}))
										end

										return p41
									end,
									set_size = function(p44, p45, p46)
										if type(p45) ~= "number" then
											p44.size = p45
										elseif p46 ~= "x" then
											if p46 == "y" then
												p44.size.y = p45
											end
										else
											p44.size.x = p45
										end

										return p44
									end,
									set_min = function(p47, p48)
										p47.min = p48

										return p47
									end,
									set_max = function(p49, p50)
										p49.max = p50

										return p49
									end,
									set_rules = function(p51, p52)
										p51.rules = p52

										return p51
									end,
									update = function(p53, p54)
										-- upvalues: v47 (copy), v49 (copy), t11 (copy), u44 (ref), u43 (ref), smoothy (copy), v28 (copy), v50 (copy), v48 (copy)
										if not p54 then
											if p53.is_active then
												p53.is_hovered = v49(t11.pos, p53.pos, p53.size)
												p53.in_dragging = false

												if p53.is_hovered then
													u44 = p53
												end

												if p53.is_hovered and t11.clicked then
													u43 = p53
													p53.offset = p53.pos - t11.pos
												end

												local v482 = p53.offset and t11.pos + p53.offset or p53.pos
												local t12 = {}
												local v484 = p53.pos + p53.size * 0.5
												local v485 = v482 + p53.size * 0.5
												local v486 = common.is_button_down(162)

												for i, v in ipairs(p53.rules) do
													local pos = v.pos
													local end_pos = v.end_pos
													local horizontal = v.horizontal
													local v492 = p53.animations[i] or (function()
														-- upvalues: p53 (copy), i (copy), smoothy (copy)
														p53.animations[i] = smoothy.new(0)

														return p53.animations[i]
													end)()
													local v493 = horizontal and "x" or "y"
													local v494 = math.abs(v485[v493] - pos[v493])

													if p53 == u43 and not v486 and v494 < 8 then
														t12[v493] = pos[v493] - p53.size[v493] * 0.5
													end

													local v495 = math.abs(v484[v493] - pos[v493])
													local n4

													if p53 ~= u43 or v486 then
														n4 = 0
													else
														n4 = v495 < 10 and 120 or 60
													end

													local v497 = v492(0.05, n4)
													local v498 = horizontal and vector(pos.x, end_pos and pos.y or 0) or vector(end_pos and pos.x or 0, pos.y)
													local v499 = horizontal and vector(pos.x + 1, end_pos and end_pos.y or v28.y) or vector(end_pos and end_pos.x or v28.x, pos.y + 1)

													render.rect(v498, v499, color(255, v497))
												end

												if p53 == u43 then
													local v500 = vector(t12.x or v482.x, t12.y or v482.y)
													local min = p53.min
													local max = p53.max

													if p53.is_centered then
														min = p53.min - p53.size * 0.5
														max = p53.max - p53.size * 0.5
													end

													local v503 = v50(min, vector(0, 0), v28 - p53.size)
													local v504 = v50(max, vector(0, 0), v28 - p53.size)
													local v505 = v50(v500, v503, v504)

													if p53.on_dragging then
														p53:on_dragging()
													end

													p53.in_dragging = true
													p53:set_pos(v505)
												end

												p53.item:set(v48({
													x = p53.pos.x,
													y = p53.pos.y
												}))

												return p53
											end

											return
										end

										local v506 = v47(p53.item:get())

										if v506 then
											if v506.x then
												p53:set_pos(v506.x, "x")
											end

											if v506.y then
												p53:set_pos(v506.y, "y")
											end
										end

										return p53
									end,
									render = function(p55)
										-- upvalues: u43 (ref), v28 (copy)
										local pos = p55.pos
										local hover = p55.animations.hover
										local n5

										if not p55.is_active then
											n5 = 0
										elseif not p55.is_hovered then
											n5 = 0
										else
											n5 = common.is_button_down(1) and 0.4 or 0.2
										end

										local v511 = hover(0.05, n5) * ui.get_alpha()

										if v511 > 0 then
											render.rect(pos - 1, pos + p55.size + 1, color(255, 170 * v511), 4)
										end

										local v512 = p55.animations.border(0.05, p55.is_active and (p55.render_border and p55 == u43) and 1 or 0) * ui.get_alpha()

										if v512 > 0 then
											render.rect_outline(p55.min, p55.max + p55.size, color(255, 127 * v512), 1, 4)
										end

										if not (p55.pos < vector(0, 0)) then
											if p55.pos > v28 - p55.size then
												p55:set_pos(v28 - p55.size)
											end
										else
											p55:set_pos(vector(0, 0))
										end

										if p55.render_callback then
											p55:render_callback()
										end
									end
								}

								t13.__index = t13
								t9.items = {}
								t9.list = t10

								function t9.new(p56)
									-- upvalues: v45 (copy), v28 (copy), smoothy (copy), t9 (copy), t13 (copy), t10 (copy)
									local t14 = {
										render_border = false,
										is_hovered = false,
										is_centered = true,
										is_dragging = false,
										is_active = true,
										name = p56,
										item = v45:value(p56, ""),
										offset = vector(0, 0),
										pos = vector(0, 0),
										size = vector(0, 0),
										min = vector(0, 0),
										max = vector(v28.x, v28.y),
										rules = {},
										animations = {
											rulers = {},
											border = smoothy.new(0),
											hover = smoothy.new(0)
										}
									}

									table.insert(t9.items, t14.item)
									setmetatable(t14, t13)
									table.insert(t10, t14)

									return t14
								end

								events.render(function()
									-- upvalues: t11 (copy), u44 (ref), u43 (ref), v46 (copy), t9 (copy), v28 (copy), t10 (copy)
									t11.update()
									u44 = nil

									if not t11.down then
										if u43 and u43.on_release then
											u43:on_release()
										end

										u43 = nil
									end

									v46:update(0.075, u43 ~= nil and t9.background and 1 or 0)

									if v46.value > 0 then
										render.rect(vector(), v28, color(0, 75 * v46.value))
										render.blur(vector(), v28, 1, v46.value)
									end

									for i = #t10, 1, -1 do
										local v516 = t10[i]

										if ui.get_alpha() > 0 then
											v516:update()
										end

										v516:render()
									end
								end)
								u37.mouse_input(function(_)
									-- upvalues: u44 (ref), u43 (ref)
									if not u44 and not u43 then
										return
									end

									return ui.get_alpha() == 0
								end)
							end

							t15 = {}

							local function v54(p58)
								local v519 = entity.get_player_resource()

								if v519 ~= nil then
									vector()
									vector()

									local m_bombsiteCenterA = v519.m_bombsiteCenterA
									local m_bombsiteCenterB = v519.m_bombsiteCenterB

									return p58:dist(m_bombsiteCenterA) < p58:dist(m_bombsiteCenterB) and "A" or "B"
								end

								return "?"
							end

							local n6 = 450.7
							local n7 = 75.68
							local n8 = 789.2

							local function v58(p59, p60)
								-- upvalues: n7 (copy), n8 (copy), n6 (copy)
								local v524 = (p59 - n7) / n8
								local v525 = n6 * math.exp(-v524 * v524)

								if p60 > 0 then
									local n9 = 0.5
									local v527 = v525 * 0.5

									if p60 < (v525 - v527) * n9 then
										v527 = v525 - p60 * (1 / n9)
									end

									v525 = v527
								end

								return math.max(math.floor(v525 + 0.5), 0)
							end

							function t15.get_damage(_, p62, p63)
								-- upvalues: v58 (copy)
								if p62 ~= nil and p63 ~= nil then
									local m_ArmorValue = p62.m_ArmorValue
									local v532 = p62:get_eye_position()
									local v533 = p63:get_origin():dist(v532)

									return v58(v533, m_ArmorValue)
								end

								return -1
							end

							local t16 = {
								time = 0,
								remaining = 0,
								site = "?"
							}

							u37.net_update_start:set(function()
								-- upvalues: t16 (copy), v54 (copy)
								local v534 = t16
								local v535 = entity.get_entities("CC4", true)[1]

								if v535 ~= nil and v535.m_bStartedArming ~= false then
									v534.time = v535.m_fArmedTime
									v534.remaining = (v534.time - globals.curtime) / 3
									v534.site = v54(v535:get_origin())

									return
								end

								v534.time = 0
								v534.remaining = 0
								v534.site = "?"
							end)

							local t17 = {
								site = "?",
								time = 0,
								defuser = nil,
								defuse_length = 0,
								defuse_countdown = 0,
								defuse_remaining = 0
							}

							u37.net_update_start:set(function()
								-- upvalues: t17 (copy), v54 (copy)
								local v536 = t17
								local v537 = entity.get_entities("CPlantedC4", true)[1]

								v536.site = "?"
								v536.time = 0
								v536.defuse_remaining = 0

								if v537 ~= nil and v537.m_bBombTicking ~= false then
									v536.site = v54(v537:get_origin())
									v536.time = v537.m_flC4Blow
									v536.is_defused = v537.m_bBombDefused

									if not v536.is_defused then
										local m_hBombDefuser = v537.m_hBombDefuser

										if m_hBombDefuser ~= nil then
											v536.defuser = m_hBombDefuser
											v536.defuse_length = v537.m_flDefuseLength
											v536.defuse_countdown = v537.m_flDefuseCountDown
											v536.defuse_remaining = math.clamp((v536.defuse_countdown - globals.curtime) / v536.defuse_length, 0, 1)
										end
									end

									return
								end
							end)
							t15.planted = t17
							t15.planting = t16
							t18 = {
								ragebot = {
									dormant_aimbot = pui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"),
									hide_shots = pui.find("Aimbot", "Ragebot", "Main", "Hide Shots", {
										options = "Options"
									}),
									double_tap = pui.find("Aimbot", "Ragebot", "Main", "Double Tap", {
										lag_options = "Lag Options"
									}),
									safety = {
										safe_points = pui.find("Aimbot", "Ragebot", "Safety", "Safe Points"),
										body_aim = pui.find("Aimbot", "Ragebot", "Safety", "Body Aim")
									}
								},
								anti_aim = {
									angles = {
										pitch = pui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
										yaw = pui.find("Aimbot", "Anti Aim", "Angles", "Yaw", {
											base = "Base",
											avoid_backstab = "Avoid Backstab",
											hidden = "Hidden",
											offset = "Offset"
										}),
										yaw_modifier = pui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", {
											offset = "Offset"
										}),
										body_yaw = pui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", {
											options = "Options",
											inverter = "Inverter",
											freestanding = "Freestanding",
											right_limit = "Right Limit",
											left_limit = "Left Limit"
										}),
										freestanding = pui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", {
											body = "Body Freestanding",
											disable_yaw_modifiers = "Disable Yaw Modifiers"
										})
									},
									fake_lag = {
										enabled = pui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"),
										limit = pui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"),
										variability = pui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability")
									},
									other = {
										fake_duck = pui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
										slow_walk = pui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
										leg_movement = pui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")
									}
								},
								world = {
									main = {
										override_zoom = pui.find("Visuals", "World", "Main", "Override Zoom", {
											scope_overlay = "Scope Overlay"
										})
									}
								},
								misc = {
									other = {
										windows = pui.find("Miscellaneous", "Main", "Other", "Windows"),
										fake_latency = pui.find("Miscellaneous", "Main", "Other", "Fake Latency")
									},
									in_game = {
										clan_tag = pui.find("Miscellaneous", "Main", "In-Game", "Clan Tag"),
										shared_features = pui.find("Miscellaneous", "Main", "In-Game", "Shared Features")
									}
								}
							}

							function t18.is_slow_motion()
								-- upvalues: t18 (copy)
								return t18.anti_aim.other.slow_walk:get() or t18.anti_aim.other.slow_walk:get_override()
							end

							t19 = {}

							local n10 = 3.63
							local n11 = 0.45
							local n12 = 0
							local n13 = 0

							local function v67(p64)
								-- upvalues: normalize_yaw (copy)
								return normalize_yaw(p64.eye_yaw - p64.abs_yaw)
							end

							t19.flags = 0
							t19.packets = 0
							t19.body_yaw = 0
							t19.duck_amount = 0
							t19.movetype = 0
							t19.velocity = 0
							t19.is_frozen = false
							t19.is_onground = false
							t19.is_crouched = false
							t19.is_moving = false
							t19.is_landing = false
							t19.is_airborne = false
							t19.in_scoreboard = false

							function t19.setup_command(_)
								-- upvalues: n12 (ref)
								local v541 = entity.get_local_player()

								if v541 then
									n12 = v541.m_fFlags

									return
								end
							end
							function t19.run_command(_)
								-- upvalues: n13 (ref)
								local v543 = entity.get_local_player()

								if v543 then
									n13 = v543.m_fFlags

									return
								end
							end
							function t19.net_update_end()
								-- upvalues: t19 (copy), v67 (copy), t4 (copy), n11 (copy), n10 (copy), n12 (ref), n13 (ref)
								local v544 = entity.get_local_player()

								if v544 then
									local v545 = v544:get_anim_state()

									if v545 then
										local m_fFlags = v544.m_fFlags
										local m_MoveType = v544.m_MoveType
										local m_flDuckAmount = v544.m_flDuckAmount

										t19.flags = m_fFlags
										t19.movetype = m_MoveType
										t19.velocity = v545.velocity

										if globals.choked_commands == 0 then
											t19.body_yaw = v67(v545)
											t19.duck_amount = m_flDuckAmount
										end

										t19.is_frozen = bit.band(m_fFlags, t4.FL_FROZEN) ~= 0
										t19.is_onground = v545.on_ground
										t19.is_crouched = not (t19.duck_amount <= n11)
										t19.is_moving = not (t19.velocity <= vector(n10, n10, n10))
										t19.is_landing = v545.landing
										t19.is_airborne = bit.band(n12, n13, t4.FL_ONGROUND) == 0

										return
									end

									return
								end
							end
							function t19.createmove(p67)
								-- upvalues: t19 (copy)
								if globals.choked_commands == 0 then
									t19.packets = t19.packets + 1
								end

								t19.in_scoreboard = p67.in_score
							end
						end

						pui.colors.accent = color("#7396FFFF")
						pui.colors.hit = color("#7396FFFF")
						pui.colors.miss = color("#FF7373FF")

						local t20 = {}

						do
							local v69 = true
							local s3 = "ui/beepclear.wav"
							local s4 = "resource/warning.wav"
							local s5 = "ui/menu_back.wav"
							local playvol = cvar.playvol
							local t21 = {
								warning = "\aFFFF32FF",
								error = "\aFF3232FF",
								info = "\a7f7fFFFF"
							}

							local function v75(p68, p69, p70)
								-- upvalues: v69 (copy), playvol (copy), t21 (copy)
								if v69 then
									if p70 then
										playvol:call(p70, 1)
									end

									print_raw(string.format("%s[%s]\aDEFAULT %s", t21[p68], p68, p69))
									print_dev(p69)

									return
								end
							end

							function t20.info(p71)
								-- upvalues: v75 (copy), s3 (copy)
								v75("info", p71, s3)
							end
							function t20.warning(p72)
								-- upvalues: v75 (copy), s4 (copy)
								v75("warning", p72, s4)
							end
							function t20.error(p73)
								-- upvalues: v75 (copy), s5 (copy)
								v75("error", p73, s5)
							end

							t22 = {}

							local s6 = "NEXUS::USERDATA"
							local u78 = db[s6]

							if not u78 then
								t20.warning("no nexus userdata found, creating new one")
								u78 = {}
							end

							if not u78.configurations then
								u78.configurations = {}
							end

							if not u78.time_spent then
								u78.time_spent = 0
							end

							if not u78.kills then
								u78.kills = 0
							end

							if not u78.misses then
								u78.misses = 0
							end

							events.player_death:set(function(p74)
								-- upvalues: t22 (ref)
								local v557 = entity.get_local_player()
								local v558 = entity.get(p74.userid, true)

								if not v558:is_bot() then
									if v557 == entity.get(p74.attacker, true) and v557 ~= v558 then
										t22.kills = t22.kills + 1
									end

									return
								end
							end)
							events.aim_ack:set(function(p75)
								-- upvalues: t22 (ref)
								if p75.state then
									if not p75.target:is_bot() then
										t22.misses = t22.misses + 1

										return
									end

									return
								end
							end)
							events.shutdown(function()
								-- upvalues: s6 (copy), u78 (ref)
								db[s6] = u78
							end)
							t22 = u78
						end

						t23 = {}

						local s7 = "nexus::cfg"
						local t24 = {}
						local t25 = {
							[1] = "nexus::cfg::g6ZhdXRob3Klc3F3YXSkbmFtZadEZWZhdWx0p2NvbnRlbnSCq2FudGlfYWltYm90hKdnZW5lcmFshqptYW51YWxfeWF3qERpc2FibGVkq35tYW51YWxfeWF3gah5YXdfYmFzZapMb2NhbCBWaWV3rmF2b2lkX2JhY2tzdGFiw6l+ZWRnZV95YXeBqHdoaWxlX2ZkwqhlZGdlX3lhd8KsZnJlZXN0YW5kaW5nwq5zdGF0ZV9zZWxlY3RvcginYnVpbGRlcpiJqG92ZXJyaWRlw6d+ZGVzeW5jg6RsZWZ0PKVyaWdodDysZnJlZXN0YW5kaW5no09mZql+bW9kaWZpZXKCpHdheXMDpm9mZnNldACpZGVmZW5zaXZlwqhtb2RpZmllcqhEaXNhYmxlZKZkZXN5bmPDqn5kZWZlbnNpdmWCpXBpdGNopERvd26jeWF3qERpc2FibGVko3lhd6kxODDCsCBML1Kkfnlhd4akbGVmdOqmb2Zmc2V0AKlyYW5kb21pemUAq3ZhcmlhYmlsaXR5NKVyaWdodCylZGVsYXkIiahvdmVycmlkZcOnfmRlc3luY4OkbGVmdDylcmlnaHQ8rGZyZWVzdGFuZGluZ6NPZmapfm1vZGlmaWVygqR3YXlzA6ZvZmZzZXQAqWRlZmVuc2l2ZcKobW9kaWZpZXKoRGlzYWJsZWSmZGVzeW5jw6p+ZGVmZW5zaXZlgqVwaXRjaKhEaXNhYmxlZKN5YXeoRGlzYWJsZWSjeWF3qTE4MMKwIEwvUqR+eWF3hqRsZWZ066ZvZmZzZXQAqXJhbmRvbWl6ZRqrdmFyaWFiaWxpdHkjpXJpZ2h0KaVkZWxheQKJqG92ZXJyaWRlw6d+ZGVzeW5jg6RsZWZ0PKVyaWdodDysZnJlZXN0YW5kaW5no09mZql+bW9kaWZpZXKCpHdheXMDpm9mZnNldACpZGVmZW5zaXZlwqhtb2RpZmllcqhEaXNhYmxlZKZkZXN5bmPDqn5kZWZlbnNpdmWCpXBpdGNoqERpc2FibGVko3lhd6hEaXNhYmxlZKN5YXepMTgwwrAgTC9SpH55YXeGpGxlZnTkpm9mZnNldACpcmFuZG9taXplEKt2YXJpYWJpbGl0eRKlcmlnaHQipWRlbGF5A4mob3ZlcnJpZGXDp35kZXN5bmODpGxlZnQ3pXJpZ2h0PKxmcmVlc3RhbmRpbmejT2ZmqX5tb2RpZmllcoKkd2F5cwOmb2Zmc2V0AKlkZWZlbnNpdmXCqG1vZGlmaWVyqERpc2FibGVkpmRlc3luY8OqfmRlZmVuc2l2ZYKlcGl0Y2ioRGlzYWJsZWSjeWF3qERpc2FibGVko3lhd6kxODDCsCBML1Kkfnlhd4akbGVmdNDXpm9mZnNldACpcmFuZG9taXplFat2YXJpYWJpbGl0eRKlcmlnaHQppWRlbGF5BYmob3ZlcnJpZGXDp35kZXN5bmODpGxlZnQ8pXJpZ2h0PKxmcmVlc3RhbmRpbmejT2ZmqX5tb2RpZmllcoKkd2F5cwOmb2Zmc2V0AKlkZWZlbnNpdmXCqG1vZGlmaWVyqERpc2FibGVkpmRlc3luY8OqfmRlZmVuc2l2ZYKlcGl0Y2ioRGlzYWJsZWSjeWF3qERpc2FibGVko3lhd6kxODDCsCBML1Kkfnlhd4akbGVmdOumb2Zmc2V0zLSpcmFuZG9taXplEqt2YXJpYWJpbGl0eROlcmlnaHQppWRlbGF5BImob3ZlcnJpZGXDp35kZXN5bmODpGxlZnQ8pXJpZ2h0PKxmcmVlc3RhbmRpbmejT2ZmqX5tb2RpZmllcoKkd2F5cwOmb2Zmc2V0AKlkZWZlbnNpdmXCqG1vZGlmaWVyqERpc2FibGVkpmRlc3luY8OqfmRlZmVuc2l2ZYKlcGl0Y2ioRGlzYWJsZWSjeWF3qERpc2FibGVko3lhd6kxODDCsCBML1Kkfnlhd4akbGVmdOumb2Zmc2V0AKlyYW5kb21pemUQq3ZhcmlhYmlsaXR5FaVyaWdodCmlZGVsYXkDiahvdmVycmlkZcOnfmRlc3luY4OkbGVmdDylcmlnaHQ8rGZyZWVzdGFuZGluZ6NPZmapfm1vZGlmaWVygqR3YXlzA6ZvZmZzZXQAqWRlZmVuc2l2ZcKobW9kaWZpZXKoRGlzYWJsZWSmZGVzeW5jw6p+ZGVmZW5zaXZlgqVwaXRjaKhEaXNhYmxlZKN5YXeoRGlzYWJsZWSjeWF3qTE4MMKwIEwvUqR+eWF3hqRsZWZ05KZvZmZzZXQAqXJhbmRvbWl6ZRCrdmFyaWFiaWxpdHkSpXJpZ2h0IqVkZWxheQOJqG92ZXJyaWRlw6d+ZGVzeW5jg6RsZWZ0PKVyaWdodDysZnJlZXN0YW5kaW5no09mZql+bW9kaWZpZXKCpHdheXMDpm9mZnNldACpZGVmZW5zaXZlwqhtb2RpZmllcqhEaXNhYmxlZKZkZXN5bmPDqn5kZWZlbnNpdmWCpXBpdGNoqERpc2FibGVko3lhd6hEaXNhYmxlZKN5YXepMTgwwrAgTC9SpH55YXeGpGxlZnTkpm9mZnNldACpcmFuZG9taXplFat2YXJpYWJpbGl0eTWlcmlnaHQspWRlbGF5BqVvdGhlcoSpZGlzYWJsZXJzgqhub19lbmVtecKmd2FybXVwwqp+ZGVmZW5zaXZlgbpjb21wYXRpYmxlX3dpdGhfaGlkZV9zaG90c8OpZGVmZW5zaXZlr0ZvcmNlIERlZmVuc2l2ZapzdGF0aWNfeWF3kqpNYW51YWwgWWF3oX6oc2V0dGluZ3OIpHJhZ2WHpGxvZ3PDpX5sb2dzgqdkaXNwbGF5lKZTY3JlZW6mRXZlbnRzp0NvbnNvbGWhfqNjbHKTo0hpdKkjOUFBREU1RkahfqpoaWRkZW5fdGFwwq9+ZG9ybWFudF9haW1ib3SEqmF1dG9fc2NvcGXDqGFjY3VyYWN5S6ZkYW1hZ2UBqGhpdGJveGVzlKRIZWFkpUNoZXN0p1N0b21hY2ihfqx+cGVla19hc3Npc3SBqWJlaGF2aW9yc5WqUXVpY2sgUGVla6lFZGdlIFN0b3CyRXh0ZW5kZWQgQmFja3RyYWNrrEZyZWVzdGFuZGluZ6F+q3BlZWtfYXNzaXN0wq5kb3JtYW50X2FpbWJvdMKoZmVhdHVyZXOGsX5ncmVuYWRlX2ZlYXR1cmVzhal0aHJvd19maXjDqnN1cGVyX3Rvc3PDp21vbG90b3bCpmRhbWFnZQGsYXV0b19yZWxlYXNlwqt+Z2FtZV9mb2N1c4KlZmxhc2jDpWZvY3VzwqtmYXN0X2xhZGRlcsOqZ2FtZV9mb2N1c8OwZ3JlbmFkZV9mZWF0dXJlc8Oubm9fZmFsbF9kYW1hZ2XCpW90aGVyhKlmYWtlX2R1Y2uTrFVubG9jayBzcGVlZKtGcmVlemUgdGltZaF+qWVkZ2Vfc3RvcMKudW5sb2NrX2xhdGVuY3nDrWFpcl9jb2xsaXNpb27CqmluZGljYXRvcnOFsHNjcmVlbl9pbmRpY2F0b3LDsGRhbWFnZV9pbmRpY2F0b3LDrW1hbnVhbF9hcnJvd3PDsX5kYW1hZ2VfaW5kaWNhdG9ygqVzbWFsbMKoYW5pbWF0ZWTDrn5tYW51YWxfYXJyb3dzgaVzdHlsZaZNb2Rlcm6nd2lkZ2V0c4WwdmVsb2NpdHlfd2FybmluZ8Kpd2F0ZXJtYXJrw6hrZXliaW5kc8Oqc3BlY3RhdG9yc8KqfndhdGVybWFya4KmZmllbGRzkaF+qHVzZXJuYW1loKdpbl9nYW1liLBza2VldF9pbmRpY2F0b3Jzw6l2aWV3bW9kZWzDqn52aWV3bW9kZWyEoXj2o2Zvds0CbKF54qF64q1+YXNwZWN0X3JhdGlvgahldmFsdWF0ZXutfmN1c3RvbV9zY29wZYSmb2Zmc2V0CqZsZW5ndGhkqGludmVydGVywqkqaW52ZXJ0ZXKpIzk3OTc5N0ZGrGFzcGVjdF9yYXRpb8OsY3VzdG9tX3Njb3Blw7F+c2tlZXRfaW5kaWNhdG9yc4Goc2VsZWN0ZWSYAQIDBAUGB6F+pWNhY2hlgqhwb3NfeF93bQCoYWxpZ25fd20CpXN0eWxlg6RnbG93w6ZhY2NlbnSpI0M5QzdFQTgypGJsdXLD::nexus::cfg"
						}

						local function v83(p76, p77, p78)
							return {
								name = p77,
								author = p76,
								content = p78
							}
						end
						local function v84(p79)
							-- upvalues: base64 (copy), s7 (copy)
							local v564 = msgpack.pack(p79)
							local v565 = base64.encode(v564)

							return table.concat({
								[1] = s7,
								[2] = v565,
								[3] = s7
							}, "::")
						end
						local function v85(p80)
							-- upvalues: s7 (copy), base64 (copy)
							local v567 = p80:match(s7 .. "::(.+)::" .. s7)

							if v567 then
								local v568 = base64.decode(v567)

								return (msgpack.unpack(v568))
							end

							return nil
						end
						local function v86(p81)
							-- upvalues: t25 (copy), v85 (copy), t24 (ref)
							for _, v in ipairs(t25) do
								local ok, result = pcall(v85, v)

								if ok and result and p81 == result.name then
									return v, -2
								end
							end

							for i = #t24, 1, -1 do
								local v575 = t24[i]

								if p81 == v85(v575).name then
									return v575, i
								end
							end

							return nil, -1
						end

						function t23.save(p82)
							-- upvalues: t20 (copy), v86 (copy), v83 (copy), pui (copy), v84 (copy), t24 (ref), t22 (ref), t25 (copy)
							local v577 = p82:match("^%s*(.*%S)%s*$") or ""

							if v577 ~= "" then
								local v578, v579 = v86(v577)

								if v579 ~= -2 then
									local v580 = v83(common.get_username(), v577, pui.save())
									local v581 = v84(v580)

									if v578 ~= nil then
										t24[v579] = v581
									else
										table.insert(t24, v581)
										v579 = #t24
									end

									t22.configurations = t24
									t20.info("configuration saved successfully")

									return #t25 + v579
								end

								t20.error("cannot modify pinned configuration")

								return false
							end

							t20.error("configuration name cannot be empty")

							return false
						end
						function t23.load(p83)
							-- upvalues: t20 (copy), t25 (copy), t24 (ref), v85 (copy), pui (copy)
							if p83 ~= nil and not (p83 <= 0) then
								local v583

								if not (p83 <= #t25) then
									v583 = t24[p83 - #t25]
								else
									v583 = t25[p83]
								end

								if v583 ~= nil then
									local ok, result = pcall(v85, v583)

									if ok then
										local v586 = result.content or result.settings

										if pcall(pui.load, v586) then
											t20.info("successfully loaded " .. result.author .. "'s configuration")

											return true
										end

										t20.error("failed to load configuration data")

										return false
									end

									t20.error("failed to decode configuration data")

									return false
								end

								t20.error("configuration not found")

								return false
							end

							t20.error("invalid configuration index")

							return false
						end
						function t23.export(p84)
							-- upvalues: v83 (copy), pui (copy), v84 (copy), t20 (copy), clipboard (copy)
							local v588 = v83(common.get_username(), p84, pui.save())
							local ok, result = pcall(v84, v588)

							if ok then
								clipboard.set(result)
								t20.info("successfully copied configuration to clipboard")

								return
							end

							t20.error("failed to encode configuration data: " .. result)
						end
						function t23.import(p85)
							-- upvalues: v85 (copy), t20 (copy), pui (copy)
							local ok, result = pcall(v85, p85)

							if ok then
								local v594 = result.content or result.settings

								if pcall(pui.load, v594) then
									t20.info("successfully imported " .. result.author .. "'s configuration")

									return
								end

								t20.error("failed to load configuration data")

								return
							end

							t20.error("failed to decode configuration data")
						end
						function t23.delete(p86)
							-- upvalues: t25 (copy), t20 (copy), t24 (ref), t22 (ref)
							if p86 ~= nil and not (p86 <= #t25) then
								local v596 = p86 - #t25

								if t24[v596] then
									table.remove(t24, v596)
									t22.configurations = t24
									t20.info("successfully deleted configuration")

									return true
								end

								t20.error("configuration not found")

								return false
							end

							t20.error("cannot delete pinned configuration")

							return false
						end
						function t23.get_list()
							-- upvalues: t25 (copy), v85 (copy), t24 (ref)
							local t26 = {}

							for _, v in ipairs(t25) do
								local ok, result = pcall(v85, v)

								if ok and result then
									table.insert(t26, result.name .. " \a{Disabled Text}(pinned)")
								end
							end

							for i = 1, #t24 do
								local v603 = v85(t24[i])

								table.insert(t26, v603.name)
							end

							return t26
						end
						function t23.get(p87)
							-- upvalues: t25 (copy), t24 (ref), v85 (copy)
							if p87 ~= nil and not (p87 <= 0) then
								local v605

								if not (p87 <= #t25) then
									v605 = t24[p87 - #t25]
								else
									v605 = t25[p87]
								end

								if v605 ~= nil then
									local ok, result = pcall(v85, v605)

									if ok then
										return result
									end

									return nil
								end

								return nil
							end

							return nil
						end
						function t23.update_list()
							-- upvalues: t24 (ref), t22 (ref)
							t24 = t22.configurations or {}
						end

						t23.update_list()
						u87 = false

						local n14 = 0

						events.createmove(function()
							-- upvalues: n14 (ref), u87 (ref)
							local v608 = entity.get_local_player()

							if v608 then
								local v609 = utils.net_channel()
								local v610 = v608:get_simulation_time()

								if v610 and v609 then
									local v611 = to_ticks(v610.current - v610.old)

									if v611 < 0 then
										n14 = globals.tickcount + math.abs(v611) - to_ticks(v609.latency[0])
									end

									u87 = not (n14 <= globals.tickcount)

									return
								end

								return
							end
						end)
						v89 = v1()
						t27 = {}

						local s8 = "\226\128\138"

						local function v92(p88)
							-- upvalues: s8 (copy)
							return string.rep(s8, p88)
						end

						function v93(p89, p90)
							-- upvalues: v92 (copy)
							local v615 = v92(p90)

							return v615 .. p89 .. v615
						end

						local v94 = false
						local v95 = false

						n15 = 3

						function v97(p91, p92, p93, p94)
							-- upvalues: v94 (copy), n15 (ref), v95 (copy), pui (copy), v92 (copy)
							if v94 then
								p92 = " \a{Small Text}|\aDEFAULT  " .. p92
								n15 = 0
							end

							local v620 = string.format("\f<%s>\r", p91)

							if not p94 then
								v620 = "\v" .. v620
							end

							if v95 then
								p92 = p92:lower()
							end

							return pui.string(v620 .. v92(p93 + n15 or n15) .. p92)
						end
						function v98(p95, p96)
							-- upvalues: pui (copy), t5 (copy)
							local v623 = p95:list("")

							local function v624()
								-- upvalues: v623 (copy), p96 (copy), pui (copy), t5 (copy)
								local value = v623.value
								local t28 = {}

								for i, v in ipairs(p96) do
									local v1332 = value == i and "\v" or "\a{Small Text}"

									t28[i] = pui.string(v1332 .. v)
								end

								v623:update(t28)

								if ui.get_alpha() > 0 then
									t5.click()
								end
							end

							v623:set_callback(function()
								-- upvalues: v624 (copy)
								v624()
							end, true)

							return v623
						end

						events.render(function()
							-- upvalues: v23 (copy), pui (copy), t2 (copy)
							if ui.get_alpha() ~= 0 then
								local v625 = ui.get_style()
								local v626 = v23("nexus  ", globals.realtime, v625["Link Active"], v625["Text Preview"])

								pui.sidebar(v626, t2.icon)

								return
							end
						end)
						t29 = {
							PROFILE = {
								ICON = "\f<house>",
								TABS = {
									v97("angle-right", "About", 3, true),
									v97("angle-right", "Configs", 3, true)
								},
								SECTIONS = {
									[1] = {
										[1] = "tabs",
										[2] = "##PROFILE"
									},
									[2] = {
										[1] = "notation",
										[2] = "##NOTATION",
										[3] = 1
									},
									[3] = {
										[1] = "dashboard",
										[2] = "##DASHBOARD"
									},
									[4] = {
										[1] = "statistics",
										[2] = "STATISTICS",
										[3] = 2
									},
									[5] = {
										[1] = "statistics_2",
										[2] = "##STATISTICS_2",
										[3] = 2
									},
									[6] = {
										[1] = "configurations",
										[2] = "##CONFIGURATIONS"
									}
								}
							},
							ANTI_AIM = {
								ICON = "\f<shield-cat>",
								TABS = {
									v97("microchip", "General", 3, true),
									v97("trowel", "Builder", 3, true)
								},
								SECTIONS = {
									[1] = {
										[1] = "tabs",
										[2] = "##ANTI_AIM"
									},
									[2] = {
										[1] = "state_selector",
										[2] = "##STATE_SELECTOR",
										[3] = 1
									},
									[3] = {
										[1] = "general",
										[2] = "##GENERAL"
									},
									[4] = {
										[1] = "other",
										[2] = "##OTHER"
									},
									[5] = {
										[1] = "yaw",
										[2] = "YAW",
										[3] = 2
									},
									[6] = {
										[1] = "desync",
										[2] = "DESYNC",
										[3] = 2
									},
									[7] = {
										[1] = "defensive",
										[2] = "DEFENSIVE",
										[3] = 2
									}
								}
							},
							SETTINGS = {
								ICON = "\f<square-sliders>",
								TABS = {
									v97("bars-staggered", "Features", 4, true),
									v97("eye", "Visuals", 3, true),
									v97("symbols", "Other", 4, true)
								},
								SECTIONS = {
									[1] = {
										[1] = "tabs",
										[2] = "##SETTINGS"
									},
									[2] = {
										[1] = "features",
										[2] = "##FEATURES"
									},
									[3] = {
										[1] = "ragebot",
										[2] = "##RAGEBOT",
										[3] = 2
									},
									[4] = {
										[1] = "in_game",
										[2] = "##IN_GAME",
										[3] = 1
									},
									[5] = {
										[1] = "style",
										[2] = "##STYLE",
										[3] = 2
									},
									[6] = {
										[1] = "indicators",
										[2] = "##INDICATORS",
										[3] = 2
									},
									[7] = {
										[1] = "widgets",
										[2] = "##WIDGETS",
										[3] = 2
									},
									[8] = {
										[1] = "cache",
										[2] = "##CACHE"
									},
									[9] = {
										[1] = "other",
										[2] = "##OTHER"
									},
									[10] = {
										[1] = "shared",
										[2] = "##SHARED",
										[3] = 2
									}
								}
							}
						}

						local PROFILE = t29.PROFILE

						TABS = PROFILE.TABS

						local SECTIONS = PROFILE.SECTIONS
						local ICON = PROFILE.ICON

						v104 = pui.create(ICON, SECTIONS)
					end

					local v105 = v98(v104.tabs, TABS)
					local notation = v104.notation
					local dashboard = v104.dashboard
					local statistics = v104.statistics
					local statistics_2 = v104.statistics_2

					notation:label(v97("wand-magic-sparkles", "We wish you good luck, thank you for using our script!", 5))
					dashboard:label(v97("circle-user", "User", 6))
					dashboard:button("\v" .. common.get_username(), nil, true)
					dashboard:label(v97("brackets-curly", "Branch", 5))
					dashboard:button("\v" .. t2.branch, nil, true)
					statistics:label(v97("stopwatch", "Session time", 7))

					local v110 = statistics:button("\v0 Minutes", nil, true)

					statistics:label(v97("clock", "Time spent", 6))

					local v111 = statistics:button("\v0 Minutes", nil, true)

					statistics_2:label(v97("skull", "Kills", 6))

					local v112 = statistics_2:button("\v0", nil, true)

					statistics_2:label(v97("triangle-exclamation", "Misses", 6))

					local v113 = statistics_2:button("\v0", nil, true)

					local function v114(p97)
						return math.floor(p97 / 3600), (math.floor(p97 / 60))
					end

					local n16 = 0
					local u116 = false
					local u117 = false

					v110:set_callback(function()
						-- upvalues: u116 (ref), n16 (ref)
						u116 = not u116

						if n16 < 3600 then
							u116 = false
						end
					end, true)
					v111:set_callback(function()
						-- upvalues: u117 (ref), t22 (ref)
						u117 = not u117

						if t22.time_spent < 3600 then
							u117 = false
						end
					end, true)
					events.render(function()
						-- upvalues: n16 (ref), t22 (ref), v114 (copy), u116 (ref), v110 (copy), u117 (ref), v111 (copy), v112 (copy), v113 (copy)
						local frametime = globals.frametime

						n16 = n16 + frametime
						t22.time_spent = t22.time_spent + frametime

						if ui.get_alpha() > 0 then
							local v629, v630 = v114(n16)
							local v631 = u116 and v629 or v630
							local v632 = u116 and "Hours" or "Minutes"

							v110:name("\v" .. v631 .. " " .. v632)

							local v633, v634 = v114(t22.time_spent)
							local v635 = u117 and v633 or v634
							local v636 = u117 and "Hours" or "Minutes"

							v111:name("\v" .. v635 .. " " .. v636)
						end

						local v637 = "\v" .. t22.kills
						local v638 = "\v" .. t22.misses

						if v637 ~= v112 or v638 ~= v113 then
							v112:name(v637)
							v113:name(v638)
						end
					end)
					dashboard:depend({
						[1] = nil,
						[2] = 1,
						[1] = v105
					})
					statistics:depend({
						[1] = nil,
						[2] = 1,
						[1] = v105
					})
					statistics_2:depend({
						[1] = nil,
						[2] = 1,
						[1] = v105
					})
					notation:depend({
						[1] = nil,
						[2] = 1,
						[1] = v105
					})

					local configurations = v104.configurations
					local v119 = configurations:list("##PRESET_LIST", t23.get_list())
					local v120 = configurations:input("##PRESET_NAME", "Default")

					configurations:button(v93(v97("download", "Load", 3), 3), function()
						-- upvalues: t23 (copy), v119 (copy), t9 (copy)
						t23.load(v119:get())

						for _, v in ipairs(t9.list) do
							v:update(true)
						end

						t23.update_list()
						v119:update(t23.get_list())
					end, true):tooltip("Click to load the configuration you selected from the list above.\n\n\vNote:\r This will overwrite your current settings with the selected configuration.")
					configurations:button(v93(v97("floppy-disk", "Save", 3), 3), function()
						-- upvalues: t23 (copy), v120 (copy), v119 (copy)
						local v641 = t23.save(v120:get())

						t23.update_list()
						v119:update(t23.get_list())

						if v641 and v641 > 0 then
							v119:set(v641)
						end
					end, true):tooltip("Click to save your current settings as a new configuration with the name entered above or overwrite the selected configuration.")
					configurations:button(v93("\aFF3232FF\f<trash>", 3), function()
						-- upvalues: t23 (copy), v119 (copy)
						t23.delete(v119:get())
						t23.update_list()
						v119:update(t23.get_list())
					end, true):tooltip("Click to permanently delete the selected configuration.\n\n\vNote:\r This action cannot be undone.")
					configurations:button(v93("\f<copy>", 3), function()
						-- upvalues: t23 (copy), v120 (copy)
						t23.export(v120:get())
					end, true):tooltip("Click to copy your current settings to clipboard.\n\n\vNote:\r This only copies your active settings, not the settings from the selected configuration.")
					configurations:button(v93("\f<paste>", 3), function()
						-- upvalues: t23 (copy), clipboard (copy)
						t23.import(clipboard.get())
					end, true):tooltip("Click to apply settings from your clipboard.\n\n\vNote:\r This will update your active settings but will not modify the selected configuration.")
					v119:set_callback(function(p98)
						-- upvalues: t23 (copy), v120 (copy)
						local v643 = p98:get()

						if v643 ~= nil and not (v643 <= 0) then
							local v644 = t23.get(v643)

							if v644 ~= nil then
								v120:set(v644.name)

								return
							end

							return
						end
					end)
					configurations:depend({
						[1] = nil,
						[2] = 2,
						[1] = v105
					})
				end

				local t30 = {}
				local ANTI_AIM = t29.ANTI_AIM
				local TABS = ANTI_AIM.TABS
				local SECTIONS = ANTI_AIM.SECTIONS
				local ICON = ANTI_AIM.ICON
				local v126 = pui.create(ICON, SECTIONS)
				local v127 = v98(v126.tabs, TABS)

				t30.general = {}

				local general = t30.general
				local general2 = v126.general

				general.manual_yaw = general2:combo(v97("arrows-repeat", "Manual Yaw", 3), {
					[1] = "Disabled",
					[2] = "Forward",
					[3] = "Backward",
					[4] = "Left",
					[5] = "Right"
				}, function(p99)
					-- upvalues: v97 (copy)
					return {
						yaw_base = p99:combo(v97("crosshairs", "Yaw Base", 4), {
							[1] = "Local View",
							[2] = "At Target"
						})
					}
				end)
				general.freestanding = general2:switch(v97("arrows-spin", "Freestanding", 3))
				general.edge_yaw = general2:switch(v97("triangle", "Edge Yaw", 3), false, function(p100)
					-- upvalues: v97 (copy)
					return {
						while_fd = p100:switch(v97("duck", "While Fake Duck", 3), false, "Automatically enables \"Edge Yaw\" on Fake Duck.")
					}
				end)
				general.avoid_backstab = general2:switch(v97("arrows-spin", "Avoid Backstab", 3))
				general.safe_head = general2:switch(v97("helmet-safety", "Safe Head", 2), false, function(p101)
					-- upvalues: v97 (copy)
					return {
						weapon = p101:listable(v97("gun", "Weapon", 3), {
							[1] = "Knife",
							[2] = "Zeus"
						}),
						height_difference = p101:slider(v97("line-height", "Height Difference", 3), 0, 35, 20, 1, function(p102)
							if p102 ~= 0 then
								if p102 ~= 35 then
									return p102 .. "u"
								end

								return "Max"
							end

							return "N/A"
						end)
					}, true
				end)
				general.jitter_move = general2:switch(v97("waveform-lines", "Jitter Move", 1), true)
				general2:depend({
					[1] = nil,
					[2] = 1,
					[1] = v127
				})
				t30.other = {}

				local other = t30.other
				local other2 = v126.other

				other.defensive = other2:label(v97("sparkles", "Defensive", 3), function(p103)
					-- upvalues: v97 (copy)
					return {
						compatible_with_hide_shots = p103:switch(v97("eye-slash", "Compatible with Hide Shots", 3), false, "\v\f<circle-info>  \rRemember it overwrites Hide Shots mode"),
						conditions = p103:listable("##CONDITIONS", {
							[1] = "Standing",
							[2] = "Running",
							[3] = "Slowwalking",
							[4] = "Ducking",
							[5] = "Sneaking",
							[6] = "In Air",
							[7] = "In Air & Crouching"
						})
					}
				end)
				other.disablers = other2:label(v97("lock", "Disablers", 4), function(p104)
					-- upvalues: v97 (copy)
					return {
						warmup = p104:switch(v97("wind", "Warmup", 5)),
						no_enemy = p104:switch(v97("users-slash", "No Enemy", 3))
					}
				end)
				other.static_yaw = other2:selectable(v97("chart-radar", "Static Yaw", 3), {
					[1] = "Freestanding",
					[2] = "Manual Yaw"
				})
				other.animation_breaker = other2:switch(v97("person-falling", "Animation Breaker", 4), false, function(p105)
					-- upvalues: v97 (copy)
					return {
						interpolation = p105:slider(v97("wave-square", "Interpolation", 5), 0, 14, 0, 1, function(p106)
							if p106 ~= 0 then
								if p106 ~= 9 then
									if p106 ~= 14 then
										return p106 .. "t"
									end

									return "High"
								end

								return "Medium"
							end

							return "Default"
						end),
						leaning = p105:slider(v97("scale-balanced", "Leaning", 5), 0, 100, 0, 50, function(p107)
							if p107 ~= 0 then
								if p107 ~= 100 then
									return p107 .. "%"
								end

								return "Maximum"
							end

							return "Disabled"
						end),
						ground = p105:combo(v97("mountain", "Ground", 6), {
							[1] = "None",
							[2] = "Follow direction",
							[3] = "Jitter legs",
							[4] = "Moon walk",
							[5] = "Kangaroo"
						}),
						air = p105:combo(v97("wind", "Air", 6), {
							[1] = "None",
							[2] = "Falling",
							[3] = "Walking",
							[4] = "Kangaroo"
						})
					}
				end)
				other.fakelag_disablers = other2:selectable(v97("align-slash", "FL Disablers", 1), {
					[1] = "Double Tap",
					[2] = "Hide Shots",
					[3] = "Standing"
				})
				other2:depend({
					[1] = nil,
					[2] = 1,
					[1] = v127
				})
				t30.builder = {}

				local builder = t30.builder
				local v133 = v98(v126.state_selector, {
					v97("user", "Default", 7, true),
					v97("person", "Standing", 8, true),
					v97("person-running", "Running", 6, true),
					v97("person-walking", "Slowwalking", 8, true),
					v97("person-seat", "Ducking", 7, true),
					v97("wheelchair-move", "Sneaking", 6, true),
					v97("person-ski-jumping", "In Air", 5, true),
					v97("person-sledding", "In Air & Crouching", 5, true)
				})

				for i, v in ipairs(t3) do
					local t37 = {
						override = v126.state_selector:switch(v97(v == "Default" and "toggle-on" or "toggle-off", string.format("Override \v%s", v), 5), v == "Default"),
						yaw = v126.yaw:combo(v97("angle", "Yaw", 6), {
							[1] = "Default",
							[2] = "180° L/R"
						}, function(p108, p109)
							-- upvalues: v97 (copy)
							local t31 = {
								offset = p108:slider(v97("angle", "Offset", 4), -180, 180, 0, 1, "°"),
								left = p108:slider(v97("left", "Left", 6), -180, 180, 0, 1, "°"),
								right = p108:slider(v97("right", "Right", 6), -180, 180, 0, 1, "°"),
								randomize = p108:slider(v97("shuffle", "Randomize", 5), 0, 100, 0, 1, function(p110)
									return p110 == 0 and "Off" or p110 .. "%"
								end),
								delay = p108:slider(v97("clock", "Delay", 5), 1, 20, 1, 1, function(p111)
									return p111 == 1 and "Off" or p111 .. "t"
								end),
								variability = p108:slider(v97("dice", "Variability", 3), 0, 100, 0, 1, function(p112)
									return p112 == 0 and "Off" or p112 .. "%"
								end)
							}

							t31.offset:depend({
								[1] = nil,
								[2] = "Default",
								[1] = p109
							})
							t31.left:depend({
								[1] = nil,
								[2] = "180° L/R",
								[1] = p109
							})
							t31.right:depend({
								[1] = nil,
								[2] = "180° L/R",
								[1] = p109
							})
							t31.delay:depend({
								[1] = nil,
								[2] = "180° L/R",
								[1] = p109
							})
							t31.variability:depend({
								[1] = nil,
								[2] = "180° L/R",
								[1] = p109
							})

							return t31
						end),
						modifier = v126.yaw:combo(v97("sparkles", "Modifier", 5), {
							[1] = "Disabled",
							[2] = "Center",
							[3] = "Offset",
							[4] = "Random",
							[5] = "Spin",
							[6] = "X-Way"
						}, function(_, p114)
							-- upvalues: v126 (copy), v97 (copy), v133 (copy), i (copy)
							local t32 = {
								offset = v126.yaw:slider("  \a4d4d4dff" .. v97("angles-right", "\rOffset", 3, true), -180, 180, 0, 1, "°"),
								ways = v126.yaw:slider("  \a4d4d4dff" .. v97("angles-right", "\rWays", 3, true), 3, 9, 3, 1, "w")
							}

							t32.offset:depend({
								[1] = v133,
								[2] = i
							}, {
								[1] = nil,
								[2] = "Disabled",
								[3] = true,
								[1] = p114
							})
							t32.ways:depend({
								[1] = v133,
								[2] = i
							}, {
								[1] = nil,
								[2] = "X-Way",
								[1] = p114
							})

							return t32
						end),
						desync = v126.desync:switch(v97("waveform-lines", "Body Yaw", 3), false, function(_, p116)
							-- upvalues: v126 (copy), v97 (copy), v133 (copy), i (copy)
							local t33 = {
								left = v126.desync:slider("  \a4d4d4dff" .. v97("angles-right", "\rLeft", 3, true), 0, 60, 0, 1, "°"),
								right = v126.desync:slider("  \a4d4d4dff" .. v97("angles-right", "\rRight", 3, true), 0, 60, 0, 1, "°"),
								freestanding = v126.desync:combo(v97("split", "Freestanding", 5), {
									[1] = "Off",
									[2] = "Peek Fake",
									[3] = "Peek Real"
								}),
								options = v126.desync:label(v97("spa", "Options", 4), function(p117)
									-- upvalues: v97 (copy)
									return {
										avoid_overlap = p117:switch(v97("diagram-venn", "Avoid Overlap", 3)),
										jitter = p117:switch(v97("tornado", "Jitter", 6)),
										randomize_jitter = p117:switch(v97("shuffle", "Randomize Jitter", 5)),
										anti_bruteforce = p117:switch(v97("shield-virus", "Anti Bruteforce", 5))
									}
								end)
							}

							t33.left:depend({
								[1] = v133,
								[2] = i
							}, {
								[1] = nil,
								[2] = true,
								[1] = p116
							})
							t33.right:depend({
								[1] = v133,
								[2] = i
							}, {
								[1] = nil,
								[2] = true,
								[1] = p116
							})
							t33.freestanding:depend({
								[1] = v133,
								[2] = i
							})
							t33.options:depend({
								[1] = v133,
								[2] = i
							})

							return t33
						end),
						defensive = v126.defensive:switch(v97("bug", "Enable", 5), false, function()
							-- upvalues: v126 (copy), v97 (copy), v133 (copy), i (copy)
							local t36 = {
								pitch = v126.defensive:combo(v97("hat-witch", "Pitch", 4), {
									[1] = "Disabled",
									[2] = "Down",
									[3] = "Up",
									[4] = "Random",
									[5] = "Jitter",
									[6] = "Custom"
								}, function(p118, p119)
									-- upvalues: v97 (copy), v133 (copy), i (copy)
									local t34 = {
										first = p118:slider(v97("up", "First", 3), -89, 89, 0, 1, "°"),
										second = p118:slider(v97("down", "Second", 3), -89, 89, 0, 1, "°"),
										amount = p118:slider(v97("angle", "Offset", 4), -89, 89, 0, 1, "°")
									}

									t34.amount:depend({
										[1] = v133,
										[2] = i
									}, {
										[1] = nil,
										[2] = "Custom",
										[1] = p119
									})
									t34.first:depend({
										[1] = v133,
										[2] = i
									}, {
										[1] = nil,
										[2] = "Random",
										[3] = "Jitter",
										[1] = p119
									})
									t34.second:depend({
										[1] = v133,
										[2] = i
									}, {
										[1] = nil,
										[2] = "Random",
										[3] = "Jitter",
										[1] = p119
									})

									return t34
								end),
								yaw = v126.defensive:combo(v97("scribble", "Yaw", 5), {
									[1] = "Disabled",
									[2] = "Forward",
									[3] = "Sideways",
									[4] = "Random",
									[5] = "Spin",
									[6] = "Center",
									[7] = "Custom"
								}, function(p120, p121)
									-- upvalues: v97 (copy), v133 (copy), i (copy)
									local t35 = {
										speed = p120:slider(v97("gauge", "Speed", 3), 1, 30, 3, 1, "t"),
										amount = p120:slider(v97("angle", "Offset", 4), -180, 180, 0, 1, "°")
									}

									t35.speed:depend({
										[1] = v133,
										[2] = i
									}, {
										[1] = nil,
										[2] = "Spin",
										[1] = p121
									})
									t35.amount:depend({
										[1] = v133,
										[2] = i
									}, {
										[1] = nil,
										[2] = "Custom",
										[3] = "Center",
										[1] = p121
									})

									return t35
								end)
							}

							t36.pitch:depend({
								[1] = v133,
								[2] = i
							})
							t36.yaw:depend({
								[1] = v133,
								[2] = i
							})

							return t36
						end)
					}

					builder[i] = t37
					t37.override:depend({
						[1] = v133,
						[2] = i
					})
					t37.yaw:depend({
						[1] = v133,
						[2] = i
					})
					t37.modifier:depend({
						[1] = v133,
						[2] = i
					})
					t37.desync:depend({
						[1] = v133,
						[2] = i
					})
					t37.defensive:depend({
						[1] = v133,
						[2] = i
					})

					if v == "Default" then
						t37.override:disabled(true)
					end

					t37.override:set_callback(function(p122)
						-- upvalues: v97 (copy), v (copy)
						p122:name(v97(p122:get() and "toggle-on" or "toggle-off", string.format("Override \v%s", v), 5))
					end, true)
				end

				v133:set_callback(function()
					-- upvalues: v133 (copy), builder (copy)
					local v651 = v133:get()

					for k, v in pairs(builder) do
						v.override:visibility(v651 == k)
						v.yaw:visibility(v651 == k)
						v.modifier:visibility(v651 == k)
						v.desync:visibility(v651 == k)
						v.defensive:visibility(v651 == k)
					end
				end, true)
				t30.state_selector = v133
				v126.state_selector:depend({
					[1] = nil,
					[2] = 2,
					[1] = v127
				})
				v126.yaw:depend({
					[1] = nil,
					[2] = 2,
					[1] = v127
				})
				v126.desync:depend({
					[1] = nil,
					[2] = 2,
					[1] = v127
				})
				v126.defensive:depend({
					[1] = nil,
					[2] = 2,
					[1] = v127
				})
				t27.anti_aimbot = t30
				t38 = {}

				local SETTINGS = t29.SETTINGS
				local TABS2 = SETTINGS.TABS
				local SECTIONS2 = SETTINGS.SECTIONS
				local ICON2 = SETTINGS.ICON

				v142 = pui.create(ICON2, SECTIONS2)
				v143 = v98(v142.tabs, TABS2)
				t39 = {}

				local style = v142.style
				local v146 = ui.get_style()

				t39.accent = style:color_picker(v97("palette", "Accent", 5), v146["Link Active"]:alpha_modulate(153))
				t39.glow = style:switch(v97("sparkles", "Glow", 5), true)
				t39.blur = style:switch(v97("waveform", "Blur", 3), true)
				t39.accent:set_callback(function(p123)
					-- upvalues: pui (copy)
					pui.accent = p123.value:alpha_modulate(255)
				end, true)
				style:depend({
					[1] = nil,
					[2] = 2,
					[1] = v143
				})
				t40 = {}

				local widgets = v142.widgets

				t40.watermark = widgets:label(v97("circle-nodes", "Watermark", 5), function(p124)
					-- upvalues: v97 (copy)
					return {
						fields = p124:listable(v97("list", "Fields", 3), {
							[1] = "User",
							[2] = "Time",
							[3] = "Ping"
						}),
						username = p124:input(v97("user-pen", "Custom Name", 3))
					}
				end)
				t40.keybinds = widgets:switch(v97("keyboard", "Keybinds", 4))
				t40.spectators = widgets:switch(v97("eye", "Spectators", 4))
				t40.velocity_warning = widgets:switch(v97("gauge-high", "Velocity Warning", 5))
				widgets:depend({
					[1] = nil,
					[2] = 2,
					[1] = v143
				})
				t41 = {}

				local indicators = v142.indicators

				t41.screen_indicator = indicators:switch(v97("sparkles", "Screen Indicator", 5), false, function(p125)
					-- upvalues: v97 (copy)
					return {
						glow = p125:switch(v97("sparkles", "Glow", 4), false)
					}
				end)
				t41.manual_arrows = indicators:switch(v97("left-right", "Manual Arrows", 5), false, function(p126)
					-- upvalues: v97 (copy)
					return {
						style = p126:combo(v97("pen-fancy-slash", "Style", 3), {
							[1] = "Classic",
							[2] = "Modern"
						})
					}, true
				end)
				t41.damage_indicator = indicators:switch(v97("burst", "Damage Indicator", 5), false, function(p127)
					-- upvalues: v97 (copy)
					return {
						animated = p127:switch(v97("bars-progress", "Animated", 4), true),
						small = p127:switch(v97("minimize", "Small", 4), false)
					}, true
				end)
				indicators:depend({
					[1] = nil,
					[2] = 2,
					[1] = v143
				})
				t42 = {}

				local in_game = v142.in_game

				t42.custom_scope = in_game:switch(v97("crosshairs", "Custom Scope", 3), false, function(p128)
					-- upvalues: v97 (copy)
					return {
						inverter = p128:switch(v97("palette", "Color", 4), false, color("#9CD1FFFF"), "Inverts color"),
						offset = p128:slider(v97("droplet", "Offset", 6), 10, 100, 10, 1),
						length = p128:slider(v97("brush", "Length", 6), 10, 100, 50, 1)
					}, true
				end)
				t42.aspect_ratio = in_game:switch(v97("expand", "Aspect Ratio", 4), false, function(p129)
					local t43 = {
						evaluate = p129:slider("", 0, 300, 0, 0.01, function(p130)
							return ({
								[0] = "Off",
								[1.33] = "4:3",
								[1.5] = "3:2",
								[1.25] = "5:4",
								[1.6] = "16:10",
								[1.78] = "16:9"
							})[p130 / 100] or nil
						end)
					}

					t43.button169 = p129:button("16:9", function()
						-- upvalues: t43 (copy)
						t43.evaluate:set(177.77777777777777)
					end, true)
					t43.button1610 = p129:button("16:10", function()
						-- upvalues: t43 (copy)
						t43.evaluate:set(160)
					end, true)
					t43.button32 = p129:button("3:2", function()
						-- upvalues: t43 (copy)
						t43.evaluate:set(150)
					end, true)
					t43.button43 = p129:button("4:3", function()
						-- upvalues: t43 (copy)
						t43.evaluate:set(133.33333333333331)
					end, true)
					t43.button54 = p129:button("5:4", function()
						-- upvalues: t43 (copy)
						t43.evaluate:set(125)
					end, true)

					return t43
				end)
				t42.viewmodel = in_game:switch(v97("hand", "Viewmodel", 3), false, function(p131)
					local t44 = {
						fov = p131:slider("Field of View", 0, 1000, cvar.viewmodel_fov:float() * 10, 0.1),
						x = p131:slider("X", -100, 100, cvar.viewmodel_offset_x:float() * 10, 0.1),
						y = p131:slider("Y", -100, 100, cvar.viewmodel_offset_y:float() * 10, 0.1),
						z = p131:slider("Z", -100, 100, cvar.viewmodel_offset_z:float() * 10, 0.1),
						opposite_knife_hand = p131:switch("Opposite Knife Hand", false)
					}

					t44.reset = p131:button("Reset", function()
						-- upvalues: t44 (copy)
						t44.fov:set(600)
						t44.x:set(10)
						t44.y:set(10)
						t44.z:set(15)
					end)

					return t44
				end)
				t42.skeet_indicators = in_game:switch(v97("circle", "\a43ff64d9$500\r Indicators", 3), false, function(p132)
					return {
						selected = p132:listable("##SELECTED", {
							[1] = "Safe Points",
							[2] = "Double Tap",
							[3] = "Hide Shots",
							[4] = "Fake Duck",
							[5] = "Body Aim",
							[6] = "Minimum Damage",
							[7] = "Dormant Aimbot",
							[8] = "Freestanding",
							[9] = "Fake Latency",
							[10] = "Bomb Info",
							[11] = "Hit Rate"
						})
					}
				end)
				t42.keep_transparency = in_game:switch(v97("face-dotted", "Keep Model Transparency", 3))
				in_game:depend({
					[1] = nil,
					[2] = 2,
					[1] = v143
				})
				t45 = {}

				local features = v142.features

				t45.grenade_features = features:switch(v97("bomb", "Grenade features", 5), false, function(p133)
					-- upvalues: v97 (copy)
					return {
						throw_fix = p133:switch(v97("explosion", "Throw fix", 3), false),
						super_toss = p133:switch(v97("superpowers", "Super toss", 5), false),
						auto_release = p133:switch(v97("hand", "Auto release", 4), false),
						damage = p133:slider(v97("heart-crack", "Damage", 4), 1, 99, 30, nil, "hp"),
						molotov = p133:switch(v97("fire-flame", "Molotov", 5), false)
					}
				end)
				t45.no_fall_damage = features:switch(v97("person-falling", "No fall damage", 6))
				t45.fast_ladder = features:switch(v97("water-ladder", "Fast ladder", 4))
				t45.game_focus = features:switch(v97("gamepad", "Game focus", 3), false, function(p134)
					-- upvalues: v97 (copy)
					return {
						flash = p134:switch(v97("bolt", "Flash window", 5), true),
						focus = p134:switch(v97("expand", "Auto focus", 4), false)
					}
				end)
				features:depend({
					[1] = nil,
					[2] = 3,
					[1] = v143
				})
				t46 = {}

				local shared = v142.shared

				t46.icon = shared:switch(v97("rectangle-ad", "Shared icon", 4), false, "\n\affffffff\f<atom>\r - User\n\n\aFFC78FFF\f<atom>\r - Developer")
				shared:depend({
					[1] = nil,
					[2] = 3,
					[1] = v143
				})
				t47 = {}

				local other3 = v142.other

				t47.fake_duck = other3:selectable(v97("duck", "Fake duck", 6), {
					[1] = "Unlock speed",
					[2] = "Freeze time"
				})
				t47.air_collision = other3:switch(v97("wind", "Air collision", 6))
				t47.unlock_latency = other3:switch(v97("timer", "Unlock latency", 6))
				t47.edge_stop = other3:switch(v97("arrow-down-up-lock", "Edge Stop", 4))
				other3:depend({
					[1] = nil,
					[2] = 3,
					[1] = v143
				})
				t48 = {}

				local cache = v142.cache

				t48.align_wm = cache:value("##watermark align", 2)
				t48.pos_x_wm = cache:value("##watermark x pos", 0)
			end

			local t49 = {}
			local ragebot = v142.ragebot

			t49.peek_assist = ragebot:switch(v97("circle-dashed", "Peek Assist", 4), false, function(p135)
				-- upvalues: v97 (copy)
				return {
					behaviors = p135:selectable(v97("sliders-simple", "Behaviors", 3), {
						[1] = "Quick Peek",
						[2] = "Edge Stop",
						[3] = "Extended Backtrack",
						[4] = "Freestanding"
					})
				}
			end)
			t49.dormant_aimbot = ragebot:switch(v97("eye-low-vision", "Dormant aimbot", 2), false, function(p136)
				-- upvalues: v97 (copy)
				return {
					hitboxes = p136:selectable(v97("layer-group", "Hitboxes", 4), {
						[1] = "Head",
						[2] = "Chest",
						[3] = "Stomach"
					}),
					accuracy = p136:slider(v97("microscope", "Accuracy", 4), 35, 100, 75, nil, "%"),
					damage = p136:slider(v97("claw-marks", "Min. Damage", 3), 1, 126, 10, nil, function(p137)
						if p137 ~= 1 then
							if not (p137 > 100) then
								return p137
							end

							return string.format("HP+ %i", p137 - 100)
						end

						return "Inherited"
					end),
					auto_scope = p136:switch(v97("crosshairs-simple", "Auto scope", 4))
				}
			end)
			t49.logs = ragebot:switch(v97("terminal", "Logs", 3), true, function(p138)
				-- upvalues: v97 (copy), pui (copy)
				return {
					clr = p138:color_picker(v97("palette", "Accent", 3), {
						Miss = {
							[1] = pui.colors.miss
						},
						Hit = {
							[1] = pui.colors.hit
						}
					}),
					display = p138:selectable(v97("desktop", "Display", 2), {
						[1] = "Screen",
						[2] = "Events",
						[3] = "Console"
					})
				}, true
			end)
			t49.decrase_hold_aim_ticks = ragebot:switch(v97("crosshairs", "Decrase hold aim ticks", 4))
			t49.decrase_hold_aim_ticks:set_callback(function(p139)
				cvar.sv_maxusrcmdprocessticks_holdaim:int(p139:get() and 0 or 1)
			end)
			events.shutdown:set(function()
				cvar.sv_maxusrcmdprocessticks_holdaim:int(1)
			end)
			ragebot:depend({
				[1] = nil,
				[2] = 1,
				[1] = v143
			})
			t38.widgets = t40
			t38.in_game = t42
			t38.indicators = t41
			t38.features = t45
			t38.shared = t46
			t38.other = t47
			t38.cache = t48
			t38.style = t39
			t38.rage = t49
			t27.settings = t38
			utils.execute_after(0.1, pui.setup, t27)
			t50 = {}

			local t51 = {
				sended = 0,
				yaw = {
					[0] = "Disabled",
					switch_side = false,
					avoid_backstab = false,
					next_switch = 0,
					offset = 0,
					base = "Local View",
					hidden = false
				},
				yaw_modifier = {
					[0] = "Disabled",
					offset = 0
				},
				body_yaw = {
					[0] = false,
					inverter = false,
					freestanding = "Off",
					right_limit = 0,
					left_limit = 0,
					options = {}
				}
			}
			local anti_aimbot = t27.anti_aimbot
			local u166 = false
			local u167 = false
			local v168 = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk")
			local v169 = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck")

			local function v170(p140, p141)
				-- upvalues: t51 (copy)
				local v673 = t51.sended % p140
				local v674 = math.floor(p140 * 0.5)

				if v674 <= v673 then
					if p140 % 2 == 0 then
						v673 = v673 + 1
					end

					if v673 == v674 then
						return 0
					end
				end

				local v675 = (v673 - v674) / v674

				return (math.floor(p141 * v675))
			end

			function t50.get_statement()
				-- upvalues: u166 (ref), u167 (ref), v168 (copy), v169 (copy)
				local v676 = entity.get_local_player()

				if v676 and v676:is_alive() then
					local m_fFlags = v676.m_fFlags
					local v678 = v676.m_vecVelocity:length()
					local v679 = bit.band(m_fFlags, 2) == 2
					local v680 = u166 or bit.band(m_fFlags, 1) ~= 1
					local v681 = u167 or v168:get()

					if not v680 then
						if not v679 and not v169:get() then
							if not (v678 > 2) then
								return 2
							end

							return v681 and 4 or 3
						end

						return v678 > 2 and 6 or 5
					end

					return v679 and 8 or 7
				end

				return 1
			end

			local t52 = {
				enabled = pui.find("Aimbot", "Anti Aim", "Angles", "Enabled"),
				yaw = pui.find("Aimbot", "Anti Aim", "Angles", "Yaw", {
					base = "Base",
					avoid_backstab = "Avoid Backstab",
					hidden = "Hidden",
					offset = "Offset"
				}),
				yaw_modifier = pui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", {
					offset = "Offset"
				}),
				body_yaw = pui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", {
					options = "Options",
					inverter = "Inverter",
					freestanding = "Freestanding",
					right_limit = "Right Limit",
					left_limit = "Left Limit"
				}),
				freestanding = pui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", {
					body_freestanding = "Body Freestanding",
					disable_yaw_modifiers = "Disable Yaw Modifiers"
				})
			}

			local function v172()
				-- upvalues: anti_aimbot (copy), v169 (copy), t51 (copy)
				local v682 = entity.get_local_player()

				if v682 and v682:is_alive() then
					local v683 = v682:get_eye_position()
					local edge_yaw = anti_aimbot.general.edge_yaw
					local v685 = edge_yaw.while_fd:get() and v169:get()

					if not edge_yaw:get() and not v685 then
						return
					end

					local v686 = nil
					local huge = math.huge

					for i = 30, 360, 30 do
						local v689 = math.normalize_yaw(i)
						local v690 = v683 + vector():angles(0, v689) * 1000
						local v691 = utils.trace_line(v683, v690, v682)
						local v692 = v691.start_pos:dist(v691.end_pos)

						if v692 < huge then
							huge = v692
							v686 = i
						end
					end

					if v686 then
						t51.yaw[0] = "Static"
						t51.yaw.offset = v686
						t51.body_yaw[0] = false
						t51.yaw_modifier[0] = "Disabled"
					end

					return true
				end
			end
			local function v173(p142)
				-- upvalues: v172 (copy), anti_aimbot (copy), t51 (copy)
				local v694 = v172()
				local manual_yaw = anti_aimbot.general.manual_yaw
				local v696 = manual_yaw:get()
				local freestanding = anti_aimbot.general.freestanding

				if not v694 then
					if v696 == "Disabled" then
						if (freestanding:get() or freestanding:get_override()) and rage.antiaim:get_target(true) and p142:get("Freestanding") then
							t51.yaw[0] = "Backward"
							t51.yaw.offset = 0
							t51.body_yaw[0] = true
							t51.body_yaw.left_limit = 60
							t51.body_yaw.right_limit = 60
							t51.yaw_modifier[0] = "Disabled"
						end
					else
						local t53 = {
							Left = -90,
							Backward = 0,
							Forward = 180,
							Right = 90
						}

						t51.yaw.base = manual_yaw.yaw_base:get()

						if not p142:get("Manual Yaw") then
							t51.yaw.offset = t51.yaw.offset + (t53[v696] or 0)
						else
							t51.yaw[0] = "Backward"
							t51.yaw.offset = t53[v696] or 0
							t51.body_yaw[0] = true
							t51.body_yaw.left_limit = 60
							t51.body_yaw.right_limit = 60
							t51.yaw_modifier[0] = "Disabled"
						end
					end

					return
				end
			end
			local function v174(p143)
				if not entity.get_game_rules().m_bWarmupPeriod or not p143.warmup:get() then
					local t54 = {}

					entity.get_players(true, true, function(p144)
						-- upvalues: t54 (copy)
						if p144:is_alive() then
							t54[#t54 + 1] = p144
						end
					end)

					if #t54 ~= 0 or not p143.no_enemy:get() then
						return
					end

					return true
				end

				return true
			end
			local function v175(p145)
				-- upvalues: t51 (copy)
				local options = p145.options

				t51.body_yaw[0] = p145:get()
				t51.body_yaw.left_limit = p145.left:get()
				t51.body_yaw.right_limit = p145.right:get()
				t51.body_yaw.options = {
					[1] = options.avoid_overlap:get() and "Avoid Overlap" or "",
					[2] = options.jitter:get() and "Jitter" or "",
					[3] = options.randomize_jitter:get() and "Randomize Jitter" or "",
					[4] = options.anti_bruteforce:get() and "Anti Bruteforce" or ""
				}
				t51.body_yaw.freestanding = p145.freestanding:get()
			end
			local function v176(p146)
				-- upvalues: t51 (copy), v170 (copy)
				if p146:get() ~= "X-Way" then
					t51.yaw_modifier[0] = p146:get()
					t51.yaw_modifier.offset = p146.offset:get()
				else
					t51.yaw_modifier[0] = "Disabled"

					local v704 = p146.ways:get()
					local v705 = p146.offset:get()

					t51.yaw.offset = math.normalize_yaw(t51.yaw.offset + v170(v704, v705) * 0.5)
				end
			end
			local function v177(p147, p148)
				if not (p147 <= 0) then
					local v708 = math.abs(p148) * (p147 / 100)

					return p148 + (math.random() * 2 - 1) * v708
				end

				return p148
			end
			local function v178(p149)
				-- upvalues: t51 (copy), v177 (copy), v22 (copy)
				t51.yaw[0] = "Backward"
				t51.yaw.base = "At Target"

				local v710 = p149.randomize:get()
				local v711 = p149.left:get()
				local v712 = p149.right:get()

				if p149:get() ~= "180° L/R" then
					t51.yaw.offset = v177(v710, p149.offset:get())
				else
					local v713 = p149.delay:get()

					if not (v713 > 1) then
						t51.yaw.offset = rage.antiaim:inverter() and v177(v710, v711) or v177(v710, v712)
					else
						if t51.sended >= t51.yaw.next_switch then
							t51.yaw.switch_side = not t51.yaw.switch_side

							local v714 = p149.variability:get()
							local v715 = v177(v714, v713)

							t51.yaw.next_switch = t51.sended + math.max(1, v715)
						end

						t51.yaw.offset = t51.yaw.switch_side and v177(v710, v711) or v177(v710, v712)

						if v22(t51.body_yaw.options, "Jitter") then
							rage.antiaim:inverter(t51.yaw.switch_side)
						end
					end
				end
			end
			local function v179(p150, p151, _, p153)
				-- upvalues: t18 (copy), t51 (copy)
				local v720 = p150.conditions:get(p153)
				local v721 = t18.ragebot.hide_shots:get() or t18.ragebot.hide_shots:get_override()
				local v722 = p150.compatible_with_hide_shots:get()
				local v723 = p151:get()
				local s9 = nil
				local s10 = nil

				if v720 then
					if not v721 then
						s9 = "Always On"
					end

					if v722 and v721 then
						s10 = "Break LC"
					end
				end

				t51.yaw.hidden = (s9 ~= nil or s10 ~= nil) and (v720 and v723)
				t18.ragebot.double_tap.lag_options:override(s9)
				t18.ragebot.hide_shots.options:override(s10)
			end
			local function v180(p154, _, p156)
				-- upvalues: t18 (copy), u87 (ref), t51 (copy)
				local v729 = t18.ragebot.double_tap:get() or t18.ragebot.hide_shots:get() and (t18.ragebot.hide_shots.options:get() == "Break LC" or t18.ragebot.hide_shots.options:get_override() == "Break LC")

				if p154:get() and v729 then
					if not u87 then
						return
					end

					t51.body_yaw[0] = true
					t51.body_yaw.inverter = false
					t51.body_yaw.left_limit = 0
					t51.body_yaw.right_limit = 0
					t51.body_yaw.options = {}
					t51.body_yaw.freestanding = "Off"

					if p154.yaw:get() ~= "Disabled" then
						t51.yaw.offset = 0
						t51.yaw_modifier[0] = "Disabled"
					end

					local v730 = p154.pitch:get()
					local v731

					if v730 ~= "Custom" then
						if v730 ~= "Random" then
							if v730 ~= "Jitter" then
								v731 = ({
									Up = -89,
									Down = 89,
									Disabled = 89
								})[v730] or 89
							else
								v731 = p156 and p154.pitch.second:get() or p154.pitch.first:get()
							end
						else
							local v732 = p154.pitch.first:get()
							local v733 = p154.pitch.second:get()

							v731 = math.random(math.min(v732, v733), math.max(v732, v733))
						end
					else
						v731 = p154.pitch.amount:get()
					end

					rage.antiaim:override_hidden_pitch(v731)

					local v734 = p154.yaw:get()
					local v735 = p154.yaw.amount:get()

					if v734 ~= "Forward" then
						if v734 ~= "Custom" then
							if v734 ~= "Sideways" then
								if v734 ~= "Random" then
									if v734 ~= "Center" then
										if v734 ~= "Spin" then
											v735 = 0
										else
											if not t51.spin_yaw then
												t51.spin_yaw = 0
											end

											t51.spin_yaw = (t51.spin_yaw + 180 * (p154.yaw.speed:get() / 10)) % 360
											v735 = t51.spin_yaw
										end
									else
										v735 = p156 and -v735 * 0.5 or v735 * 0.5
									end
								else
									v735 = math.random(-180, 180)
								end
							else
								v735 = p156 and 90 or -90
							end
						end
					else
						v735 = 180
					end

					rage.antiaim:override_hidden_yaw_offset(v735)

					return
				end
			end
			local function v181()
				-- upvalues: anti_aimbot (copy), v22 (copy), t18 (copy), t50 (copy)
				local v736 = nil
				local v737 = anti_aimbot.other.fakelag_disablers:get()

				if not v22(v737, "Double Tap") or not t18.ragebot.double_tap:get() then
					if not v22(v737, "Hide Shots") or not t18.ragebot.hide_shots:get() then
						if v22(v737, "Standing") and t50.get_statement() == 2 then
							v736 = false
						end
					else
						v736 = false
					end
				else
					v736 = false
				end

				t18.anti_aim.fake_lag.enabled:override(v736)
			end
			local function v182()
				-- upvalues: anti_aimbot (copy), t3 (copy), t50 (copy), t51 (copy)
				local safe_head = anti_aimbot.general.safe_head
				local weapon = safe_head.weapon
				local v740 = safe_head.height_difference:get()

				if safe_head:get() then
					local v741 = entity.get_local_player()

					if v741 and v741:is_alive() then
						local v742 = v741:get_player_weapon()

						if v742 then
							local v743 = v742:get_classid()
							local v744 = false

							if not weapon:get("Knife") or v743 ~= 107 then
								if weapon:get("Zeus") and v743 == 268 then
									v744 = true
								end
							else
								v744 = true
							end

							if not t3[t50.get_statement()]:find("In Air") then
								v744 = false
							end

							local v745 = entity.get_threat()

							if v745 then
								local v746 = v741:get_eye_position()
								local v747 = v745:get_eye_position()
								local v748 = v746.z - v747.z

								if v740 > 0 and v748 < v740 then
									v744 = false
								end

								if v744 then
									t51.yaw[0] = "Backward"
									t51.yaw.base = "At Target"
									t51.yaw.offset = -18
									t51.yaw.hidden = false
									t51.yaw_modifier[0] = "Disabled"
									t51.body_yaw[0] = true
									t51.body_yaw.inverter = true
									t51.body_yaw.left_limit = 60
									t51.body_yaw.right_limit = 60
									t51.body_yaw.options = {}
									t51.body_yaw.freestanding = "Off"
								end

								return
							end

							return
						end

						return
					end

					return
				end
			end

			local t55 = {}
			local animation_breaker = anti_aimbot.other.animation_breaker
			local leg_movement = t18.anti_aim.other.leg_movement
			local t56 = {}
			local t57 = {}

			local function v188(p157, p158, p159)
				-- upvalues: leg_movement (copy)
				leg_movement:override()

				if p157 ~= "Falling" then
					if p157 ~= "Jitter legs" then
						if p157 ~= "Follow direction" then
							if p157 ~= "Moon walk" then
								if p157 ~= "Walking" then
									if p157 == "Kangaroo" then
										p159[3] = math.random()
										p159[7] = math.random()
										p159[6] = math.random()
									end
								else
									p158[6].m_flWeight = 1.5
								end
							else
								leg_movement:override("Walking")
								p159[7] = 0
							end
						else
							leg_movement:override("Sliding")
							p159[0] = 1
						end
					else
						leg_movement:override("Sliding")
						p159[0] = utils.random_float(0.1, 0.9)
					end
				else
					p159[6] = 1
				end
			end
			local function v189(p160, p161, p162)
				if p160.m_vecVelocity:length2d() > 3.3 then
					p161[12].m_flWeight = p162 * 0.1
				end
			end
			local function v190(p163, p164, p165, p166)
				-- upvalues: t56 (copy), t57 (copy)
				for i = 0, 12 do
					local v760 = p164[i]
					local v761 = p165 * (t56[i] or 0) + p166 * v760

					t56[i] = v761
					p164[i] = v761
				end

				for i = 0, 12 do
					local v763 = p163[i]

					if v763 then
						local m_flWeight = v763.m_flWeight
						local v765 = p165 * (t57[i] or 0) + p166 * m_flWeight

						t57[i] = v765
						v763.m_flWeight = v765
					end
				end
			end

			function t55.post_anim_update(p167)
				-- upvalues: animation_breaker (copy), leg_movement (copy), t3 (copy), t50 (copy), v189 (copy), v190 (copy), v188 (copy)
				if animation_breaker:get() then
					local v767 = entity.get_local_player()

					if v767 and v767:is_alive() then
						if globals.curtime - to_time(v767.m_nTickBase) == 0 then
							if p167:get_index() == v767:get_index() then
								local v768 = ffi.cast("uintptr_t", v767[0])
								local v769 = ffi.cast("CAnimationLayer**", v768 + 10640)[0]
								local v770 = animation_breaker.leaning:get()
								local v771 = animation_breaker.interpolation:get()
								local v772 = t3[t50.get_statement()]:find("Air") and animation_breaker.air:get() or animation_breaker.ground:get()

								v189(v767, v769, v770)

								if v771 > 0 then
									local v773 = globals.tickinterval * v771
									local v774 = 1 - v773
									local m_flPoseParameter = v767.m_flPoseParameter

									v190(v769, m_flPoseParameter, v773, v774)
								end

								v188(v772, v769, v767.m_flPoseParameter)

								return
							end

							return
						end

						return
					end

					return
				end

				leg_movement:override()
			end
			function t50.post_update_clientside_animation(p168)
				-- upvalues: t55 (copy)
				t55.post_anim_update(p168)
			end
			function t50.render()
			end
			function t50.shutdown()
				-- upvalues: t18 (copy)
				t18.anti_aim.other.leg_movement:override()
			end
			function t50.createmove(p169)
				-- upvalues: u166 (ref), u167 (ref), t51 (copy), t50 (copy), anti_aimbot (copy), v175 (copy), v178 (copy), v176 (copy), v173 (copy), v179 (copy), v180 (copy), v181 (copy), v182 (copy), t52 (copy), v174 (copy)
				u166 = p169.in_jump
				u167 = p169.in_speed

				if p169.choked_commands == 0 then
					t51.sended = t51.sended + 1
				end

				local v778 = t50.get_statement()
				local v779 = anti_aimbot.builder[v778].override:get() and anti_aimbot.builder[v778] or anti_aimbot.builder[1]
				local v780 = t51.sended % 2 == 0

				v175(v779.desync)
				v178(v779.yaw)
				v176(v779.modifier)
				v173(anti_aimbot.other.static_yaw)
				v179(anti_aimbot.other.defensive, v779.defensive, p169, v778 - 1)
				v180(v779.defensive, p169, v780)
				v181()
				v182()
				t52.enabled:override(not v174(anti_aimbot.other.disablers))
				t52.yaw:override(t51.yaw[0])
				t52.yaw.base:override(t51.yaw.base)
				t52.yaw.offset:override(t51.yaw.offset)
				t52.yaw.avoid_backstab:override(anti_aimbot.general.avoid_backstab:get())
				t52.yaw.hidden:override(t51.yaw.hidden)
				t52.yaw_modifier:override(t51.yaw_modifier[0])
				t52.yaw_modifier.offset:override(t51.yaw_modifier.offset)
				t52.body_yaw:override(t51.body_yaw[0])
				t52.body_yaw.inverter:override(t51.body_yaw.inverter)
				t52.body_yaw.left_limit:override(t51.body_yaw.left_limit)
				t52.body_yaw.right_limit:override(t51.body_yaw.right_limit)
				t52.body_yaw.options:override(t51.body_yaw.options)
				t52.body_yaw.freestanding:override(t51.body_yaw.freestanding)
				p169.jitter_move = anti_aimbot.general.jitter_move:get()

				local v781 = anti_aimbot.general.freestanding:get() or anti_aimbot.general.freestanding:get_override()

				if anti_aimbot.general.manual_yaw:get() ~= "Disabled" and anti_aimbot.other.static_yaw:get("Manual Yaw") then
					v781 = false
				end

				t52.freestanding:override(v781)
			end
		end

		t58 = {}
		settings = t27.settings

		local style = settings.style

		function v194(p170)
			-- upvalues: pui (copy)
			local v793 = pui.get_binds()

			for i = 1, #v793 do
				local v795 = v793[i]

				if v795.active and p170 == v795.name then
					return true
				end
			end

			return false
		end

		v195 = render.load_font("Trebuc", 13, "ad")

		local v196 = render.load_font("Trebuc", 20, "ad")

		n17 = 5

		local n18 = 3
		local n19 = 0.5

		function u200(p171, p172, p173, p174, p175)
			-- upvalues: style (copy), n19 (copy), n18 (copy)
			if style.blur:get() then
				render.blur(p171, p171 + p172, n19, p173 / 255, n18)
			end

			render.rect(p171, p171 + p172, color(0, 0, 0, p173 * p175), n18)

			local x = p172.x
			local v802 = vector(2, p172.y - 8)
			local v803 = p171 + vector(-1, 4)

			if style.glow:get() then
				render.shadow(v803, v803 + v802, p174:alpha_modulate(p173))
			end

			render.rect(v803, v803 + v802, p174:alpha_modulate(p173), n18)

			local v804 = p171 + vector(x - 1, 4)

			if style.glow:get() then
				render.shadow(v804, v804 + v802, p174:alpha_modulate(p173))
			end

			render.rect(v804, v804 + v802, p174:alpha_modulate(p173), n18)
		end

		t59 = {}

		local widgets = settings.widgets
		local cache = settings.cache
		local watermark = widgets.watermark
		local n20 = 10
		local v206 = smoothy.new(0)
		local v207 = smoothy.new(54 + n17 * 2)
		local v208 = t9.new("Watermark"):set_pos(vector(v28.x - n20, n20)):update(true)

		v208.align = cache.align_wm.value or 0

		local u209 = cache.pos_x_wm.value ~= 0 and cache.pos_x_wm.value or v208.pos.x

		function v208.on_dragging(p176)
			-- upvalues: u209 (ref), cache (copy)
			u209 = p176.pos.x
			p176.align = 0
			cache.align_wm:set(0)
		end
		function v208.on_release(p177)
			-- upvalues: v28 (copy), u209 (ref), cache (copy)
			local v808 = v28.x / 3
			local v809 = u209 + p177.size.x * 0.5
			local v810 = math.floor(v809 / v808)

			if v810 ~= p177.align then
				p177.align = v810

				if p177.align ~= 1 then
					if p177.align == 2 then
						u209 = u209 + p177.size.x
					end
				else
					u209 = u209 + p177.size.x * 0.5
				end

				cache.align_wm:set(p177.align)
				cache.pos_x_wm:set(u209)
			end
		end
		function v208.render_callback(p178)
			-- upvalues: v206 (copy), v208 (copy), style (copy), t2 (copy), watermark (copy), pui (copy), v195 (copy), v207 (copy), n17 (copy), u209 (ref), u200 (ref), v28 (copy), n20 (copy)
			local pos = p178.pos

			v206:update(0.05, 255)
			v208.is_active = not (v206.value <= 1)

			if not (v206.value <= 1) then
				local value = v206.value
				local v814 = style.accent:get()
				local v815 = v814.a / 255
				local v816 = v814:alpha_modulate(255)
				local t60 = { string.format("\a%s\f<%s>\r %s", v816:to_hex(), t2.icon, t2.name) }

				if watermark.fields:get("User") then
					local v818 = watermark.username:get():match("^%s*(.*%S)%s*$") or ""
					local v819 = #v818 > 0 and v818 or common.get_username()

					table.insert(t60, string.format("\a%s\f<user>\r %s", v816:to_hex(), v819))
				end

				if watermark.fields:get("Ping") and globals.is_connected then
					local v820 = math.floor(utils.net_channel().avg_latency[1] * 1000 + 0.5)

					table.insert(t60, string.format("\a%s\f<wifi>\r %sms", v816:to_hex(), v820))
				end

				if watermark.fields:get("Time") then
					table.insert(t60, string.format("\a%s\f<clock>\r %s", v816:to_hex(), string.lower(common.get_date("%I:%M %p", common.get_unixtime()))))
				end

				local v821 = pui.string(table.concat(t60, " "))
				local v822 = render.measure_text(v195, nil, v821)

				v207:update(0.05, v822.x + n17 * 2)

				local value2 = v207.value
				local v824 = v822.y + n17 * 1.5
				local v825 = vector(value2, v824)

				if p178.align ~= 1 then
					if p178.align == 2 then
						p178.pos.x = u209 - value2
					end
				else
					p178.pos.x = u209 - value2 * 0.5
				end

				u200(pos, v825, value, v816, v815)
				render.push_clip_rect(pos, pos + v825)
				render.text(v195, pos + v825 * 0.5, color(255, value), "c", v821)
				render.pop_clip_rect()
				p178:set_rules({
					[1] = {
						horizontal = true,
						pos = vector(v28.x / 2, v28.y / 2)
					},
					[2] = {
						horizontal = true,
						pos = vector(v825.x * 0.5 + n20, v28.y / 2)
					},
					[3] = {
						horizontal = true,
						pos = vector(v28.x - (v825.x * 0.5 + n20), v28.y / 2)
					},
					[4] = {
						horizontal = false,
						pos = vector(0, v28.y * 0.5)
					},
					[5] = {
						horizontal = false,
						pos = vector(v28.x / 2, v825.y * 0.5 + n20)
					},
					[6] = {
						horizontal = false,
						pos = vector(v28.x / 2, v28.y - v825.y * 0.5 - n20)
					}
				})
				p178:set_size(v825)

				return
			end
		end

		local keybinds = widgets.keybinds
		local n21 = 18
		local n22 = 2
		local n23 = 120
		local n24 = 22
		local v215 = smoothy.new(0)
		local v216 = smoothy.new(n23)
		local v217 = smoothy.new(0)
		local v218 = t9.new("Keybinds"):set_pos(vector(v28.x - 140, 80)):update(true)

		local function v219(p179)
			local value = p179.value
			local mode = p179.mode

			if type(value) ~= "boolean" then
				if type(value) ~= "table" then
					return tostring(value)
				end

				return table.concat(value, ", ")
			end

			return mode == 1 and "hold" or "toggle"
		end
		local function v220()
			-- upvalues: pui (copy), t8 (copy), v219 (copy)
			local v829 = pui.get_binds()
			local t61 = {}

			for _, v in pairs(v829) do
				local v833 = t8.new(v.name .. " / keybinds", 0):update(0.05, v.active and 1 or 0)

				if v833.value > 0.1 then
					t61[#t61 + 1] = {
						name = v.name,
						value = v219(v),
						anim = v833.value
					}
				end
			end

			return t61, not (#t61 < 1)
		end

		function v218.render_callback(p180)
			-- upvalues: v220 (copy), keybinds (copy), v215 (copy), v218 (copy), style (copy), n23 (copy), v195 (copy), n17 (copy), v216 (copy), pui (copy), n24 (copy), u200 (ref), n21 (copy), n22 (copy), v217 (copy), n19 (copy), n18 (copy), floor (copy), v24 (copy)
			local pos = p180.pos
			local v836, v837 = v220()
			local v838 = keybinds:get() and (v837 or not (ui.get_alpha() <= 0))

			v215:update(0.05, v838 and 255 or 0)
			v218.is_active = not (v215.value <= 1)

			if not (v215.value <= 1) then
				local value = v215.value
				local v840 = style.accent:get()
				local v841 = v840.a / 255
				local v842 = n23

				for _, v in ipairs(v836) do
					local v845 = render.measure_text(v195, nil, v.name).x + render.measure_text(v195, nil, v.value).x + n17 * 4

					if v842 < v845 then
						v842 = v845
					end
				end

				v216:update(0.05, v842)

				local v846 = math.ceil(v216.value)
				local v847 = pui.string(string.format("\a%s\f<keyboard> \rkeybinds", style.accent:get():alpha_modulate(value):to_hex()))
				local v848 = vector(v846, n24)

				u200(pos, v848, value, v840, v841)
				render.text(v195, pos + v848 * 0.5, color(255, value), "c", v847)

				local n25 = 0
				local v850 = pos + vector(0, n24 + 1)
				local n26 = 0

				for _, v in ipairs(v836) do
					n26 = n26 + (n21 + n22) * v.anim
				end

				v217:update(0.05, math.ceil(n26))

				local v854 = math.ceil(v217.value)

				if v854 > 0 then
					local v855 = vector(v846, v854 + n17)

					if style.blur:get() then
						render.blur(v850, v850 + v855, n19, value / 255, n18)
					end

					render.rect(v850, v850 + v855, color(0, 0, 0, value * v841 * 0.7), n18)
				end

				for _, v in ipairs(v836) do
					local v858 = value * v.anim
					local v859 = floor(n25)
					local v860 = tostring(v.value):lower()

					render.text(v195, v850 + vector(n17, v859 + n17), color(255, v858), nil, v24(v.name))

					local x = render.measure_text(v195, nil, v860).x

					render.text(v195, v850 + vector(v846 - n17 - x, v859 + n17), color(180, 180, 180, v858), nil, v860)
					n25 = n25 + (n21 + n22) * v.anim
				end

				p180:set_size(vector(v846, n24 + 1 + v854 + n17))

				return
			end
		end

		local t62 = {}
		local spectators = widgets.spectators
		local n27 = 18
		local n28 = 2
		local n29 = 120
		local n30 = 22
		local v227 = smoothy.new(0)
		local v228 = smoothy.new(n29)
		local v229 = smoothy.new(0)
		local v230 = t9.new("Spectators"):set_pos(vector(v28.x - 140, 200)):update(true)

		local function v231()
			-- upvalues: t8 (copy)
			local v862 = entity.get_local_player()

			if v862 then
				local v863 = v862.m_hObserverTarget and (v862.m_iObserverMode == 4 or v862.m_iObserverMode == 5) and v862.m_hObserverTarget or v862
				local t63 = {}

				entity.get_players(false, false, function(p181)
					-- upvalues: v863 (copy), v862 (copy), t8 (copy), t63 (copy)
					local v1350 = p181:get_player_info()
					local v1351 = p181.m_hObserverTarget == v863 and (p181.m_iObserverMode == 4 or (p181.m_iObserverMode == 5 or v1350.is_fake_player))
					local v1352 = not p181:is_alive() and (p181 ~= v862 and v1351)
					local v1353 = t8.new(p181:get_index() .. " / spectators", 0):update(0.05, v1352 and 1 or 0)

					if v1353.value > 0.1 then
						t63[#t63 + 1] = {
							name = p181:get_name(),
							avatar = p181:get_steam_avatar(),
							anim = v1353.value
						}
					end
				end)

				return t63, not (#t63 < 1)
			end

			return {}, false
		end

		function t62.level_init()
			-- upvalues: t8 (copy)
			t8.clear(" / spectators")
		end
		function t62.level_shutdown()
			-- upvalues: t8 (copy)
			t8.clear(" / spectators")
		end
		function v230.render_callback(p182)
			-- upvalues: v231 (copy), spectators (copy), v227 (copy), v230 (copy), style (copy), n29 (copy), v195 (copy), n17 (copy), v228 (copy), pui (copy), n30 (copy), u200 (ref), n27 (copy), n28 (copy), v229 (copy), n19 (copy), n18 (copy), floor (copy)
			local pos = p182.pos
			local v867, v868 = v231()
			local v869 = spectators:get() and (v868 or not (ui.get_alpha() <= 0))

			v227:update(0.05, v869 and 255 or 0)
			v230.is_active = not (v227.value <= 1)

			if not (v227.value <= 1) then
				local value = v227.value
				local v871 = style.accent:get()
				local v872 = v871.a / 255
				local n31 = 14
				local v874 = n29

				for _, v in ipairs(v867) do
					local v877 = render.measure_text(v195, nil, v.name).x + (v.avatar and n31 + n17 or 0) + n17 * 3

					if v874 < v877 then
						v874 = v877
					end
				end

				v228:update(0.05, v874)

				local v878 = math.ceil(v228.value)
				local v879 = pui.string(string.format("\a%s\f<eye> \rspectators", style.accent:get():alpha_modulate(value):to_hex()))
				local v880 = vector(v878, n30)

				u200(pos, v880, value, v871, v872)
				render.text(v195, pos + v880 * 0.5, color(255, value), "c", v879)

				local n32 = 0
				local v882 = pos + vector(0, n30 + 1)
				local n33 = 0

				for _, v in ipairs(v867) do
					n33 = n33 + (n27 + n28) * v.anim
				end

				v229:update(0.05, math.ceil(n33))

				local v886 = math.ceil(v229.value)

				if v886 > 0 then
					local v887 = vector(v878, v886 + n17)

					if style.blur:get() then
						render.blur(v882, v882 + v887, n19, value / 255, n18)
					end

					render.rect(v882, v882 + v887, color(0, 0, 0, value * v872 * 0.7), n18)
				end

				for _, v in ipairs(v867) do
					local v890 = value * v.anim
					local v891 = floor(n32)

					render.text(v195, v882 + vector(n17, v891 + n17), color(255, v890), nil, v.name)

					if v.avatar then
						local v892 = v882 + vector(v878 - n17 - n31, v891 + n17)

						render.texture(v.avatar, v892, vector(n31, n31), color(255, v890), "f", 2)
					end

					n32 = n32 + (n27 + n28) * v.anim
				end

				p182:set_size(vector(v878, n30 + 1 + v886 + n17))

				return
			end
		end

		local velocity_warning = widgets.velocity_warning
		local v233 = smoothy.new(0)
		local v234 = smoothy.new(0)
		local v235 = t9.new("Velocity Warning"):set_pos(vector(v28.x / 2 - 75, v28.y / 2 + 100)):update(true)

		function v235.render_callback(p183)
			-- upvalues: velocity_warning (copy), v233 (copy), v235 (copy), style (copy), pui (copy), v196 (copy), v195 (copy), u200 (ref), n17 (copy), v234 (copy), v28 (copy)
			local v894 = entity.get_local_player()
			local n34 = 1

			if not (ui.get_alpha() > 0.5) then
				if v894 and v894:is_alive() then
					n34 = v894.m_flVelocityModifier
				end
			else
				n34 = 1 - math.abs(math.sin(globals.realtime * 2)) * 0.4
			end

			local v896 = velocity_warning:get() and (not (n34 >= 0.99) or not (ui.get_alpha() <= 0))

			v233:update(0.05, v896 and 255 or 0)
			v235.is_active = not (v233.value <= 1)

			if not (v233.value <= 1) then
				local value = v233.value
				local v898 = style.accent:get()
				local v899 = v898.a / 255
				local v900 = pui.string("\f<triangle-exclamation>")
				local v901 = pui.string("slowed down")
				local v902 = pui.string(string.format("\a%s%d%%", style.accent:get():alpha_modulate(255):to_hex(), math.floor(n34 * 100 + 0.5)))
				local v903 = render.measure_text(v196, nil, v900)

				render.measure_text(v195, nil, v901)

				local n35 = 8
				local v905 = v903.x + n35 * 2
				local v906 = v905 + 132
				local v907 = vector(v906, 38)
				local pos = p183.pos

				u200(pos, v907, value, v898, v899)
				render.text(v196, pos + vector((v905 - v903.x) / 2 + n35 / 4.5, (v907.y - v903.y) / 2), style.accent:get():alpha_modulate(value), "", v900)

				local v909 = color(255, 255, 255, value * 0.1)

				render.rect(pos + vector(v905, 6), pos + vector(v905 + 1, v907.y - 6), v909)

				local v910 = v905 + n17 * 2

				render.text(v195, pos + vector(v910, 7), color(255, value), nil, v901)
				render.text(v195, pos + vector(v907.x - n17 * 2, 7), color(255, value), "r", v902)

				local v911 = pos + vector(v910, 24)
				local v912 = vector(v907.x - v910 - n17 * 2, 2)

				render.rect(v911, v911 + v912, color(0, 0, 0, value * 0.5), 1)

				local v913 = v912.x * n34

				v234:update(0.1, v913)
				render.rect(v911, v911 + vector(v234.value, v912.y), v898:alpha_modulate(value), 1)
				p183:set_size(v907)
				p183:set_rules({
					[1] = {
						horizontal = true,
						pos = vector(v28.x / 2, v28.y / 2)
					}
				})

				return
			end
		end

		smoothy.new(0)

		function t59.render()
		end
		function t59.level_init()
			-- upvalues: t62 (copy)
			t62.level_init()
		end
		function t59.level_shutdown()
			-- upvalues: t62 (copy)
			t62.level_shutdown()
		end

		t64 = {}

		local in_game = settings.in_game
		local v238 = render.load_font("Calibri Bold", vector(25, 23.5, -0.4), "a")
		local v239 = render.load_image_from_file("materials\\panorama\\images\\icons\\ui\\bomb_c4.svg")
		local sv_maxunlag = cvar.sv_maxunlag
		local t65 = {}

		local function v242(p184, p185, p186, p187, p188, p189, p190)
			return (p187 - p184) * p190 + p184, (p188 - p185) * p190 + p185, (p189 - p186) * p190 + p186
		end
		local function v243()
			-- upvalues: sv_maxunlag (copy), t18 (copy)
			local v922 = utils.net_channel()

			if v922 ~= nil then
				local v923 = sv_maxunlag:float()
				local v924 = t18.misc.other.fake_latency:get()
				local v925 = (v922.sequence_nr[0] + v922.sequence_nr[1]) / math.clamp(v924 * 0.001, 0.001, v923)

				return math.clamp(v925, 0, 1)
			end

			return nil
		end

		local t66 = {
			hits = 0,
			misses = 0
		}

		local function v245()
			-- upvalues: t66 (ref)
			local v926 = t66.hits + t66.misses

			if v926 ~= 0 then
				return math.floor(t66.hits / v926 * 100)
			end

			return 100
		end

		function t64.update(_, p192)
			-- upvalues: t66 (ref)
			t66[p192] = t66[p192] + 1
		end
		function t64.reset(_)
			-- upvalues: t66 (ref)
			t66 = {
				hits = 0,
				misses = 0
			}
		end
		function t64.add(_, p195, p196, p197, p198)
			-- upvalues: v238 (copy), t65 (ref), v28 (copy)
			if not p196 then
				p196 = color(255, 200)
			end

			local v935 = render.measure_text(v238, "", p195)
			local v936 = #t65 == 0 and v28.y - 350 or t65[#t65].offset - (v935.y + 11) - 8

			table.insert(t65, {
				text = p195,
				color = p196,
				offset = v936,
				size = v935,
				is_bomb = p197,
				pct = p198
			})
		end
		function t64.render(_)
			-- upvalues: t65 (ref), v238 (copy), v239 (copy)
			for _, v in ipairs(t65) do
				local v940 = vector(0, v.offset)
				local is_bomb = v.is_bomb
				local v942 = v940 + vector(28, 8.5)

				if is_bomb then
					v942 = v942 + vector(38)
				end

				local n36 = 56

				if is_bomb then
					n36 = n36 + 38
				end

				if v.pct ~= nil then
					n36 = n36 + 18
				end

				local v944 = vector(v.size.x + n36, v.size.y + 11)
				local v945 = vector(v944.x * 0.5, v944.y)
				local v946 = color(0, 0)
				local v947 = color(0, 51)
				local v948 = color(0, 128)

				render.gradient(v940, v940 + v945, v946, v947, v946, v947)
				render.gradient(v940 + vector(v945.x, 0), v940 + v944, v947, v946, v947, v946)
				render.text(v238, v942 + vector(1, 1), v948, nil, v.text)
				render.text(v238, v942, v.color, nil, v.text)

				if is_bomb then
					render.texture(v239, v940 + vector(29, 2), vector(v239.width, v239.height - 3), v.color)
				end

				if v.pct ~= nil then
					local v949 = v940 + vector(v944.x - 29, v.size.y / 2 + 5)

					render.circle_outline(v949, color(0, 200), 10, 0, 1, 4)
					render.circle_outline(v949, color(255, 255), 9.5, 361, v.pct, 3)
				end
			end

			t65 = {}
		end

		u37.render:set(function()
			-- upvalues: t64 (copy)
			local v950 = entity.get_local_player()

			if v950 and v950:is_alive() then
				t64:render()

				return
			end
		end)
		u37.render:set(function()
			-- upvalues: in_game (copy), v242 (copy), v243 (copy), t18 (copy), settings (copy), v194 (copy), t64 (copy), t15 (copy), v245 (copy)
			local v951 = entity.get_local_player()

			if v951 and v951:is_alive() then
				local skeet_indicators = in_game.skeet_indicators
				local selected = skeet_indicators.selected

				if skeet_indicators:get() then
					local v954, v955, v956 = color(255, 255, 255):to_hsv()
					local v957, v958, v959 = color(151, 175, 54):to_hsv()
					local v960 = color()
					local v961, v962, v963 = v242(v954, v955, v956, v957, v958, v959, v243())

					v960:as_hsv(v961, v962, v963, 200)

					local v964 = not (t18.misc.other.fake_latency:get() <= 0)
					local v965 = t18.ragebot.dormant_aimbot:get() or settings.rage.dormant_aimbot:get()
					local v966 = t18.anti_aim.other.fake_duck:get()
					local v967 = t18.ragebot.double_tap:get()
					local v968 = t18.ragebot.hide_shots:get()
					local v969 = t18.anti_aim.angles.freestanding:get() or t18.anti_aim.angles.freestanding:get_override()
					local v970 = t18.ragebot.safety.safe_points:get() == "Force" and v194("Safe Points")
					local v971 = t18.ragebot.safety.body_aim:get() == "Force" and v194("Body Aim")
					local v972 = v194("Min. Damage")

					if v964 and selected:get("Fake Latency") then
						t64:add("PING", v960)
					end

					if not v966 or not selected:get("Fake Duck") then
						if not v967 or not selected:get("Double Tap") then
							if v968 and selected:get("Hide Shots") then
								t64:add("OSAA")
							end
						else
							t64:add("DT", rage.exploit:get() == 1 and color(255, 200) or color(255, 0, 50, 255))
						end
					else
						t64:add("DUCK")
					end

					if v971 and selected:get("Body Aim") then
						t64:add("BA")
					end

					if v970 and selected:get("Safe Points") then
						t64:add("SP")
					end

					if v972 and selected:get("Minimum Damage") then
						t64:add("MD")
					end

					if v969 and selected:get("Freestanding") then
						t64:add("FS")
					end

					if selected:get("Bomb Info") then
						local planting = t15.planting
						local planted = t15.planted

						if planting.time > 0 then
							t64:add(planting.site, color(252, 243, 105, 255), true, 1 - planting.remaining)
						end

						if planted.time > 0 and planted.time - globals.curtime >= 0 then
							t64:add(string.format("%s - %.1fs", planted.site, planted.time - globals.curtime), color(255, 200), true)

							local v975 = t15:get_damage(v951, entity.get_entities("CPlantedC4", true)[1])

							if v975 > 0 then
								local v976 = not (v975 < v951.m_iHealth)
								local v977 = v976 and "FATAL" or string.format("-%d HP", v975)
								local v978 = v976 and color(255, 0, 50, 255) or color(252, 243, 105, 255)

								t64:add(v977, v978)
							end

							if planted.defuse_remaining > 0 then
								local v979 = render.screen_size()
								local n37 = 20
								local defuse_remaining = planted.defuse_remaining
								local v982 = not (planted.defuse_countdown > planted.time) and color(64, 200, 70, 160) or color(255, 0, 0, 125)

								render.rect(vector(), vector(n37, v979.y), color(0, 110))
								render.rect(vector(1, 1 + v979.y * (1 - defuse_remaining)), vector(n37, v979.y) - 1, v982)
							end
						end
					end

					if selected:get("Hit Rate") then
						t64:add(string.format("%d%%", v245()))
					end

					if v965 and selected:get("Dormant Aimbot") then
						t64:add("DA")
					end

					return
				end

				return
			end
		end)
		t67 = {}

		local aspect_ratio = settings.in_game.aspect_ratio
		local evaluate = aspect_ratio.evaluate
		local n38 = 0
		local r_aspectratio = cvar.r_aspectratio

		function t67.net_update_end()
			-- upvalues: aspect_ratio (copy), n38 (ref), r_aspectratio (copy), evaluate (copy)
			if aspect_ratio:get() then
				if n38 ~= evaluate:get() then
					r_aspectratio:float(evaluate:get() / 100, true)
					n38 = evaluate:get()
				end

				return
			end

			if n38 ~= 0 then
				r_aspectratio:float(0, true)
				n38 = 0
			end
		end
		function t67.shutdown()
			-- upvalues: r_aspectratio (copy)
			r_aspectratio:float(0, true)
		end
	end

	t68 = {}

	local viewmodel = settings.in_game.viewmodel
	local viewmodel_fov = cvar.viewmodel_fov
	local viewmodel_offset_x = cvar.viewmodel_offset_x
	local viewmodel_offset_y = cvar.viewmodel_offset_y
	local viewmodel_offset_z = cvar.viewmodel_offset_z
	local cl_righthand = cvar.cl_righthand
	local t69 = {
		fov = tonumber(viewmodel_fov:string()),
		x = tonumber(viewmodel_offset_x:string()),
		y = tonumber(viewmodel_offset_y:string()),
		z = tonumber(viewmodel_offset_z:string()),
		righthand = tonumber(cl_righthand:string())
	}
	local t70 = {
		fov = t69.fov,
		x = t69.x,
		y = t69.y,
		z = t69.z,
		righthand = t69.righthand
	}
	local v260 = smoothy.new(t69.fov)
	local v261 = smoothy.new(t69.x)
	local v262 = smoothy.new(t69.y)
	local v263 = smoothy.new(t69.z)

	local function v264(p200)
		-- upvalues: t70 (copy), viewmodel_fov (copy), viewmodel_offset_x (copy), viewmodel_offset_y (copy), viewmodel_offset_z (copy)
		if p200.fov ~= t70.fov then
			viewmodel_fov:float(p200.fov, true)
			t70.fov = p200.fov
		end

		if p200.x ~= t70.x then
			viewmodel_offset_x:float(p200.x, true)
			t70.x = p200.x
		end

		if p200.y ~= t70.y then
			viewmodel_offset_y:float(p200.y, true)
			t70.y = p200.y
		end

		if p200.z ~= t70.z then
			viewmodel_offset_z:float(p200.z, true)
			t70.z = p200.z
		end
	end
	local function v265()
		-- upvalues: viewmodel (copy), v260 (copy), t69 (copy), v261 (copy), v262 (copy), v263 (copy), v264 (copy)
		local value = viewmodel.value
		local t71 = {
			fov = v260:update(0.05, value and viewmodel.fov.value * 0.1 or t69.fov),
			x = v261:update(0.05, value and viewmodel.x.value * 0.1 or t69.x),
			y = v262:update(0.05, value and viewmodel.y.value * 0.1 or t69.y),
			z = v263:update(0.05, value and viewmodel.z.value * 0.1 or t69.z)
		}

		v264(t71)
	end

	function t68.render()
		-- upvalues: t69 (copy), viewmodel (copy), t70 (copy), cl_righthand (copy), v265 (copy)
		local v986 = entity.get_local_player():get_player_weapon()
		local righthand = t69.righthand

		if v986 and (v986:get_classid() == 107 and viewmodel.opposite_knife_hand:get()) then
			righthand = t69.righthand == 1 and 0 or 1
		end

		if righthand ~= t70.righthand then
			cl_righthand:int(righthand, true)
			t70.righthand = righthand
		end

		v265()
	end
	function t68.shutdown()
		-- upvalues: v264 (copy), t69 (copy)
		v264(t69)
	end

	t72 = {}

	local fake_duck = settings.other.fake_duck
	local n39 = 0

	local function v269()
		-- upvalues: n39 (ref)
		if n39 >= 14 then
			n39 = 0
		end

		n39 = n39 + 1
	end
	local function v270()
		-- upvalues: t18 (copy)
		t18.ragebot.hide_shots:override()
		t18.ragebot.double_tap:override()
	end

	function t72.createmove_run(p201)
		-- upvalues: fake_duck (copy), t19 (copy), t18 (copy)
		if fake_duck:get("Unlock speed") then
			local v989 = entity.get_local_player()

			if v989 and v989:is_alive() then
				if t19.is_onground and t18.anti_aim.other.fake_duck:get() then
					p201.forwardmove = p201.forwardmove * 2
					p201.sidemove = p201.sidemove * 2
				end

				return
			end

			return
		end
	end
	function t72.createmove(p202)
		-- upvalues: fake_duck (copy), t18 (copy), v270 (copy), v269 (copy), n39 (ref)
		if fake_duck:get("Freeze time") and t18.anti_aim.other.fake_duck:get() then
			if entity.get_local_player() then
				local v991 = entity.get_game_rules()

				if v991 ~= nil and v991.m_bFreezePeriod then
					v269()
					p202.in_duck = not (n39 <= 7)
					p202.send_packet = n39 == 14
					t18.ragebot.hide_shots:override(false)
					t18.ragebot.double_tap:override(false)

					return
				end

				return
			end

			return
		end

		v270()
	end
	function t72.override_view(p203)
		-- upvalues: fake_duck (copy), t18 (copy)
		if fake_duck:get("Freeze time") then
			local v993 = entity.get_local_player()

			if v993 and v993:is_alive() then
				local v994 = entity.get_game_rules()

				if v994 ~= nil and v994.m_bFreezePeriod then
					if t18.anti_aim.other.fake_duck:get() then
						p203.camera.z = v993:get_origin().z + 64

						return
					end

					return
				end

				return
			end

			return
		end
	end
	function t72.shutdown()
		-- upvalues: v270 (copy)
		v270()
	end

	t73 = {}

	local v272 = ffi.load("user32")
	local game_focus = settings.features.game_focus

	ffi.cdef("            typedef void* HWND;\n            typedef int BOOL;\n            BOOL FlashWindow(HWND hWnd, BOOL bInvert);\n            HWND GetForegroundWindow(void);\n            BOOL SetForegroundWindow(HWND hWnd);\n        ")

	local v274 = utils.opcode_scan("engine.dll", "8B 0D ?? ?? ?? ?? 85 C9 74 16 8B 01 8B", 2) or (function(p204)
		-- upvalues: v33 (copy), t5 (copy)
		v33("\f<triangle-exclamation>", "Error", p204)
		t5.failure()
	end)("invalid signature")
	local v275 = ffi.cast("void**", ffi.cast("char*", ffi.cast("void***", v274)[0][0]) + 8)[0]

	function t73.round_start()
		-- upvalues: game_focus (copy), v272 (copy), v275 (copy)
		if game_focus:get() then
			if v272.GetForegroundWindow() ~= v275 then
				if game_focus.flash:get() then
					v272.FlashWindow(v275, true)
				end

				if game_focus.focus:get() then
					v272.SetForegroundWindow(v275)
				end

				return
			end

			return
		end
	end

	t74 = {}

	local fast_ladder = settings.features.fast_ladder

	local function v278()
		-- upvalues: t19 (copy)
		if t19.movetype == 9 then
			if not t19.is_onground then
				return true
			end

			return false
		end

		return false
	end
	local function v279(p205)
		if p205:get_weapon_info().weapon_type == 9 then
			if p205.m_fThrowTime ~= 0 then
				return true
			end

			return false
		end
	end

	function t74.createmove(p206)
		-- upvalues: fast_ladder (copy), v278 (copy), v279 (copy), normalize_yaw (copy), clamp (copy), abs (copy)
		if fast_ladder.value then
			if v278() then
				local v997 = entity.get_local_player()

				if v997 then
					local v998 = v997:get_player_weapon()

					if v998 ~= nil and not v279(v998) then
						local m_vecLadderNormal = v997.m_vecLadderNormal

						if m_vecLadderNormal:lengthsqr() ~= 0 then
							local v1000 = render.camera_angles()
							local v1001 = m_vecLadderNormal:angles()
							local v1002 = v1001.y - v1000.y + 180
							local v1003 = v1001.x - v1000.x
							local v1004 = normalize_yaw(v1002)
							local v1005 = clamp(v1003, -89, 89)
							local v1006 = abs(v1004)
							local n40 = 89
							local n41 = -90
							local v1009 = not (v1005 >= -45)
							local v1010 = not (v1004 <= 0)
							local v1011 = not (p206.sidemove <= 0)
							local v1012 = not (p206.forwardmove <= 0)

							if not (v1006 > 70) or not (v1006 < 135) then
								if p206.sidemove == 0 and p206.forwardmove ~= 0 then
									if not v1010 then
										n41 = -n41
									end

									if not v1009 then
										v1012 = not v1012
									end

									p206.in_back = v1012 and 0 or 1
									p206.in_forward = v1012 and 1 or 0

									if not v1010 then
										v1012 = not v1012
									end

									p206.in_moveleft = v1012 and 1 or 0
									p206.in_moveright = v1012 and 0 or 1
									p206.view_angles.x = n40
									p206.view_angles.y = normalize_yaw(v1001.y + n41)

									return
								end

								return
							end

							if p206.forwardmove == 0 and p206.sidemove ~= 0 then
								if not v1010 then
									n41 = -n41
								end

								if v1010 then
									v1011 = not v1011
								end

								p206.in_back = v1011 and 1 or 0
								p206.in_forward = v1011 and 0 or 1

								if v1010 then
									v1011 = not v1011
								end

								p206.in_moveleft = v1011 and 1 or 0
								p206.in_moveright = v1011 and 0 or 1
								p206.view_angles.x = n40
								p206.view_angles.y = normalize_yaw(v1001.y + n41)

								return
							end

							return
						end

						return
					end

					return
				end

				return
			end

			return
		end
	end

	t75 = {}

	local grenade_features = settings.features.grenade_features

	local function v282()
		local v1013 = entity.get_local_player()

		if v1013 then
			local v1014 = v1013:get_player_weapon()

			if v1014 then
				if v1014:get_weapon_info().weapon_type == 9 then
					if not (v1014.m_fThrowTime < globals.curtime - to_time(globals.clock_offset)) then
						return true
					end

					return false
				end

				return false
			end

			return
		end
	end

	function t75.createmove(p207)
		-- upvalues: grenade_features (copy), v282 (copy)
		if grenade_features.throw_fix.value then
			if v282() then
				rage.exploit:allow_defensive(false)
				p207.no_choke = true

				return
			end

			return
		end
	end

	t76 = {}

	local grenade_features2 = settings.features.grenade_features
	local auto_release = grenade_features2.auto_release
	local u286 = nil
	local n42 = -1

	function t76.grenade_prediction(p208)
		-- upvalues: u286 (ref), n42 (ref)
		u286 = nil
		n42 = -1

		if p208.target ~= nil then
			u286 = p208
			n42 = globals.tickcount
		end
	end
	function t76.createmove(p209)
		-- upvalues: grenade_features2 (copy), auto_release (copy), n42 (ref), u286 (ref)
		if grenade_features2:get() and auto_release.value and n42 ~= -1 and p209.tickcount == n42 and u286 ~= nil then
			local v1018 = entity.get_local_player()

			if v1018 then
				local v1019 = v1018:get_player_weapon()

				if v1019 and v1019.m_bPinPulled then
					local type2 = u286.type

					if type2 ~= "Frag" or not (u286.damage < grenade_features2.damage:get()) or u286.fatal then
						if type2 ~= "Molly" or grenade_features2.molotov:get() then
							p209.in_attack = 0
							p209.in_attack2 = 0

							return
						end

						return
					end

					return
				end

				return
			end

			return
		end
	end

	t77 = {}

	local grenade_features3 = settings.features.grenade_features
	local super_toss = grenade_features3.super_toss
	local n43 = 0.3

	local function v292(p210, p211, p212, p213)
		-- upvalues: v21 (copy), n43 (copy)
		p210.x = p210.x - 10 + math.abs(p210.x) / 9

		local v1025 = vector():angles(p210)
		local v1026 = p213 * 1.25
		local v1027 = math.clamp(p211 * 0.9, 15, 750)
		local v1028 = math.clamp(p212, 0, 1)
		local v1029 = v1027 * v21(n43, 1, v1028)
		local v1030 = v1025

		for _ = 1, 8 do
			local v1032 = (v1030 * v1029 + v1026):length()

			if v1032 < 0.001 then
				break
			end

			local v1033 = (v1025 * v1032 - v1026) / v1029
			local v1034 = v1033:length()

			if not (v1034 < 0.001) then
				v1030 = v1033 / v1034
			else
				v1030 = v1025
			end
		end

		local v1035 = v1030:angles()

		if not (v1035.x > -10) then
			v1035.x = 1.125 * v1035.x + 11.25
		else
			v1035.x = 0.9 * v1035.x + 9
		end

		return v1035
	end

	function t77.createmove(p214)
		-- upvalues: grenade_features3 (copy), super_toss (copy), v292 (copy)
		if grenade_features3:get() and super_toss:get() then
			local v1037 = entity.get_local_player()

			if v1037 then
				local v1038 = v1037:get_player_weapon()

				if v1038 then
					local v1039 = v1038:get_weapon_info()

					if v1039 and v1039.weapon_type == 9 then
						if v1038.m_fThrowTime >= globals.curtime - to_time(globals.clock_offset) and p214.jitter_move then
							local v1040 = v1037:simulate_movement()

							v1040:think()
							p214.view_angles = v292(p214.view_angles, v1039.throw_velocity, v1038.m_flThrowStrength, v1040.velocity)

							return
						end

						return
					end

					return
				end

				return
			end

			return
		end
	end
	function t77.grenade_override_view(p215)
		-- upvalues: grenade_features3 (copy), super_toss (copy), v292 (copy)
		if grenade_features3:get() and super_toss:get() then
			local v1042 = entity.get_local_player()

			if v1042 then
				local v1043 = v1042:get_player_weapon()

				if v1043 then
					local v1044 = v1043:get_weapon_info()

					if v1044 then
						p215.angles = v292(p215.angles, v1044.throw_velocity, v1043.m_flThrowStrength, p215.velocity)

						return
					end

					return
				end

				return
			end

			return
		end
	end

	t78 = {}

	local unlock_latency = settings.other.unlock_latency
	local sv_maxunlag = cvar.sv_maxunlag
	local n44 = 0

	function t78.render(_)
		-- upvalues: unlock_latency (copy), n44 (ref), sv_maxunlag (copy)
		if unlock_latency:get() then
			if n44 ~= sv_maxunlag:float() then
				sv_maxunlag:float(0.6, true)
				n44 = 0.6
			end

			return
		end

		if n44 ~= sv_maxunlag:float() then
			sv_maxunlag:float(0.2, true)
			n44 = 0.2
		end
	end
	function t78.shutdown()
		-- upvalues: sv_maxunlag (copy)
		sv_maxunlag:float(0.2, true)
	end

	local no_fall_damage = settings.other.no_fall_damage
	local sv_gravity = cvar.sv_gravity
	local v299 = utils.get_vfunc(76, "float*(__thiscall*)(void*)")
	local v300 = utils.get_vfunc(77, "float*(__thiscall*)(void*)")

	local function v301(p217, p218, p219)
		-- upvalues: v299 (copy), v300 (copy)
		local v1049 = v299(p217[0])
		local v1050 = v300(p217[0])
		local v1051 = vector(v1049[0], v1049[1], v1049[2])
		local v1052 = vector(v1050[0], v1050[1], 54)
		local v1053 = utils.trace_hull(p218, p218 - vector(0, 0, p219), v1051, v1052, p217, 1)

		return v1053.fraction < 1 and (not v1053.start_solid and (not v1053.all_solid and not (v1053.plane.normal.z < 0.7))), v1053
	end
	local function v302(p220, p221)
		-- upvalues: sv_gravity (copy)
		local tickinterval = globals.tickinterval
		local v1057 = sv_gravity:float() * tickinterval * 0.5

		while p220 > 11 do
			local v1058 = p221 - v1057
			local v1059 = tickinterval * v1058

			p221 = v1058 - v1057
			p220 = p220 + v1059
		end

		return p221 <= -580 and not (p220 < 9)
	end;

	({}).createmove = function(p222)
		-- upvalues: no_fall_damage (copy), v301 (copy), v302 (copy)
		if no_fall_damage.value then
			local v1061 = entity.get_local_player()
			local v1062 = bit.band(v1061.m_fFlags, 1) == 1

			if v1061.m_MoveType == 2 and not v1062 then
				local v1063 = v1061:get_origin()

				if bit.band(v1061.m_fFlags, 2) == 0 then
					v1063.z = v1063.z + 9
				end

				local v1064, v1065 = v301(v1061, v1063, 1000)

				if v1064 then
					local v1066 = v1065.fraction * 1000
					local z = v1061.m_vecVelocity.z

					if not (z < 0) or v1066 >= 11 then
						if v302(v1066, z) then
							p222.in_duck = 1
							p222.in_jump = 0

							return
						end

						return
					end

					if z < -580 and v1066 > 9 then
						p222.in_jump = 1
						p222.in_duck = 0

						return
					end
				end
			end

			return
		end
	end
	t79 = {}

	local air_collision = settings.other.air_collision
	local v305 = ui.find("Miscellaneous", "Main", "Movement", "Air Strafe", "WASD Strafe")
	local v306 = ui.find("Miscellaneous", "Main", "Movement", "Edge Jump")
	local n45 = 450
	local n46 = 46
	local n47 = 36
	local n48 = 20
	local n49 = 33636363
	local n50 = 536870912

	function t79.createmove(p223)
		-- upvalues: air_collision (copy), v306 (copy), n45 (copy), v305 (copy), n48 (copy), n47 (copy), n46 (copy), n49 (copy), n50 (copy)
		if air_collision.value then
			if not v306:get_override() and not v306:get() then
				local v1069 = entity.get_local_player()

				if v1069.m_MoveType == 2 then
					if bit.band(v1069.m_fFlags, 1) ~= 1 then
						if not p223.in_duck and not p223.in_speed then
							local m_vecVelocity = v1069.m_vecVelocity
							local m_vecMins = v1069.m_vecMins
							local m_vecMaxs = v1069.m_vecMaxs
							local v1073 = vector():angles(0, p223.view_angles.y)
							local v1074 = v1073:vectors()
							local n51 = 0
							local n52 = 0

							if p223.sidemove == 0 then
								n51 = n45
							end

							if v305:get() then
								n51 = p223.forwardmove == 0 and (p223.sidemove == 0 and n45) or p223.forwardmove
								n52 = p223.sidemove
							end

							local v1077 = vector(v1073.x * n51 + v1074.x * n52, v1073.y * n51 + v1074.y * n52)

							v1077:normalize()

							local v1078 = v1069:get_origin()

							v1078.z = v1078.z + n48
							m_vecVelocity.z = 0
							m_vecMaxs.z = n47

							local v1079 = m_vecVelocity:normalized()

							if not (v1079:dot(v1077) <= 0) then
								local v1080 = v1078 + v1077 * n46
								local v1081 = utils.trace_hull(v1078, v1080, m_vecMins, m_vecMaxs, v1069, n49)
								local normal = v1081.plane.normal

								if v1081:did_hit_world() then
									if not (math.abs(normal.z) >= 0.1) then
										if bit.band(v1081.contents, n50) ~= n50 then
											if not v1081.entity:is_breakable() then
												if v1079:dot(normal) < -0.85 then
													v1079 = v1077
												end

												local v1083 = normal:vectors()

												if v1083:dot(v1079) < 0 then
													v1083 = v1083 * -1
												end

												p223.move_yaw = math.deg(math.atan2(v1083.y, v1083.x))
												p223.forwardmove = n45
												p223.sidemove = 0

												return
											end

											return
										end

										return
									end

									return
								end

								return
							end

							return
						end

						return
					end

					return
				end

				return
			end

			return
		end
	end

	t80 = {}

	local scope_overlay = t18.world.main.override_zoom.scope_overlay
	local v315 = smoothy.new(0)
	local v316 = smoothy.new(0)

	function t80.render()
		-- upvalues: v28 (copy), settings (copy), v315 (copy), scope_overlay (copy), v316 (copy)
		local v1084 = entity.get_local_player()
		local v1085 = v28 * 0.5
		local v1086 = settings.in_game.custom_scope:get() and (v1084 and (v1084:is_alive() and v1084.m_bIsScoped))

		v315:update(0.05, v1086 and 1 or 0)
		scope_overlay:override(settings.in_game.custom_scope:get() and "Remove All" or nil)

		if not (v315.value < 0.11) then
			local value = v315.value
			local v1088 = settings.in_game.custom_scope.offset:get() * value
			local v1089 = settings.in_game.custom_scope.length:get() * value

			v316:update(0.05, common.is_button_down(9) and 120 or 255)

			local value3 = v316.value
			local v1091 = settings.in_game.custom_scope.inverter.color:get()
			local v1092 = settings.in_game.custom_scope.inverter:get()
			local v1093 = v1091:alpha_modulate(v1092 and 0 or math.round(value3))
			local v1094 = v1091:alpha_modulate(v1092 and math.round(255) or 0)

			render.gradient(v1085 + vector(v1088 + 1, 0), v1085 + vector(v1088 + v1089 + 1, 1), v1093, v1094, v1093, v1094)
			render.gradient(v1085 - vector(v1088, 0), v1085 - vector(v1088 + v1089, -1), v1093, v1094, v1093, v1094)
			render.gradient(v1085 + vector(0, v1088 + 1), v1085 + vector(1, v1088 + v1089 + 1), v1093, v1093, v1094, v1094)
			render.gradient(v1085 - vector(0, v1088), v1085 - vector(-1, v1088 + v1089), v1093, v1093, v1094, v1094)

			return
		end
	end
end

local t81 = {}
local screen_indicator = settings.indicators.screen_indicator
local glow = screen_indicator.glow
local style = settings.style
local v321 = smoothy.new(0)
local v322 = smoothy.new(0)

color(0, 0, 0, 150)

local v323 = t9.new("Crosshair"):set_pos(v28.y / 2 + 15, "y"):update(true)
local n53 = 5
local t82 = {
	[1] = "standing",
	[2] = "moving",
	[3] = "slowwalk",
	[4] = "ducking",
	[5] = "sneaking",
	[6] = "in air",
	[7] = "in air&c"
}
local t83 = {
	[1] = {
		font = 4,
		text = function()
			-- upvalues: style (copy), v23 (copy), t2 (copy)
			local v1095 = style.accent:get():alpha_modulate(255)
			local v1096 = color(50, 200)
			local v1097 = globals.realtime * 1.5

			return v23(t2.name, v1097, v1095, v1096)
		end,
		alpha = smoothy.new(0),
		update = function(p224)
			return p224.alpha:update(0.05, 1)
		end
	},
	[2] = {
		font = 2,
		text = function(_)
			-- upvalues: t50 (copy), t82 (copy)
			local v1100 = t50.get_statement()
			local v1101 = v1100 > 1 and t82[v1100 - 1] or "dead"

			return string.format("* %s *", string.upper(v1101))
		end,
		alpha = smoothy.new(0),
		update = function(p226)
			return p226.alpha:update(0.05, 1)
		end
	},
	[3] = {
		font = 2,
		text = function()
			return "DUCK"
		end,
		alpha = smoothy.new(0),
		update = function(p227)
			-- upvalues: t18 (copy)
			return p227.alpha:update(0.05, t18.anti_aim.other.fake_duck:get() and 1 or 0)
		end
	},
	[4] = {
		circle = true,
		font = 2,
		text = function()
			return "DT"
		end,
		alpha = smoothy.new(0),
		update = function(p228)
			-- upvalues: t18 (copy)
			local v1105 = t18.ragebot.double_tap:get()

			if t18.anti_aim.other.fake_duck:get() then
				v1105 = false
			end

			return p228.alpha:update(0.05, v1105 and 1 or 0)
		end,
		progress_circle = function(_)
			return rage.exploit:get()
		end
	},
	[5] = {
		font = 2,
		text = function()
			return "HS"
		end,
		alpha = smoothy.new(0),
		update = function(p230)
			-- upvalues: t18 (copy)
			local v1108 = t18.ragebot.hide_shots:get()

			if t18.anti_aim.other.fake_duck:get() or t18.ragebot.double_tap:get() then
				v1108 = false
			end

			return p230.alpha:update(0.05, v1108 and 1 or 0)
		end
	},
	[6] = {
		font = 2,
		text = function()
			return "BODY"
		end,
		alpha = smoothy.new(0),
		update = function(p231)
			-- upvalues: v194 (copy)
			return p231.alpha:update(0.05, v194("Body Aim") and 1 or 0)
		end
	},
	[7] = {
		font = 2,
		text = function()
			return "SAFE"
		end,
		alpha = smoothy.new(0),
		update = function(p232)
			-- upvalues: v194 (copy)
			return p232.alpha:update(0.05, v194("Safe Points") and 1 or 0)
		end
	},
	[8] = {
		font = 2,
		text = function()
			return "DMG"
		end,
		alpha = smoothy.new(0),
		update = function(p233)
			-- upvalues: v194 (copy)
			return p233.alpha:update(0.05, v194("Min. Damage") and 1 or 0)
		end
	},
	[9] = {
		font = 2,
		text = function()
			return "FS"
		end,
		alpha = smoothy.new(0),
		update = function(p234)
			-- upvalues: v194 (copy)
			return p234.alpha:update(0.05, v194("Freestanding") and 1 or 0)
		end
	}
}

local function v327(p235, p236, p237)
	-- upvalues: style (copy), t83 (copy), n53 (copy), glow (copy)
	if not (p236 < 0.01) then
		local n54 = 0
		local v1117 = style.accent:get()

		for i = 1, #t83 do
			local v1119 = t83[i]
			local font = v1119.font
			local value = v1119.alpha.value

			if value > 0.01 then
				local v1122 = v1119:text()
				local v1123 = render.measure_text(font, nil, v1122)
				local v1124 = math.round(255 * value * p236)
				local v1125 = v1123
				local n55 = 4
				local n56 = 1

				if v1119.circle then
					v1125 = v1125 + vector(n55 * 2 + n56, 0)
				end

				local v1128 = p237 and n53 or -(v1125.x * 0.5)
				local v1129 = vector(p235.x + v1128, p235.y + n54)

				if i == 1 and glow:get() then
					local v1130 = v1129 + vector(0, v1123.y * 0.5)

					render.shadow(v1130, v1130 + vector(v1123.x, 0), v1117:alpha_modulate(v1124))
				end

				render.text(font, v1129, color(255, v1124), nil, v1122)

				if v1119.circle then
					local v1131 = v1119:progress_circle()
					local v1132 = v1129 + vector(v1123.x + n56 + n55, v1123.y * 0.5)

					render.circle_outline(v1132, color(0, v1124 * 0.8), n55, 0, 1, 2)
					render.circle_outline(v1132, v1117:alpha_modulate(v1124), n55, 180, v1131, 1)
				end

				n54 = n54 + math.round((v1125.y - 2) * value)
			end
		end

		return
	end
end
local function v328()
	-- upvalues: screen_indicator (copy), t19 (copy), v321 (copy), t83 (copy), v322 (copy)
	local v1133 = entity.get_local_player()

	if v1133 and v1133:is_alive() then
		local v1134 = v1133:get_player_weapon()
		local v1135 = v1134 and v1134:get_weapon_info()
		local v1136 = v1135 and v1135.weapon_type or 0
		local v1137 = screen_indicator:get() and 1 or 0

		if v1136 == 9 then
			v1137 = v1137 * 0.5
		end

		if t19.in_scoreboard then
			v1137 = 0
		end

		local v1138 = v321:update(0.05, v1137)

		if not (v1138 < 0.01) then
			for i = 1, #t83 do
				t83[i]:update()
			end

			v322:update(0.05, v1133.m_bIsScoped and 1 or 0)

			return v1138, v322.value
		end

		return 0, 0
	end

	return 0, 0
end

function v323.render_callback(p238)
	-- upvalues: v328 (copy), v323 (copy), v327 (copy), v28 (copy)
	local v1141, v1142 = v328()

	if not (v1141 < 0.01) then
		v323.is_active = true

		local v1143 = render.measure_text(4, nil, "nexus") + vector(0, 5)
		local v1144 = v323:get_pos() + vector(v1143.x * 0.5, 0)

		v327(v1144, v1141 * (1 - v1142), false)
		v327(v1144, v1141 * v1142, true)
		p238:set_min(vector(v28.x / 2, v28.y / 2 + 10))
		p238:set_max(vector(v28.x / 2, v28.y / 2 + 120))
		p238:set_rules({
			[1] = {
				horizontal = true,
				pos = vector(v28.x / 2, v28.y / 2 + 10),
				end_pos = vector(v28.x / 2, v28.y / 2 + 120)
			}
		})

		if v28.x * 0.5 - v1143.x * 0.5 ~= p238.pos.x then
			p238:set_pos(v28.x * 0.5 - v1143.x * 0.5, "x")
		end

		p238:set_size(v1143)

		return
	end

	v323.is_active = false
end
function t81.render()
end

local t84 = {}
local keep_transparency = settings.in_game.keep_transparency
local v331 = pui.find("Visuals", "Players", "Self", "Chams", "Model", {
	transparency = "Transparency"
})

function t84.localplayer_transparency(p239)
	-- upvalues: keep_transparency (copy), v331 (copy)
	local v1146 = entity.get_local_player()

	if v1146 then
		if keep_transparency:get() then
			if not v331:get() then
				if v331.transparency:get("In scope") then
					local v1147 = v1146:get_player_weapon()

					if v1147 then
						local m_zoomLevel = v1147.m_zoomLevel

						if m_zoomLevel and m_zoomLevel ~= 0 then
							return 59
						end

						return
					end

					return
				end

				return p239
			end

			return p239
		end

		return p239
	end
end

local t85 = {}
local manual_arrows = settings.indicators.manual_arrows
local n57 = 45
local v335 = render.load_font("Verdana", 20, "abd")
local v336 = render.load_font("Verdana", 27, "ab")
local v337 = smoothy.new(0)
local v338 = smoothy.new(0)
local v339 = smoothy.new(0)
local v340 = smoothy.new(0)

function t85.render()
	-- upvalues: manual_arrows (copy), t27 (copy), v337 (copy), v338 (copy), v339 (copy), v340 (copy), v28 (copy), settings (copy), v335 (copy), n57 (copy), v336 (copy)
	if manual_arrows:get() then
		local v1149 = entity.get_local_player()

		if v1149 and v1149:is_alive() then
			local v1150 = t27.anti_aimbot.general.manual_yaw:get()
			local v1151 = v1150 == "Left"
			local v1152 = v1150 == "Right"

			v337:update(0.05, v1151 and 1 or 0)
			v338:update(0.05, v1152 and 1 or 0)
			v339:update(0.05, is_back and 1 or 0)
			v340:update(0.05, v1149.m_bIsScoped and 1 or 0)

			local v1153 = -20 * v340.value
			local v1154 = v28 * 0.5 + vector(0, v1153)
			local v1155 = manual_arrows.style:get()
			local v1156 = settings.style.accent:get()

			color(180, 180, 180, 0)

			if v1155 ~= "Classic" then
				if v1155 == "Modern" then
					local v1157 = v336

					if v337.value > 0.01 then
						local value = v337.value
						local s11 = "⮜"
						local v1160 = render.measure_text(v1157, "s", s11)
						local v1161 = v1156:alpha_modulate(math.round(255 * value))
						local v1162 = vector(v1154.x - v1160.x - n57 + 1, v1154.y - v1160.y * 0.5 - 1)
						local v1163 = vector(v1162.x + v1160.x * 0.5, v1154.y)

						render.shadow(v1163, v1163, v1161, v1157.height + 4)
						render.text(v1157, v1162, v1161, "s", s11)
					end

					if v338.value > 0.01 then
						local value = v338.value
						local s12 = "⮞"
						local v1166 = render.measure_text(v1157, "s", s12)
						local v1167 = v1156:alpha_modulate(math.round(255 * value))
						local v1168 = vector(v1154.x + n57, v1154.y - v1166.y * 0.5 - 1)
						local v1169 = vector(v1168.x + v1166.x * 0.5, v1154.y)

						render.shadow(v1169, v1169, v1167, v1157.height + 4)
						render.text(v1157, v1168, v1167, "s", s12)
					end
				end
			else
				local v1170 = v335

				if v337.value > 0.01 then
					local value = v337.value
					local s13 = "<"
					local v1173 = render.measure_text(v1170, "s", s13)
					local v1174 = v1156:alpha_modulate(math.round(255 * value))
					local v1175 = vector(v1154.x - v1173.x - n57 + 1, v1154.y - v1173.y * 0.5 - 1)

					render.text(v1170, v1175, v1174, "s", s13)
				end

				if v338.value > 0.01 then
					local value = v338.value
					local s14 = ">"
					local v1178 = render.measure_text(v1170, "s", s14)
					local v1179 = v1156:alpha_modulate(math.round(255 * value))
					local v1180 = vector(v1154.x + n57, v1154.y - v1178.y * 0.5 - 1)

					render.text(v1170, v1180, v1179, "s", s14)
				end
			end

			return
		end

		return
	end
end

local damage_indicator = settings.indicators.damage_indicator
local v342 = pui.find("Aimbot", "Ragebot", "Selection", "Min. Damage")
local v343 = render.load_font("Verdana", 13, "ad")

local function v344(p240)
	if p240 then
		local v1182 = p240:get_weapon_info()

		if v1182 then
			if v1182.weapon_type ~= 0 and not (v1182.weapon_type > 6) then
				return true
			end

			return false
		end

		return false
	end

	return false
end

local v345 = t9.new("Damage Indicator"):set_pos(vector(v28.x / 2 + 8, v28.y / 2 - 8 - 12)):update(true)
local v346 = smoothy.new(0)
local v347 = smoothy.new(0)

function v345.render_callback(p241)
	-- upvalues: damage_indicator (copy), v344 (copy), v346 (copy), v343 (copy), v342 (copy), v347 (copy), v28 (copy)
	local v1184 = entity.get_local_player()
	local v1185 = v1184 and v1184:is_alive()
	local v1186 = damage_indicator:get()
	local v1187 = v1185 and v1186 and 1 or 0

	if v1187 == 1 then
		local v1188 = v1184:get_player_weapon()

		if not v344(v1188) then
			v1187 = 0
		end
	end

	v346:update(0.05, v1187)

	if not (v346.value < 0.1) then
		local v1189 = damage_indicator.small:get() and 2 or v343
		local v1190 = v342:get()
		local v1191 = v347:update(0.05, v1190)
		local v1192 = math.floor(v1191 + 0.5)

		if damage_indicator.animated:get() then
			v1190 = v1192
		end

		local str

		if not (v1190 < 1) then
			if not (v1190 > 100) then
				str = tostring(v1190)
			else
				str = string.format("+%d", v1190 - 100)
			end
		else
			str = "A"
		end

		local v1194 = render.measure_text(v1189, nil, str)
		local v1195 = color():alpha_modulate(math.round(255 * v346.value))

		render.text(v1189, p241.pos, v1195, nil, str)
		p241.is_centered = false
		p241.render_border = true
		p241:set_min(vector(v28.x / 2 - 100, v28.y / 2 - 100))
		p241:set_max(vector(v28.x / 2 + 100 - v1194.x, v28.y / 2 + 100 - v1194.y))
		p241:set_size(v1194)

		return
	end
end

local t86 = {}
local edge_stop = settings.other.edge_stop
local v350 = pui.find("Miscellaneous", "Main", "Movement", "Edge Jump")

function t86.createmove(p242)
	-- upvalues: edge_stop (copy), v350 (copy)
	if edge_stop:get() or edge_stop:get_override() then
		if p242.in_jump or v350:get() or v350:get_override() then
			return
		end

		local v1197 = entity.get_local_player()

		if not v1197 then
			return
		end

		local v1198 = v1197:simulate_movement()

		v1198:think(4)

		if v1198.velocity.z ~= 0 then
			p242.block_movement = 2
		end
	end
end

local t87 = {}
local v352 = pui.find("Aimbot", "Ragebot", "Main", "Peek Assist")
local v353 = pui.find("Aimbot", "Ragebot", "Main", "Enabled", "Extended Backtrack")
local edge_stop2 = settings.other.edge_stop
local freestanding = t27.anti_aimbot.general.freestanding

settings.rage.peek_assist:set_callback(function(p243)
	-- upvalues: v352 (copy), v353 (copy), edge_stop2 (copy), freestanding (copy)
	local v1200 = p243:get()

	v352:override(v1200 and p243.behaviors:get("Quick Peek") or nil)
	v353:override(v1200 and p243.behaviors:get("Extended Backtrack") or nil)
	edge_stop2:override(v1200 and p243.behaviors:get("Edge Stop") or nil)
	freestanding:override(v1200 and p243.behaviors:get("Freestanding") or nil)
end)

function t87.shutdown()
	-- upvalues: v352 (copy), v353 (copy), edge_stop2 (copy)
	v352:override()
	v353:override()
	edge_stop2:override()
end

local t88 = {}
local n58 = -1
local n59 = 1
local t89 = {
	[1] = {
		scale = 3,
		hitbox = "Head",
		vec = vector(0, 0, 58)
	},
	[2] = {
		scale = 6,
		hitbox = "Chest",
		vec = vector(0, 0, 50)
	},
	[3] = {
		scale = 5,
		hitbox = "Stomach",
		vec = vector(0, 0, 40)
	}
}
local v360 = pui.find("Aimbot", "Ragebot", "Selection", "Min. Damage")
local dormant_aimbot = settings.rage.dormant_aimbot

local function v362()
	local t90 = {}
	local v1202 = entity.get_player_resource()

	for i = 1, globals.max_players do
		local v1204 = entity.get(i)

		if v1204 and v1202.m_bConnected[i] and v1204:is_enemy() and v1204:is_dormant() then
			table.insert(t90, v1204)
		end
	end

	return t90
end
local function v363(p244, p245, p246)
	local v1208 = p244:to(p245):angles()
	local v1209 = math.rad(v1208.y + 90)
	local v1210 = vector(math.cos(v1209), math.sin(v1209), 0) * p246

	return {
		[1] = {
			text = "Middle",
			vec = p245
		},
		[2] = {
			text = "Left",
			vec = p245 + v1210
		},
		[3] = {
			text = "Right",
			vec = p245 - v1210
		}
	}
end

function t88.createmove(p247)
	-- upvalues: dormant_aimbot (copy), n58 (ref), v362 (copy), n59 (ref), v360 (copy), t89 (copy), v363 (copy)
	local v1212 = entity.get_local_player()

	if v1212 and (v1212:is_alive() and dormant_aimbot:get()) then
		local v1213 = v1212:get_player_weapon()

		if v1213 then
			local v1214 = v1213:get_weapon_info()

			if v1214 then
				local v1215 = v1213:get_inaccuracy()

				if v1215 then
					if not (globals.tickcount < n58) then
						local v1216 = v1212:get_anim_state()

						if v1216 and (not p247.in_jump or v1216.on_ground) then
							local weapon_type = v1214.weapon_type

							if weapon_type >= 1 and weapon_type <= 6 and not (v1213.m_iClip1 <= 0) then
								local v1218 = v362()

								if #v1218 ~= 0 then
									local v1219 = dormant_aimbot.hitboxes:get()

									n59 = globals.tickcount % #v1218 ~= 0 and n59 + 1 or 1

									local v1220 = v1218[n59]

									if v1220 then
										local v1221 = v1220:get_bbox()
										local v1222 = v1220:get_origin()
										local m_flDuckAmount = v1220.m_flDuckAmount
										local v1224 = dormant_aimbot.accuracy:get()
										local v1225 = dormant_aimbot.damage:get() or v360:get()

										if v1225 > 100 then
											v1225 = v1225 - 100 + v1220.m_iHealth
										end

										local t91 = {}

										for _, v in ipairs(t89) do
											local vec = v.vec

											if v.hitbox ~= "Head" then
												if v.hitbox == "Chest" then
													vec = vec - vector(0, 0, 4 * m_flDuckAmount)
												end
											else
												vec = vec - vector(0, 0, 10 * m_flDuckAmount)
											end

											if #v1219 == 0 or (function(p248, p249)
												for i = 1, #p248 do
													if p249 == p248[i] then
														return true
													end
												end

												return false
											end)(v1219, v.hitbox) then
												table.insert(t91, {
													vec = vec,
													scale = v.scale,
													hitbox = v.hitbox
												})
											end
										end

										local v1230 = v1212:get_eye_position()
										local current = v1212:get_simulation_time().current

										if (v1214.is_revolver and not (current <= v1213.m_flNextPrimaryAttack) or not (current <= math.max(v1212.m_flNextAttack, v1213.m_flNextPrimaryAttack, v1213.m_flNextSecondaryAttack))) and not (v1224 >= math.floor(v1221.alpha * 100) + 5) then
											local vec = nil

											for _, v in ipairs(t91) do
												local v1235 = v363(v1230, v1222 + v.vec, v.scale)

												for _, v3 in ipairs(v1235) do
													local v1238, v1239 = utils.trace_bullet(v1212, v1230, v3.vec, function(p250)
														-- upvalues: v1220 (copy)
														return p250 == v1220
													end)

													if v1239 and not v1239:is_visible() and v1238 ~= 0 and v1225 < v1238 then
														vec = v3.vec

														break
													end
												end

												if vec then
													break
												end
											end

											if vec then
												local v1240 = v1230:to(vec):angles()

												p247.block_movement = 1

												if dormant_aimbot.auto_scope:get() and not v1212.m_bIsScoped and not v1212.m_bResumeZoom and v1214.weapon_type == 5 and v1216.on_ground then
													p247.in_attack2 = true
												end

												if v1215 < 0.01 then
													p247.view_angles = v1240
													p247.in_attack = true
												end

												return
											end

											return
										end

										return
									end

									return
								end

								return
							end

							return
						end

						return
					end

					return
				end

				return
			end

			return
		end

		return
	end
end
function t88.round_start()
	-- upvalues: n58 (ref)
	n58 = globals.tickcount
end

local t92 = {}
local style2 = t27.settings.style
local t93 = {}
local logs = settings.rage.logs
local display = logs.display
local n60 = 5
local v370 = t9.new("Aimbot Logs"):set_pos(vector(n60, n60)):update(true)
local t94 = {
	[0] = "generic",
	[1] = "head",
	[2] = "chest",
	[3] = "stomach",
	[4] = "left arm",
	[5] = "right arm",
	[6] = "left leg",
	[7] = "right leg",
	[8] = "neck",
	[9] = "generic",
	[10] = "gear"
}

local function v372(p251)
	return p251:to_hex()
end

function t92.add(_, p253, p254, p255)
	-- upvalues: v22 (copy), t93 (copy), smoothy (copy), pui (copy)
	if v22(p254, "Screen") then
		if #t93 >= 10 then
			table.remove(t93, #t93)
		end

		t93[#t93 + 1] = {
			time = 4,
			text = p253.text,
			init_time = common.get_unixtime(),
			alpha = smoothy.new(0),
			accent = p255
		}
	end

	local v1246 = pui.string(string.format("\a%s%s \a646464ff» \r%s", p255:alpha_modulate(255):to_hex(), "nexus", p253.text_console))

	if v22(p254, "Events") then
		print_dev(p253.text_console)
	end

	if v22(p254, "Console") then
		print_raw(v1246)
	end
end

local t95 = {
	[1] = {
		type = "Hit",
		time = -1,
		text = "Killed \a%s" .. common.get_username() .. " \rin the \a%shead",
		alpha = smoothy.new(0)
	},
	[2] = {
		type = "Miss",
		text = "Missed at \a%ssqwat\r's \a%shead \rdue to \a%sspread",
		time = -1,
		alpha = smoothy.new(0)
	}
}

function t92.aim_ack(p256)
	-- upvalues: logs (copy), t94 (copy), v372 (copy), t92 (copy), display (copy)
	if logs:get() then
		local target = p256.target

		if target then
			local v1249 = target:get_name()
			local v1250 = p256.damage or 0
			local v1251 = p256.wanted_damage or 0
			local v1252 = t94[p256.hitgroup] or "?"
			local v1253 = t94[p256.wanted_hitgroup] or "?"
			local v1254 = p256.backtrack or 0
			local v1255 = target.m_iHealth or 0
			local v1256 = math.floor((p256.hitchance or 0) + 0.5)
			local v1257 = p256.spread or 0
			local state = p256.state
			local clr = logs.clr

			color():to_hex()

			local v1260, v1261, v1262

			if state then
				v1260 = string.format("^0Missed at ^1%s^0's ^1%s^0 due to ^1%s^0 (^1%d^0 dmg)(hc: ^1%s^0%% spread: ^1%.2f^0° bt: ^1%d^0t)", v1249, v1253, state, v1251, v1256, v1257, v1254)
				v1261 = string.format("Missed at ^1%s^0 due to ^1%s", v1249, state)
				v1262 = clr:get("Miss")[1]
			else
				v1260 = string.format("^0Hit ^1%s^0's ^1%s^0(^1%s^0) for ^1%d^0(^1%d^0) damage %s(hc: ^1%s^0%% spread: ^1%.2f^0° bt: ^1%d^0t)", v1249, v1252, v1253, v1250, v1251, v1255 > 0 and string.format("(^1%s^0hp left)", v1255) or "", v1256, v1257, v1254)

				if not (v1255 > 0) then
					v1261 = string.format("Killed ^1%s^0 in ^1%s^0", v1249, v1252)
				else
					v1261 = string.format("Hit ^1%s^0's ^1%s ^0for ^1%d^0 damage (^1%s^0hp left)", v1249, v1252, v1250, v1255)
				end

				v1262 = clr:get("Hit")[1]
			end

			local v1263 = v1260:gsub("%^1", "\a" .. v372(v1262)):gsub("%^0", "\affffffff")
			local v1264 = v1261:gsub("%^1", "\a" .. v372(v1262)):gsub("%^0", "\affffffff")

			t92:add({
				text = v1264,
				text_console = v1263
			}, display:get(), v1262)

			return
		end

		return
	end
end

local v374 = smoothy.new(0)

function v370.render_callback(p257)
	-- upvalues: t93 (copy), t95 (copy), logs (copy), display (copy), pui (copy), v195 (copy), n17 (copy), v21 (copy), n60 (copy), v374 (copy), floor (copy), u200 (ref), style2 (copy), v28 (copy)
	local v1266 = t93

	if #v1266 == 0 then
		v1266 = t95
	end

	p257.is_active = ui.get_alpha() > 0 and (logs:get() and display:get("Screen"))

	local v1267 = common.get_unixtime()
	local n61 = 0

	for _, v in pairs(v1266) do
		local accent = v.accent
		local text = v.text

		if v.type then
			accent = logs.clr:get(v.type)[1]:alpha_modulate(255)
			text = pui.string(v.text:gsub("%%s", accent:to_hex()))
		end

		local v1273 = render.measure_text(v195, nil, text)

		if v.time == -1 or not math.clamp(v.init_time + v.time - v1267, 0, v.time) then
		end

		local v1274

		if v.time ~= -1 then
			v1274 = math.clamp(v.init_time + v.time - v1267, 0, v.time) > 0 and 255 or 0
		else
			v1274 = logs:get() and display:get("Screen") and 255 or 0
		end

		local v1275 = math.clamp(v.alpha:update(0.075, v1274), 0, 255)

		if v.time == -1 then
			v1275 = v1275 * ui.get_alpha()
		end

		local v1276 = v1273.x + n17 * 2
		local v1277 = v1273.y + n17 * 1.5
		local v1278 = vector(v1276, v1277)
		local v1279 = v21(p257.pos.x + n60, p257.pos.x + p257.size.x * 0.5 - v1278.x * 0.5, v374.value)
		local v1280 = vector(math.round(v1279), floor(p257.pos.y + n60 + n61))

		u200(v1280, v1278, v1275, accent, style2.accent:get().a / 255)
		render.text(v195, v1280 + v1278 * 0.5, color(255, v1275), "c", text)

		if v.time ~= -1 then
			n61 = n61 + (v1277 + n17) * (v1275 / 255)
		else
			n61 = n61 + (v1277 + n17)
		end
	end

	for k, v in pairs(v1266) do
		if v.time ~= -1 and math.clamp(v.init_time + v.time - v1267, 0, v.time) <= 0 and v.alpha.value <= 0 then
			table.remove(t93, k)
		end
	end

	v374:update(0.05, p257.pos.x < v28.x / 3 and 0 or 1)
	p257:set_rules({
		[1] = {
			horizontal = true,
			pos = vector(p257.size.x * 0.5 + 10, 0)
		},
		[2] = {
			horizontal = false,
			pos = vector(10, 5 + p257.size.y * 0.5)
		},
		[3] = {
			horizontal = true,
			pos = v28 * 0.5
		}
	})
	p257:set_size(vector(266, 46 + n60))
end
function t92.render()
end
function t58.render()
	-- upvalues: t59 (copy), t78 (copy), t80 (copy), t81 (copy), t85 (copy), t92 (copy)
	t59.render()
	t78.render()
	t80.render()
	t81.render()
	t85.render()
	t92.render()
end

local t96 = {}
local icon = settings.shared.icon
local t97 = {
	XOR_KEY = 1514880045,
	SECURITY_KEY = "*v5_#fX9!zL2@mK8*",
	AUTHOR = "emptyspotify",
	DEV_ID = 1064967573,
	ID = 1064967572
}
local t98 = {
	user = "https://raw.githubusercontent.com/emptyspotify/icons/main/nexus.png",
	dev = "https://raw.githubusercontent.com/emptyspotify/icons/main/nexus_dev.png"
}
local n62 = 0
local t99 = {}

local function v381()
	-- upvalues: t99 (ref)
	t99 = {}

	local v1283 = entity.get_players(false, true)

	for _, v in ipairs(v1283) do
		v:set_icon()
	end

	local v1286 = entity.get_local_player()

	if v1286 then
		v1286:set_icon()
	end
end
local function v382()
	-- upvalues: u37 (ref), t97 (copy)
	u37.voice_message:call(function(p258)
		-- upvalues: t97 (copy)
		p258:write_bits(t97.ID, 32)

		if common.get_username() == t97.AUTHOR then
			p258:write_bits(t97.DEV_ID, 32)
		end

		p258:crypt(t97.SECURITY_KEY)
	end)
end

icon:set_callback(function(p259)
	-- upvalues: v381 (copy)
	if not p259:get() then
		v381()
	end
end)

function t96.render()
	-- upvalues: icon (copy), t97 (copy), t98 (copy), n62 (ref), v382 (copy), t99 (ref)
	if icon:get() then
		local v1288 = entity.get_local_player()

		if v1288 then
			v1288:set_icon(common.get_username() == t97.AUTHOR and t98.dev or t98.user)

			if math.abs(globals.realtime - n62) > 1 then
				v382()
				n62 = globals.realtime
			end

			local server_tick = globals.server_tick
			local v1290 = entity.get_players(false, true)
			local t100 = {}

			for _, v in ipairs(v1290) do
				local v1294 = v:get_xuid()

				t100[v1294] = true

				local v1295 = t99[v1294]

				if v1295 then
					if not (to_time(server_tick - v1295.last_heartbeat) > 3) then
						v:set_icon(v1295.is_author and t98.dev or t98.user)
					else
						t99[v1294] = nil
						v:set_icon()
					end
				end
			end

			for k, _ in pairs(t99) do
				if not t100[k] then
					t99[k] = nil
				end
			end

			return
		end

		return
	end
end
function t96.voice_message(p260)
	-- upvalues: t97 (copy), t99 (ref)
	local entity2 = p260.entity

	if entity2 and entity2 ~= entity.get_local_player() then
		local buffer = p260.buffer

		buffer:crypt(t97.SECURITY_KEY)

		local v1301 = buffer:read_bits(32)
		local v1302 = buffer:read_bits(32) == t97.DEV_ID

		if v1301 == t97.ID then
			t99[entity2:get_xuid()] = {
				last_heartbeat = globals.server_tick,
				player = entity2,
				is_author = v1302
			}
		end

		return
	end
end
function t96.shutdown()
	local v1303 = entity.get_local_player()

	if v1303 then
		v1303:set_icon()

		return
	end
end
function t58.shutdown()
	-- upvalues: t78 (copy), t68 (copy), t87 (copy), t72 (copy), t96 (copy), t67 (copy)
	t78.shutdown()
	t68.shutdown()
	t87.shutdown()
	t72.shutdown()
	t96.shutdown()
	t67.shutdown()
end
function t58.createmove_run(p261)
	-- upvalues: t72 (copy)
	t72.createmove_run(p261)
end
function t58.voice_message(p262)
	-- upvalues: t96 (copy)
	t96.voice_message(p262)
end
function t58.createmove(p263)
	-- upvalues: t74 (copy), t75 (copy), t76 (copy), t79 (copy), t86 (copy), t88 (copy), t72 (copy)
	t74.createmove(p263)
	t75.createmove(p263)
	t76.createmove(p263)
	t79.createmove(p263)
	t86.createmove(p263)
	t88.createmove(p263)
	t72.createmove(p263)
end
function t58.aim_ack(p264)
	-- upvalues: t92 (copy), t64 (copy)
	t92.aim_ack(p264)

	if p264.state then
		t64:update("misses")
	else
		t64:update("hits")
	end
end
function t58.player_death(_)
end
function t58.round_start()
	-- upvalues: t88 (copy), t73 (copy)
	t88.round_start()
	t73.round_start()
end
function t58.grenade_prediction(p266)
	-- upvalues: t76 (copy)
	t76.grenade_prediction(p266)
end
function t58.grenade_override_view(p267)
	-- upvalues: t77 (copy)
	t77.grenade_override_view(p267)
end
function t58.net_update_end()
	-- upvalues: t67 (copy), t68 (copy), t96 (copy)
	t67.net_update_end()
	t68.render()
	t96.render()
end
function t58.override_view(p268)
	-- upvalues: t72 (copy)
	t72.override_view(p268)
end
function t58.level_init()
	-- upvalues: t59 (copy), t64 (copy)
	t59.level_init()
	t64:reset()
end
function t58.level_shutdown()
	-- upvalues: t59 (copy)
	t59.level_shutdown()
end
function t58.localplayer_transparency(p269)
	-- upvalues: t84 (copy)
	return t84.localplayer_transparency(p269)
end

u37.render(function()
	-- upvalues: t58 (copy), t50 (copy)
	t58.render()
	t50.render()
end)
u37.createmove(function(p270)
	-- upvalues: t19 (copy), t50 (copy), t58 (copy)
	t19.createmove(p270)
	t50.createmove(p270)
	t58.createmove(p270)
end)
u37.voice_message(function(p271)
	-- upvalues: t58 (copy)
	t58.voice_message(p271)
end)
u37.override_view(function(p272)
	-- upvalues: t58 (copy)
	t58.override_view(p272)
end)
u37.aim_ack(function(p273)
	-- upvalues: t58 (copy)
	t58.aim_ack(p273)
end)
u37.player_death(function(p274)
	-- upvalues: t58 (copy)
	t58.player_death(p274)
end)
u37.round_start(function()
	-- upvalues: t58 (copy)
	t58.round_start()
end)
u37.run_command(function(p275)
	-- upvalues: t19 (copy)
	t19.run_command(p275)
end)
u37.net_update_end(function()
	-- upvalues: t19 (copy), t58 (copy)
	t19.net_update_end()
	t58.net_update_end()
end)
u37.post_update_clientside_animation(function(p276)
	-- upvalues: t50 (copy)
	t50.post_update_clientside_animation(p276)
end)
u37.setup_command(function(p277)
	-- upvalues: t19 (copy)
	t19.setup_command(p277)
end)
u37.createmove_run(function(p278)
	-- upvalues: t58 (copy)
	t58.createmove_run(p278)
end)
u37.grenade_override_view(function(p279)
	-- upvalues: t58 (copy)
	t58.grenade_override_view(p279)
end)
u37.grenade_prediction(function(p280)
	-- upvalues: t58 (copy)
	t58.grenade_prediction(p280)
end)
u37.shutdown(function()
	-- upvalues: t58 (copy), t50 (copy)
	t58.shutdown()
	t50.shutdown()
end)
u37.level_init(function()
	-- upvalues: t58 (copy)
	t58.level_init()
end)
u37.level_shutdown(function()
	-- upvalues: t58 (copy)
	t58.level_shutdown()
end)
u37.localplayer_transparency(function(p281)
	-- upvalues: t58 (copy)
	return t58.localplayer_transparency(p281)
end)
utils.execute_after(0.1, print_raw, string.format(pui.string("\vnexus\r loaded in \v%.2f\r ms"), (v1() - v89) * 1000))

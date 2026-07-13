-- Создаем элементы интерфейса в вкладке MISC -> Miscellaneous
local fps_boost_toggle = ui.new_checkbox("LUA", "A", "⚡ FPS optmization")

-- Таблица с вашими консольными командами для оптимизации
local optimization_cvars = {
    cl_forcepreload = "1",
    cl_logofile = "0",
    cl_disablehtmlmotd = "1",
    cl_disablefreezecam = "1",
    cl_autohelp = "0",
    cl_showhelp = "0",
    cl_hud_playercount_showcount = "1",
    cl_detail_avoid_force = "0",
    cl_detail_avoid_radius = "0",
    cl_detail_avoid_recover_speed = "0",
    cl_detail_max_sway = "0",
    cl_windspeed = "0",
    cl_wpn_sway_scale = "1",
    func_break_max_pieces = "0",
    fps_max = "0",
    gameinstructor_enable = "0",
    mat_hdr_enabled = "0",
    mat_queue_mode = "2",
    muzzleflash_light = "0",
    net_allow_multicast = "0",
    r_avglight = "1",
    r_avglightmap = "0",
    r_drawtracers_firstperson = "0",
    r_dynamic = "0",
    r_eyegloss = "0",
    r_eyemove = "0",
    r_eyeshift_x = "0",
    r_eyeshift_y = "0",
    r_eyeshift_z = "0",
    r_eyesize = "0",
    r_cheapwaterend = "1",
    r_cheapwaterstart = "1",
    sv_forcepreload = "1",
    sys_antialiasing = "0",
    sys_aspectratio = "-1",
    sys_refldetail = "0",
    r_shadows = "0",
    r_drawdecals = "0",
    r_3dsky = "0",
    r_rootlod = "2",
    mat_postprocess_enable = "0",
    mat_disable_bloom = "1",
    mat_force_vertex_lighting = "1",
    r_drawparticles = "0",
    r_modellod = "2",
    r_waterforceexpensive = "0",
    r_waterforcereflectentities = "0",
    mat_trilinear = "0",
    mat_forceanisotropic = "0",
    mat_disable_fancy_blending = "1",
    mat_disable_lightwarp = "1",
    mat_bumpmap = "0",
    mat_specular = "0",
    mat_parallaxmap = "0",
    mat_fastspecular = "1",
    mat_filterlightmaps = "1",
    mat_reducefillrate = "1",
    mat_compressedtextures = "1",
    r_lightaverage = "0",
    mat_picmip = "2",
    mat_antialias = "0",
    mat_vsync = "0",
    cl_teamid_overhead = "0",
    cl_phys_props_max = "0",
    cl_smooth = "0",
    hud_showtargetid = "0",
    glow_outline_effect_enable = "0",
    violence_agibs = "0",
    violence_hgibs = "0",
    violence_hblood = "0",
    violence_ablood = "0",
    cl_ragdoll_physics_enable = "0",
    props_break_max_pieces = "0",
    cl_phys_objects_max = "0",
    cl_playerspraydisable = "1",
    cl_foot_contact_shadows = "0",
    rate = "128000",
    cl_cmdrate = "64",
    cl_updaterate = "64",
    cl_interp = "0.0156",
    cl_interp_ratio = "1",
    snd_mixahead = "0.1",
    r_lightinterp = "0",
    r_ambientfraction = "0.1",
    cl_csm_enabled = "0",
    r_drawtracers = "0"
}

-- Таблица для бэкапа дефолтных значений игры (чтобы вернуть всё назад при выключении)
local default_cvars = {
    cl_forcepreload = "0", cl_logofile = "1", cl_disablehtmlmotd = "0", cl_disablefreezecam = "0",
    cl_autohelp = "1", cl_showhelp = "1", cl_hud_playercount_showcount = "0", cl_detail_avoid_force = "0.4",
    cl_detail_avoid_radius = "64", cl_detail_avoid_recover_speed = "0.25", cl_detail_max_sway = "5",
    cl_windspeed = "0", cl_wpn_sway_scale = "1.0", func_break_max_pieces = "15", fps_max = "400",
    gameinstructor_enable = "1", mat_hdr_enabled = "1", mat_queue_mode = "-1", muzzleflash_light = "1",
    net_allow_multicast = "1", r_avglight = "1", r_avglightmap = "0", r_drawtracers_firstperson = "1",
    r_dynamic = "1", r_eyegloss = "1", r_eyemove = "1", r_eyeshift_x = "0", r_eyeshift_y = "0",
    r_eyeshift_z = "0", r_eyesize = "0", r_cheapwaterend = "0", r_cheapwaterstart = "0",
    sv_forcepreload = "0", sys_antialiasing = "1", sys_aspectratio = "-1", sys_refldetail = "0",
    r_shadows = "1", r_drawdecals = "1", r_3dsky = "1", r_rootlod = "0", mat_postprocess_enable = "1",
    mat_disable_bloom = "0", mat_force_vertex_lighting = "0", r_drawparticles = "1", r_modellod = "0",
    r_waterforceexpensive = "1", r_waterforcereflectentities = "1", mat_trilinear = "1",
    mat_forceanisotropic = "1", mat_disable_fancy_blending = "0", mat_disable_lightwarp = "0",
    mat_bumpmap = "1", mat_specular = "1", mat_parallaxmap = "1", mat_fastspecular = "0",
    mat_filterlightmaps = "0", mat_reducefillrate = "0", mat_compressedtextures = "0",
    r_lightaverage = "1", mat_picmip = "0", mat_antialias = "1", mat_vsync = "0",
    cl_teamid_overhead = "1", cl_phys_props_max = "300", cl_smooth = "1", hud_showtargetid = "1",
    glow_outline_effect_enable = "1", violence_agibs = "1", violence_hgibs = "1", violence_hblood = "1",
    violence_ablood = "1", cl_ragdoll_physics_enable = "1", props_break_max_pieces = "50",
    cl_phys_objects_max = "300", cl_playerspraydisable = "0", cl_foot_contact_shadows = "1",
    rate = "196608", cl_cmdrate = "64", cl_updaterate = "64", cl_interp = "0.031",
    cl_interp_ratio = "2", snd_mixahead = "0.025", r_lightinterp = "5", r_ambientfraction = "0.2",
    cl_csm_enabled = "1", r_drawtracers = "1"
}

-- Функция применения конваров
local function apply_cvars(cvar_table)
    for cvar, value in pairs(cvar_table) do
        client.set_cvar(cvar, value)
    end
end

-- Обработчик изменения состояния чекбокса
local function on_fps_boost_changed()
    if ui.get(fps_boost_toggle) then
        apply_cvars(optimization_cvars)
        client.log("⚡ Настройки оптимизации успешно применены!")
    else
        apply_cvars(default_cvars)
        client.log("ℹ️  Возвращены стандартные настройки графики.")
    end
end

-- Регистрируем колбэк на клик по чекбоксу
ui.set_callback(fps_boost_toggle, on_fps_boost_changed)

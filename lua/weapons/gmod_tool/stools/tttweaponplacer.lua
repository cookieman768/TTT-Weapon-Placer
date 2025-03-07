
TOOL.Category = "Trouble in Terrorist Town"
TOOL.Name = "TTT Weapon Placer"
TOOL.Command = nil
TOOL.ConfigName = ""

TOOL.ClientConVar["weapon"] = "weapon_zm_pistol"
TOOL.ClientConVar["frozen"] = "0"
TOOL.ClientConVar["replacespawns"] = "0"


cleanup.Register("ttt_weapons")


if CLIENT then
   language.Add("tool.tttweaponplacer.name", "TTT Weapon Placer" )
   language.Add("tool.tttweaponplacer.desc", "Spawn TTT weapon dummies and export their placement" )
   language.Add("tool.tttweaponplacer.0", "Left click to spawn entity. Right click for matching ammo." )
   language.Add("Cleanup_ttt_weapons", "TTT Dummy Weapons/ammo/spawns")
   language.Add("Undone_TTTWeapon", "Undone TTT item" )
end

local weps = {
   weapon_zm_pistol = {name="Pistol", snd="item_ammo_pistol_ttt"},
   weapon_zm_shotgun = {name="Shotgun", snd="item_box_buckshot_ttt"},
   weapon_zm_mac10 = {name="MAC10", snd="item_ammo_smg1_ttt"},
   weapon_zm_revolver = {name="Deagle", snd="item_ammo_revolver_ttt"},
   weapon_zm_rifle = {name="Rifle", snd="item_ammo_357_ttt"},
   weapon_zm_sledge = {name="HUGE249", snd=nil},
   weapon_zm_molotov = {name="Fire nade", snd=nil},

   weapon_ttt_confgrenade = {name="Discombobulator", snd=nil},
   weapon_ttt_smokegrenade = {name="Smoke nade", snd=nil},
   weapon_ttt_m16 = {name="M16", snd="item_ammo_pistol_ttt"},
   weapon_ttt_glock = {name="Glock", snd="item_ammo_pistol_ttt"},

   ttt_random_weapon = {name="Random weapon", snd="ttt_random_ammo"},
   ttt_random_ammo = {name="Random ammo", snd=nil},

   ttt_playerspawn = {name="Player spawn", snd=nil},
   
   --Custom Weapons
   --weapon_ttt_aug = {name="Aug",snd="item_ammo_smg1_ttt"},
   --weapon_ttt_famas = {name="Famas",snd="item_ammo_smg1_ttt"},
   --weapon_ttt_galil = {name="Galil",snd="item_ammo_smg1_ttt"},
   --weapon_ttt_magnum = {name="Magnum",snd="item_ammo_revolver_ttt"},
   --weapon_ttt_p90 = {name="P90",snd="item_ammo_smg1_ttt"},
   --weapon_ttt_p228 = {name="P228", snd="item_ammo_pistol_ttt"},
   --weapon_ttt_pump_shotgun = {name="Pump Shotgun", snd="item_box_buckshot_ttt"},
   --weapon_ttt_sg552 = {name="SG552",snd = "item_ammo_pistol_ttt"},
   --weapon_ttt_smg = {name="SMG",snd="item_ammo_smg1_ttt"},
   --weapon_ttt_revolver ={name="Revolver",snd="models/weapons/w_smg1.mdl"}
   weapon_cr_grenade_frag = {name="Crescent Frag", snd=nil},
   weapon_cr_grenade_flashbang = {name="Crescent Flash", snd=nil}
}

local mdls = {
   weapon_zm_pistol = "models/weapons/w_pist_fiveseven.mdl",
   weapon_zm_shotgun = "models/weapons/w_shot_xm1014.mdl",
   weapon_zm_mac10 = "models/weapons/w_smg_mac10.mdl",
   weapon_zm_revolver = "models/weapons/w_pist_deagle.mdl",
   weapon_zm_rifle = "models/weapons/w_snip_scout.mdl",
   weapon_zm_sledge = "models/weapons/w_mach_m249para.mdl",
   weapon_zm_molotov = "models/weapons/w_eq_flashbang.mdl",

   weapon_ttt_confgrenade = "models/weapons/w_eq_fraggrenade.mdl",
   weapon_ttt_smokegrenade = "models/weapons/w_eq_smokegrenade.mdl",
   weapon_ttt_m16 = "models/weapons/w_rif_m4a1.mdl",
   weapon_ttt_glock = "models/weapons/w_pist_glock18.mdl",

   ttt_random_weapon = "models/weapons/w_shotgun.mdl",
   ttt_random_ammo = "models/Items/battery.mdl",

   item_ammo_pistol_ttt= "models/items/boxsrounds.mdl",
   item_ammo_smg1_ttt= "models/items/boxmrounds.mdl",
   item_ammo_revolver_ttt = "models/items/357ammo.mdl",
   item_ammo_357_ttt = "models/items/357ammo.mdl",
   item_box_buckshot_ttt = "models/items/boxbuckshot.mdl",

   ttt_playerspawn = "models/player.mdl",
   
   --weapon_ttt_aug = "models/weapons/w_rif_aug.mdl",
   --weapon_ttt_famas = "models/weapons/w_rif_famas.mdl",
   --weapon_ttt_galil = "models/weapons/w_rif_galil.mdl",
   --weapon_ttt_magnum = "models/weapons/w_357.mdl",
   --weapon_ttt_p90 = "models/weapons/w_smg_p90.mdl",
   --weapon_ttt_p228 = "models/weapons/w_pist_p228.mdl",
   --weapon_ttt_pump_shotgun = "models/weapons/w_shot_m3super90.mdl",
   --weapon_ttt_sg552 = "models/weapons/w_rif_sg552.mdl",
   --weapon_ttt_smg = "models/weapons/w_smg1.mdl",
   --weapon_ttt_revolver = "models/weapons/w_pist_deagle.mdl"
   
   
   weapon_cr_grenade_frag = {name="Crescent Frag", snd=nil},
   weapon_cr_grenade_flashbang = {name="Crescent Flash", snd=nil}
   
   
   
};

-- special colours for certain ents
local colors = {
   ttt_random_weapon = Color(255, 255, 0),
   ttt_random_ammo = Color(0, 255, 0),
   item_ammo_revolver_ttt = Color(255, 100, 100),
   ttt_playerspawn = Color(0, 255, 0)
};

local function DummyInit(s)
   if colors[s:GetClass()] then
      local c = colors[s:GetClass()]
      s:SetColor(c)
   end

   s:SetCollisionGroup(COLLISION_GROUP_WEAPON)
   s:SetSolid(SOLID_VPHYSICS)
   s:SetMoveType(MOVETYPE_VPHYSICS)

   if s:GetClass() == "ttt_playerspawn" then
      s:PhysicsInitBox(Vector(-18, -18, -0.1), Vector(18, 18, 66))
      s:SetPos(s:GetPos() + Vector(0, 0, 1))
   else
      s:PhysicsInit(SOLID_VPHYSICS)
   end

   s:SetModel(s.Model)
end

for cls, mdl in pairs(mdls) do
   local tbl = {
      Type = "anim",
      Model = Model(mdl),
      Initialize = DummyInit
   };

   scripted_ents.Register(tbl, cls, false)
end

function TOOL:SpawnEntity(cls, trace)
   local mdl = mdls[cls]

   if not cls or not mdl then return end

   local ent = ents.Create(cls)
   ent:SetModel(mdl)
   ent:SetPos(trace.HitPos)

   local tr = util.TraceEntity({start=trace.StartPos, endpos=trace.HitPos, filter=self:GetOwner()}, ent)
   if tr.Hit then
      ent:SetPos(tr.HitPos)
   end

   ent:Spawn()

   ent:PhysWake()

   undo.Create("TTTWeapon")
   undo.AddEntity(ent)
   undo.SetPlayer(self:GetOwner())
   undo.Finish()

   self:GetOwner():AddCleanup("ttt_weapons", ent)
end

function TOOL:LeftClick( trace )
   local cls = self:GetClientInfo("weapon")

   self:SpawnEntity(cls, trace)
end

function TOOL:RightClick( trace )
   local cls = self:GetClientInfo("weapon")
   local info = weps[cls]
   if not info then return end

   local ammo = info.snd
   if not ammo then
      self:GetOwner():ChatPrint("No matching ammo for this type!")
      return
   end

   self:SpawnEntity(info.snd, trace)
end

function TOOL.BuildCPanel(panel) -- note that this is not a method, REAL NICE
   panel:AddControl( "Header", { Text = "tool.tttweaponplacer.name", Description = language.GetPhrase("tool.tttweaponplacer.desc")})

   local opts = {}
   for w, info in pairs(weps) do
      opts[info.name] = {tttweaponplacer_weapon = w}
   end

   panel:AddControl("ListBox", { Label = "Weapons", Height = "200", Options = opts } )

   panel:AddControl("Button", {Label="Report counts", Command="tttweaponplacer_count", Text="Count"})

   panel:AddControl("Label", {Text="Export", Description="Export weapon placements"})

   panel:AddControl("CheckBox", {Label="Replace existing player spawnpoints", Command="tttweaponplacer_replacespawns", Text="Replace spawns"})

   panel:AddControl( "Button",  { Label	= "Export to file", Command = "tttweaponplacer_queryexport", Text = "Export"})

   panel:AddControl("Label", {Text="Import", Description="Import weapon placements"})

   panel:AddControl( "Button",  { Label	= "Import from file", Command = "tttweaponplacer_queryimport", Text = "Import"})

   panel:AddControl("Button", {Label="Convert HL2 entities", Command = "tttweaponplacer_replacehl2", Text="Convert"})

   panel:AddControl("Button", {Label="Remove all existing weapon/ammo", Command = "tttweaponplacer_removeall", Text="Remove all existing items"})
end

-- STOOLs not being loaded on client = headache bonanza
if CLIENT then
   function QueryFileExists()

      local map = string.lower(game.GetMap())
      if not map then return end

      local fname = "ttt/maps/" .. map .. "_ttt.txt"

      if file.Exists(fname, "DATA") then
         Derma_StringRequest("File exists", "The file \"" .. fname .. "\" already exists. Save under a different filename? Leave unchanged to overwrite.",
                             fname,
                             function(txt)
                                RunConsoleCommand("tttweaponplacer_export", txt)
                             end)
      else
         RunConsoleCommand("tttweaponplacer_export")
      end
   end

   function QueryImportName()
      local map = string.lower(game.GetMap())
      if not map then return end

      local fname = "ttt/maps/" .. map .. "_ttt.txt"

      Derma_StringRequest("Import", "What file do you want to import? Note that files meant for other maps will result in crazy things happening.",
                          fname,
                          function(txt)
                             RunConsoleCommand("tttweaponplacer_import", txt)
                          end)

   end
else
   -- again, hilarious things happen when this shit is used in mp
   concommand.Add("tttweaponplacer_queryexport", function() BroadcastLua("QueryFileExists()") end)
   concommand.Add("tttweaponplacer_queryimport", function() BroadcastLua("QueryImportName()") end)
end

WEAPON_PISTOL = 1
WEAPON_HEAVY = 2
WEAPON_NADE = 3
WEAPON_RANDOM = 4

PLAYERSPAWN = 5

local enttypes = {
   weapon_zm_pistol = WEAPON_PISTOL,
   weapon_zm_revolver = WEAPON_PISTOL,
   weapon_ttt_glock = WEAPON_PISTOL,

   weapon_zm_mac10 = WEAPON_HEAVY,
   weapon_zm_shotgun = WEAPON_HEAVY,
   weapon_zm_rifle = WEAPON_HEAVY,
   weapon_zm_sledge = WEAPON_HEAVY,
   weapon_ttt_m16 = WEAPON_HEAVY,

   weapon_zm_molotov = WEAPON_NADE,
   weapon_ttt_smokegrenade = WEAPON_NADE,
   weapon_ttt_confgrenade = WEAPON_NADE,

   ttt_random_weapon = WEAPON_RANDOM,

   ttt_playerspawn = PLAYERSPAWN
};

local function PrintCount(ply)
   local count = {
      [WEAPON_PISTOL] = 0,
      [WEAPON_HEAVY] = 0,
      [WEAPON_NADE] = 0,
      [WEAPON_RANDOM] = 0,
      [PLAYERSPAWN] = 0
   };

   for cls, t in pairs(enttypes) do
      for _, ent in pairs(ents.FindByClass(cls)) do
         count[t] = count[t] + 1
      end
   end

   ply:ChatPrint("Entity count (use report_entities in console for more detail):")
   ply:ChatPrint("Primary weapons: " .. count[WEAPON_HEAVY])
   ply:ChatPrint("Secondary weapons: " .. count[WEAPON_PISTOL])
   ply:ChatPrint("Grenades: " .. count[WEAPON_NADE])
   ply:ChatPrint("Random weapons: " .. count[WEAPON_RANDOM])
   ply:ChatPrint("Player spawns: " .. count[PLAYERSPAWN])
end
concommand.Add("tttweaponplacer_count", PrintCount)

-- This shit will break terribly in MP
if SERVER or CLIENT then
   -- Could just do a GLON dump, but it's nice if the "scripts" are sort of
   -- human-readable so it's easy to go in and delete all pistols or something.
   local function Export(ply, cmd, args)
      if not IsValid(ply) then return end

      local map = string.lower(game.GetMap())

      if not map then return end

      --local frozen_only = GetConVar("tttweaponplacer_frozen"):GetBool()
      local frozen_only = false

      -- Nice header, # is comment
      local buf =  "# Trouble in Terrorist Town weapon/ammo placement overrides\n"
      buf = buf .. "# For map: " .. map .. "\n"
      buf = buf .. "# Exported by: " .. ply:Nick() .. "\n"

      -- Write settings ("setting: <name> <value>")
      local rspwns = GetConVar("tttweaponplacer_replacespawns"):GetBool() and "1" or "0"
      buf = buf .. "setting:\treplacespawns " .. rspwns .. "\n"

      local num = 0
      for cls, mdl in pairs(mdls) do
         for _, ent in pairs(ents.FindByClass(cls)) do
            if IsValid(ent) then
               if not frozen_only or not ent:GetPhysicsObject():IsMoveable() then
                  num = num + 1
                  buf = buf .. Format("%s\t%s\t%s\n", cls, tostring(ent:GetPos()), tostring(ent:GetAngles()))
               end
            end
         end
      end

      local fname = "ttt/maps/" .. map .. "_ttt.txt"

      if args[1] then
         fname = args[1]
      end

      file.CreateDir("ttt/maps")
      file.Write(fname, buf)

      if not file.Exists(fname, "DATA") then
         ErrorNoHalt("Exported file not found. Bug?\n")
      end

      ply:ChatPrint(num .. " placements saved to /garrysmod/data/" .. fname)
   end
   concommand.Add("tttweaponplacer_export", Export)

   local function SpawnDummyEnt(cls, pos, ang)
      if not cls or not pos or not ang then return false end

      local mdl = mdls[cls]
      if not mdl then return end

      local ent = ents.Create(cls)
      ent:SetModel(mdl)
      ent:SetPos(pos)
      ent:SetAngles(ang)
      ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
      ent:SetSolid(SOLID_VPHYSICS)
      ent:SetMoveType(MOVETYPE_VPHYSICS)
      ent:PhysicsInit(SOLID_VPHYSICS)

      ent:Spawn()

      local phys = ent:GetPhysicsObject()
      if IsValid(phys) then
         phys:SetAngles(ang)
      end
   end


   local function Import(ply, cmd, args)
      if not IsValid(ply) then return end
      local map = string.lower(game.GetMap())
      if not map then return end

      local fname = "ttt/maps/" .. map .. "_ttt.txt"

      if args[1] then
         fname = args[1]
      end

      if not file.Exists(fname, "DATA") then
         ply:ChatPrint(fname .. " not found!")
         return
      end

      local buf = file.Read(fname, "DATA")
      local lines = string.Explode("\n", buf)
      local num = 0
      for k, line in ipairs(lines) do
         if not string.match(line, "^#") and line != "" then
            local data = string.Explode("\t", line)

            local fail = true -- pessimism

            if #data > 0 then
               if data[1] == "setting:" and tostring(data[2]) then
                  local raw = string.Explode(" ", data[2])
                  RunConsoleCommand("tttweaponplacer_" .. raw[1], tonumber(raw[2]))

                  fail = false
                  num = num - 1
               elseif #data == 3 then
                  local cls = data[1]
                  local ang = nil
                  local pos = nil

                  local posraw = string.Explode(" ", data[2])
                  pos = Vector(tonumber(posraw[1]), tonumber(posraw[2]), tonumber(posraw[3]))

                  local angraw = string.Explode(" ", data[3])
                  ang = Angle(tonumber(angraw[1]), tonumber(angraw[2]), tonumber(angraw[3]))

                  fail = SpawnDummyEnt(cls, pos, ang)
               end
            end

            if fail then
               ErrorNoHalt("Invalid line " .. k .. " in " .. fname .. "\n")
            else
               num = num + 1
            end
         end
      end

      ply:ChatPrint("Spawned " .. num .. " dummy ents")
   end
   concommand.Add("tttweaponplacer_import", Import)

   local function RemoveAll(ply, cmd, args)
      if not IsValid(ply) then return end

      local num = 0
      local delete = function(ent)
                        if not IsValid(ent) then return end
                        print("\tRemoving", ent, ent:GetClass())
                        ent:Remove()
                        num = num + 1
                     end

      print("Removing ammo...")
      for k, ent in pairs(ents.FindByClass("item_*")) do
         delete(ent)
      end
      for k, ent in pairs(ents.FindByClass("ttt_random_ammo")) do
         delete(ent)
      end

      print("Removing weapons...")
      for k, ent in pairs(ents.FindByClass("weapon_*")) do
         delete(ent)
      end
      for k, ent in pairs(ents.FindByClass("ttt_random_weapon")) do
         delete(ent)
      end

      ply:ChatPrint("Removed " .. num .. " weapon/ammo ents")
   end
   concommand.Add("tttweaponplacer_removeall", RemoveAll)

   local hl2_replace = {
      ["item_ammo_pistol"] = "item_ammo_pistol_ttt",
      ["item_box_buckshot"] = "item_box_buckshot_ttt",
      ["item_ammo_smg1"] = "item_ammo_smg1_ttt",
      ["item_ammo_357"] = "item_ammo_357_ttt",
      ["item_ammo_357_large"] = "item_ammo_357_ttt",
      ["item_ammo_revolver"] = "item_ammo_revolver_ttt", -- zm
      ["item_ammo_ar2"] = "item_ammo_pistol_ttt",
      ["item_ammo_ar2_large"] = "item_ammo_smg1_ttt",
      ["item_ammo_smg1_grenade"] = "weapon_zm_pistol",
      ["item_battery"] = "item_ammo_357_ttt",
      ["item_healthkit"] = "weapon_zm_shotgun",
      ["item_suitcharger"] = "weapon_zm_mac10",
      ["item_ammo_ar2_altfire"] = "weapon_zm_mac10",
      ["item_rpg_round"] = "item_ammo_357_ttt",
      ["item_ammo_crossbow"] = "item_box_buckshot_ttt",
      ["item_healthvial"] = "weapon_zm_molotov",
      ["item_healthcharger"] = "item_ammo_revolver_ttt",
      ["item_ammo_crate"] = "weapon_ttt_confgrenade",
      ["item_item_crate"] = "ttt_random_ammo",
      ["weapon_smg1"] = "weapon_zm_mac10",
      ["weapon_shotgun"] = "weapon_zm_shotgun",
      ["weapon_ar2"] = "weapon_ttt_m16",
      ["weapon_357"] = "weapon_zm_rifle",
      ["weapon_crossbow"] = "weapon_zm_pistol",
      ["weapon_rpg"] = "weapon_zm_sledge",
      ["weapon_slam"] = "item_ammo_pistol_ttt",
      ["weapon_frag"] = "weapon_zm_revolver",
      ["weapon_crowbar"] = "weapon_zm_molotov"
   };

   local function ReplaceSingle(ent, newname)
      if ent:GetPos() == vector_origin then
         return false
      end

      if ent:IsWeapon() and IsValid(ent:GetOwner()) and ent:GetOwner():IsPlayer() then
         return false
      end

      ent:SetSolid(SOLID_NONE)

      local rent = ents.Create(newname)
      rent:SetModel(mdls[newname])
      rent:SetPos(ent:GetPos())
      rent:SetAngles(ent:GetAngles())
      rent:Spawn()

      rent:Activate()
      rent:PhysWake()

      ent:Remove()
      return true
   end

   local function ReplaceHL2Ents(ply, cmd, args)
      if not IsValid(ply) then return end

      local c = 0
      for _, ent in pairs(ents.GetAll()) do
         local rpl = hl2_replace[ent:GetClass()]
         if rpl then
            local success = ReplaceSingle(ent, rpl)
            if success then
               c = c + 1
            end
         end
      end

      ply:ChatPrint("Replaced " .. c .. " HL2 entities with TTT versions.")
   end
   concommand.Add("tttweaponplacer_replacehl2", ReplaceHL2Ents)
end

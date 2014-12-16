local ADDON_NAME, Engine = ...

local L = Engine.Locales
local C = Engine.Config

C.InstanceOnly = false
C.NoToggleInCombat = true

C.RaidBuffs = {
	-- http://www.wowhead.com/guide=1100
	["Stats"] = {
		[1126] = "DRUID",			-- Mark of the Wild
		[20217] = "PALADIN",		-- Blessing Of Kings
		[90363] = "HUNTER",			-- Shale Spider - Embrace of the Shale Spider
		[115921] = "MONK",			-- Legacy of the Emperor
		[116781] = "MONK",			-- Legacy of the White Tiger
		[159988] = "HUNTER",		-- Dog - Bark of the Wild
		[160017] = "HUNTER",		-- Gorilla - Blessing of Kongs
		[160077] = "HUNTER",		-- Worm - Strength of the Earth
		[160206] = "HUNTER",		-- Lone Wolf - Power of the Primates	
		["default"] = 20217,
		["name"] = L.raidbuffschecker_stats
	},
	["Stamina"] = {
		[469] = "WARRIOR",			-- Commanding Shout
		[21562] = "PRIEST",			-- Power Word:  Fortitude
		[50256] = "HUNTER",			-- Bear - Invigorating Roar
		[90364] = "HUNTER",			-- Silithid - Qiraji Fortitude
		[160003] = "HUNTER",		-- Rylak - Savage Vigor
		[160014] = "HUNTER",		-- Goat - Sturdiness
		[166928] = "WARLOCK",		-- Blood Pact
		[160199] = "HUNTER",		-- Lone Wolf - Fortitude of the Bear
		["default"] = 21562,
		["name"] = L.raidbuffschecker_stamina
	},
	["AttackPower"] = {
		[6673] = "WARRIOR",			-- Battle Shout
		[19506] = "HUNTER",			-- Trueshot Aura
		[57330] = "DEATHKNIGHT",	-- Horn of Winter
		["default"] = 57330,
		["name"] = L.raidbuffschecker_attackpower
	},
	["SpellPower"] = {
		[1459] = "MAGE",			-- Arcane Brilliance
		[61316] = "MAGE",			-- Dalaran Brilliance
		[90364] = "HUNTER",			-- Silithid - Qiraji Fortitude
		[109773] = "WARLOCK",		-- Dark Intent
		[126309] = "HUNTER",		-- Waterstrider - Still Water
		[128433] = "HUNTER",		-- Serpent - Serpent's Cunning
		[160205] = "HUNTER",		-- Lone Wolf - Wisdom of the Serpent
		["default"] = 1459,
		["name"] = L.raidbuffschecker_spellpower
	},
	["Haste"] = {
		[55610] = "DEATHKNIGHT",	-- Unholy Aura
		[49868] = "PRIEST",			-- Mind Quickening
		[116956] = "SHAMAN",		-- Grace of Air
		[128432] = "HUNTER",		-- Hyena - Cackling Howl
		[160003] = "HUNTER",		-- Rylak - Savage Vigor
		[113742] = "ROGUE",			-- Swiftblade's Cunning
		[135678] = "HUNTER",		-- Sporebat - Energizing Spores
		[160074] = "HUNTER",		-- Wasp - Speed of the Swarm
		[160203] = "HUNTER",		-- Lone Wolf - Haste of the Hyena
		["default"] = 55610,
		["name"] = L.raidbuffschecker_haste
	},
	["CriticalStrike"] = {
		[1459] = "MAGE",			-- Arcane Brilliance
		[24932] = "DRUID",			-- Leader of the Pack
		[24604] = "HUNTER",			-- Wolf - Furious Howl
		[61316] = "MAGE",			-- Dalaran Brilliance
		[90309] = "HUNTER",			-- Devilsaur - Terrifying Roar
		[90363] = "HUNTER",			-- Shale Spider - Embrace of the Shale Spider
		[116781] = "MONK",			-- Legacy of the White Tiger
		[126309] = "HUNTER",		-- Waterstrider - Still Water
		[126373] = "HUNTER",		-- Quilen - Fearless Roar
		[160052] = "HUNTER",		-- Raptor - Strength of the Pack
		[160200] = "HUNTER",		-- Lone Wolf - Ferocity of the Raptor
		["default"] = 116781,
		["name"] = L.raidbuffschecker_criticalstrike
	},
	["Mastery"] = {
		[19740] = "PALADIN",		-- Blessing of Might
		[24907] = "DRUID",			-- Moonkin Aura
		[93435] = "HUNTER",			-- Cat - Roar of Courage
		[128997] = "HUNTER",		-- Spirit Beast - Spirit Beast Blessing
		[116956] = "SHAMAN",		-- Grace of Air
		[155522] = "DEATHKNIGHT",	-- Power of the Grave
		[160039] = "HUNTER",		-- Hydra - Keen Senses
		[160073] = "HUNTER",		-- Tallstrider - Plainswalking
		[160198] = "HUNTER",		-- Lone Wolf - Grace of the Cat
		["default"] = 19740,
		["name"] = L.raidbuffschecker_mastery
	},
	["BurstHaste"] = {
		[2825] = "SHAMAN",			-- Bloodlust
		[32182] = "SHAMAN",			-- Heroism
		[80353] = "MAGE",			-- Time Warp
		[90355] = "HUNTER",			-- Ancient Hysteria
		[160452] = "HUNTER",		-- Nether Ray - Netherwinds
		["default"] = 80353,
		["name"] = L.raidbuffschecker_bursthaste
	},
	["Multistrike"] = {
		[24844] = "HUNTER",			-- Wind Serpent - Breath of the Winds
		[34889] = "HUNTER",			-- Dragonhawk - Spry Attacks
		[49868] = "PRIEST",			-- Mind Quickening
		[50519] = "HUNTER",			-- Bat - Sonic Focus
		[57386] = "HUNTER",			-- Clefthoof - Wild Strength
		[58604] = "HUNTER",			-- Core Hound - Double Bite
		[109773] = "WARLOCK",		-- Dark Intent
		[113742] = "ROGUE",			-- Swiftblade's Cunning
		[166916] = "MONK",			-- Windflurry
		[172968] = "HUNTER",		-- Lone Wolf -Quickness of the Dragonhawk
		["default"] = 166916,
		["name"] = L.raidbuffschecker_multistrike
	},
	["Versatility"] = {
		[1126] = "DRUID",			-- Mark of the Wild
		[35290] = "HUNTER",			-- Boar - Indomitable
		[50518] = "HUNTER",			-- Ravager - Chitinous Armor
		[55610] = "DEATHKNIGHT",	-- Unholy Aura
		[57386] = "HUNTER",			-- Clefthoof - Wild Strength
		[159735] = "HUNTER",		-- Bird of Prey - Tenacity
		[160045] = "HUNTER",		-- Porcupine - Defensive Quills
		[160077] = "HUNTER",		-- Worm - Strength of the Earth
		[167187] = "PALADIN",		-- Sanctity Aura
		[167188] = "WARRIOR",		-- Inspiring Presence
		[173035] = "HUNTER",		-- Stag - Grace
		[172967] = "HUNTER",		-- Lone Wolf - Versatility of the Ravager
		["default"] = 167187,
		["name"] = L.raidbuffschecker_versatility
	},
	-- http://www.wowhead.com/items=0.3
	["Flask"] = {
		-- Level 90
		[105617] = "20 STAT",		-- Alchemist's Flask (75525) Agility, Strength, or Intellect
		[105689] = "114 AGI",		-- Flask of Spring Blossoms (76084)
		[105691] = "114 INT",		-- Flask of the Warm Sun (76085)
		[105693] = "114 SPI",		-- Flask of Falling Leaves (76086)
		[105694] = "171 STA",		-- Flask of the Earth (76087)
		[105696] = "114 STR",		-- Flask of Winter's Bite (76088)
		[127230] = "57 STAT",		-- Crystal of Insanity (86569)
		-- Level 100
		[109155] = "250 INT",		-- Greater Draenic Intellect Flask (109155)
		[156070] = "200 INT",		-- Draenic Intellect Flask (109147)
		[156064] = "250 AGI",		-- Greater Draenic Agility Flask (109153)
		[156071] = "200 STR",		-- Draenic Strength Flask (109148)
		[156073] = "200 AGI",		-- Draenic Agility Flask (109145)
		[156077] = "300 STA",		-- Draenic Stamina Flask (109152)
		[156080] = "250 STR",		-- Greater Draenic Strength Flask (109156)
		[156084] = "375 STA",		-- Greater Draenic Stamina Flask (109160)
		["default"] = 105617,
		["name"] = L.raidbuffschecker_flask
	},
	-- http://www.wowhead.com/items=0.2
	["Elixir"] = {
		[105681] = "256 ARMOR",		-- Mantid Elixir (76075)  Guardian
		[105682] = "85 CRIT",		-- Mad Hozen Elixir (76076)  Battle
		[105683] = "85 EXP",		-- Elixir of Weaponry (76077)  Battle
		[105684] = "85 HASTE",		-- Elixir of the Rapids (76078)  Battle
		[105685] = "85 SPI",		-- Elixir of Peace (76079)  Battle
		[105686] = "85 HIT",		-- Elixir of Perfection (76080)  Battle
		[105687] = "85 DODGE",		-- Elixir of Mirrors (76081)  Guardian
		[105688] = "85 MAST",		-- Monk's Elixir (76083)  Battle
		["default"] = 105681,
		["name"] = L.raidbuffschecker_elixir
	},
	-- http://www.wowhead.com/items=0.5
	["Food"] = {
		-- Level 90
		[146804] = "34 STR",		-- Fluffy Silkfeather Omelet (101750)
		[104272] = "34 STR",		-- Black Pepper Ribs and Shrimp (74646)
		[104271] = "31 STR",		-- Eternal Blossom Fish (74645)
		[104267] = "28 STR",		-- Charbroiled Tiger Steak (74642)
		
		[146805] = "34 AGI",		-- Seasoned Pomfruit Slices (101746)
		[104275] = "34 AGI",		-- Sea Mist Rice Noodles (74648)
		[104274] = "31 AGI",		-- Valley Stir Fry (74647)
		[104273] = "28 AGI",		-- Sauteed Carrots (74643)
		
		[146806] = "34 INT",		-- Spiced Blossom Soup (101748)
		[104277] = "34 INT",		-- Mogu Fish Stew (74650)
		[104276] = "31 INT",		-- Braised Turtle (74649)
		[104264] = "28 INT",		-- Swirling Mist Soup (74644)
		
		[146807] = "34 SPI",		-- Farmer's Delight (101747)
		[104280] = "34 SPI",		-- Steamed Crab Surprise (74653)
		[104279] = "31 SPI",		-- Fire Spirit Salmon (74652)
		[104278] = "28 SPI",		-- Shrimp Dumplings (74651)
		
		[104283] = "51 STA",		-- Chun Tian Spring Rolls (74656)
		[146808] = "51 STA",		-- Stuffed Lushrooms (101749)
		[104282] = "47 STA",		-- Twin Fish Platter (74655)
		[104281] = "43 STA",		-- Wildfowl Roast (74654)
		[111840] = "36 STA",		-- Half a Lovely Apple (79320)
		
		[124219] = "34 MAST",		-- Pearl Milk Tea (81414)
		[146809] = "34 MAST",		-- Mango Ice (101745)
		[124219] = "23 MAST",		-- Hot Papaya Milk (105721)
		[124219] = "23 MAST",		-- Dented Can of Kaja'Cola (98127)
		[124219] = "23 MAST",		-- Grilled Dinosaur Haunch (94535)
		[124213] = "11 MAST",		-- Roasted Barley Tea (81406)
		[131828] = "11 MAST",		-- Mah's Warm Yak-Tail Stew (90457)
		
		[125113] = "34 HIT",		-- Spicy Salmon (86073)
		[125106] = "31 HIT",		-- Wildfowl Ginseng Soup (86070)
		[124221] = "23 HIT",		-- Peanut Pork Chops (105723)
		[124221] = "23 HIT",		-- Skewered Peanut Chicken (81413)
		[124221] = "23 HIT",		-- Mechanopeep Foie Gras (98126)
		[124221] = "23 HIT",		-- Spicy Mushan Noodles (104342)
		[124215] = "11 HIT",		-- Boiled Silkworm Pupa (81405)
		
		[125115] = "34 EXP",		-- Spicy Vegetable Chips (86074)
		[125108] = "31 EXP",		-- Rice Pudding (86069)
		[124216] = "23 EXP",		-- Red Bean Bun (81408)
		[124210] = "11 EXP",		-- Pounded Rice Cake (81400)
		
		[124220] = "23 DODGE",		-- Blanched Needle Mushrooms (81412)
		[124220] = "23 DODGE",		-- Shaved Zangar Truffles (98125)
		[124220] = "23 DODGE",		-- Crazy Snake Noodles (104340)
		[124220] = "23 DODGE",		-- Rice-Wine Mushrooms (105717)
		[124214] = "11 DODGE",		-- Dried Needle Mushrooms (81404)
		
		[125071] = "23 PARRY",		-- Peach Pie (81411)
		[125071] = "23 PARRY",		-- Candied Apple (105720)
		[125071] = "23 PARRY",		-- Bloodberry Tart (98124)
		[125071] = "23 PARRY",		-- Harmonious River Noodles (104339)
		[125070] = "11 PARRY",		-- Dried Peaches (81403)
		
		[124218] = "23 CRIT",		-- Brew-Curried Whitefish (105719)
		[124218] = "23 CRIT",		-- Green Curry Fish (81410)
		[124218] = "23 CRIT",		-- Lucky Mushroom Noodles (104344)
		[124218] = "23 CRIT",		-- Whale Shark Caviar (98123)
		[124212] = "11 CRIT",		-- Toasted Fish Jerky (81402)
		
		[124217] = "23 HASTE",		-- Steaming Goat Noodles (104341)
		[124217] = "23 HASTE",		-- Camembert du Clefthoof (98122)
		[124216] = "23 HASTE",		-- Nutty Brew-Bun (105722)
		[124217] = "23 HASTE",		-- Tangy Yogurt (81409)
		[124216] = "23 HASTE",		-- Golden Dragon Noodles (104343)
		[124217] = "23 HASTE",		-- Fried Cheese Dumplings (105724)
		[124211] = "11 HASTE",		-- Yak Cheese Curds (81401)
		
		--[104958] = "31 STAT",		-- Pandaren Banquet (74919)
		--[105193] = "31 STAT",		-- Great Pandaren Banquet (75016)
		--[126492] = "28 STAT",		-- Banquet of the Grill (87226)
		--[126494] = "28 STAT",		-- Great Banquet of the Grill (87228)
		--[126495] = "28 STAT",		-- Banquet of the Wok (87230)
		--[126496] = "28 STAT",		-- Great Banquet of the Wok (87232)
		--[126497] = "28 STAT",		-- Banquet of the Pot (87234)
		--[126498] = "28 STAT",		-- Great Banquet of the Pot (87236)
		--[126499] = "28 STAT",		-- Banquet of the Steamer (87238)
		--[126500] = "28 STAT",		-- Great Banquet of the Steamer (87240)
		--[126501] = "28 STAT",		-- Banquet of the Oven (87242)
		--[126502] = "28 STAT",		-- Great Banquet of the Oven (87244)
		--[126503] = "28 STAT",		-- Banquet of the Brew (87246)
		--[126504] = "28 STAT",		-- Great Banquet of the Brew (87248)
		--[145166] = "28 STAT",		-- Noodle Cart Kit (101630)
		--[145169] = "31 STAT",		-- Deluxe Noodle Cart Kit (101661)
		--[127882] = "31 STAT",		-- Squirmy Delight (88388)
		
		-- Level 100
		[174077] = "75 MAST",		-- Perfect Fuzzy Pear (118274)
		[160897] = "75 MAST",		-- Sleeper Surprise (111452)
		[160793] = "50 MAST",		-- Fuzzy Pear (118268)
		[160793] = "50 MAST",		-- Braised Riverbeast (111436)
		[160793] = "50 MAST",		-- Fat Sleeper Cakes (111444)
		
		[160893] = "75 HASTE",		-- Frosty Stew (111450)
		[174079] = "75 HASTE",		-- Perfect O'ruk Orange (118273)
		[160726] = "50 HASTE",		-- Pan-Seared Talbuk (111434)
		[160726] = "50 HASTE",		-- O'ruk Orange (118270)
		[160726] = "50 HASTE",		-- Sturgeon Stew (111442)
		
		[160883] = "112 STA",		-- Talador Surf and Turf (111447)
		[160600] = "75 STA",		-- Hearty Elekk Steak (111431)
		[160600] = "75 STA",		-- Steamed Scorpion (111439)
		
		[160889] = "75 CRIT",		-- Blackrock Barbecue (111449)
		[174062] = "75 CRIT",		-- Perfect Nagrand Cherry (118275)
		[160724] = "50 CRIT",		-- Blackrock Ham (111433)
		[160724] = "50 CRIT",		-- Giant Nagrand Cherry (118272)
		[160724] = "50 CRIT",		-- Grilled Gulper (111441)
		
		[160900] = "75 MULTI",		-- Calamari Crepes (111453)
		[174080] = "75 MULTI",		-- Perfect Greenskin Apple (118276)
		[160832] = "50 MULTI",		-- Greenskin Apple (118269)
		[160832] = "50 MULTI",		-- Rylak Crepes (111437)
		[160832] = "50 MULTI",		-- Fiery Calamari (111445)
		
		[160902] = "75 VERS",		-- Gorgrond Chowder (111454)
		[177931] = "75 VERS",		-- Pre-Mixed Pot of Noodles (120168)
		[174078] = "75 VERS",		-- Perfect Ironpeel Plantain (118277)
		[160839] = "50 VERS",		-- Ironpeel Plantain (118271)
		[160839] = "50 VERS",		-- Clefthoof Sausages (111438)
		[160839] = "50 VERS",		-- Skulker Chowder (111446)		
		
		--[174551] = "50 STAT",		-- Fish Roe (118416)
		--[174707] = "75 STAT",		-- Legion Chili (118428)
		--[175215] = "100 STAT",	-- Savage Feast (118576)
		--[160740] = "50 STAT",		-- Feast of Blood (111457)
		--[160914] = "50 STAT",		-- Feast of the Waters (111458)
		--[178398] = "75 STAT",		-- Lukewarm Yak Roast Broth (120293)

		["default"] = 104283,
		["name"] = "Food&Drinks"
	},
}

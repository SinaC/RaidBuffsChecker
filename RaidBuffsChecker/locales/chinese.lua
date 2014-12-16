local ADDON_NAME, Engine = ...
local L = Engine.Locales

if GetLocale() == "zhCN" then
	L.raidbuffschecker_stats = "所有常规Buff"
	L.raidbuffschecker_stamina = "耐力"
	L.raidbuffschecker_attackpower = "攻击强度"
	L.raidbuffschecker_haste = "急速"
	L.raidbuffschecker_multistrike = "溅射"
	L.raidbuffschecker_versatility = "全能"
	L.raidbuffschecker_spellpower = "法术强度"
	--L.raidbuffschecker_attackspeed = "物理急速"
	--L.raidbuffschecker_spellhaste = "法术急速"
	-- TODO
	-- L.raidbuffschecker_haste
	L.raidbuffschecker_criticalstrike = "爆击"
	L.raidbuffschecker_mastery = "精通"
	L.raidbuffschecker_flask = "合剂"
	L.raidbuffschecker_elixir = "药剂"
	L.raidbuffschecker_foodanddrink = "食物"

	L.raidbuffschecker_viewall = "查看所有团队Buff"
	L.raidbuffschecker_minimizeall = "最小化显示团队Buff"
	L.raidbuffschecker_move = "移动团队Buff"

	L.raidbuffschecker_help_use = "使用%s或 %s命令来设置RaidBuffsChecker"
	L.raidbuffschecker_help_move = "%s move - 移动RaidBuffsChecker框体"
	L.raidbuffschecker_command_stopmoving = "再次使用%s RaidBuffsChecker命令，退出移动模式"
end
local ADDON_NAME, Engine = ...

local L = Engine.Locales

if GetLocale() == "frFR" then
	L.raidbuffschecker_stats = "Caract\195\169ristiques"
	L.raidbuffschecker_stamina = "Endurance"
	L.raidbuffschecker_attackpower = "Puissance d'attaque"
	L.raidbuffschecker_spellpower = "Puissance des sorts"
	--L.raidbuffschecker_attackspeed = "Vitesse en m\195\169l\195\169e"
	--L.raidbuffschecker_spellhaste = "Hate des sorts"
	L.raidbuffschecker_haste = "Hate"
	L.raidbuffschecker_criticalstrike = "Coup critique"
	L.raidbuffschecker_mastery = "Maitrise"
	--TODO L.raidbuffschecker_bursthaste = "Burst Haste"
	L.raidbuffschecker_multistrike = "Score de frappe"
	L.raidbuffschecker_versatility = "Polyvalence"
	L.raidbuffschecker_flask = "Flacon"
	L.raidbuffschecker_elixir = "Elixir"
	L.raidbuffschecker_foodanddrink = "Nourriture & boisson"

	L.raidbuffschecker_viewall = "Afficher"
	L.raidbuffschecker_minimizeall = "Minimiser"
	L.raidbuffschecker_move = "Bouger les am\195\169liorations de raid"

	L.raidbuffschecker_help_use = "Utilisez %s or %s pour configurer RaidBuffsChecker"
	L.raidbuffschecker_help_move = "%s move - bouger les fen\195\170tres de RaidBuffsChecker"
	L.raidbuffschecker_help_layout = "%s layout - passer d'une disposition horizontale \195\160 une disposition vertical et vice-versa"
	L.raidbuffschecker_help_zoom = "%s zoom - passer des petites icones aud grandes icones et vice-verse"
	L.raidbuffschecker_command_stopmoving = "Utilisez %s move \195\160 nouveau pour arr\195\170ter de bouger les fen\195\170tres"

end
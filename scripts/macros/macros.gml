#macro MAX_STC_PER_SUBCATEGORY 6
#macro DEFAULT_TOOLTIP_VIEW_OFFSET 32
#macro DEFAULT_LINE_GAP -1
#macro LB_92 "############################################################################################"
#macro DATE_TIME_1 $"{current_day}-{current_month}-{current_year}-{format_time(current_hour)}{format_time(current_minute)}{format_time(format_time(current_second))}"
#macro DATE_TIME_2 $"{current_day}-{current_month}-{current_year}|{format_time(current_hour)}:{format_time(current_minute)}:{format_time(current_second)}"
#macro DATE_TIME_3 $"{current_day}-{current_month}-{current_year} {format_time(current_hour)}:{format_time(current_minute)}:{format_time(current_second)}"
#macro TIME_1 $"{format_time(current_hour)}:{format_time(current_minute)}:{format_time(current_second)}"
#macro CM_GREEN_COLOR #34bc75
#macro CM_RED_COLOR #bf4040
#macro MANAGE_MAN_SEE 34
#macro MANAGE_MAN_MAX array_length(obj_controller.display_unit) + 7
#macro SHOP_SELL_MOD 0.8

#macro STR_ANY_POWER_ARMOUR "Any Power Armour"
#macro STR_ANY_TERMINATOR_ARMOUR "Any Terminator Armour"

// Basic, because we don't include Artificer Armour
#macro LIST_BASIC_POWER_ARMOUR ["MK7 Aquila", "MK6 Corvus", "MK5 Heresy", "MK8 Errant", "MK4 Maximus", "MK3 Iron Armour","Power Armour"]
#macro LIST_TERMINATOR_ARMOUR ["Terminator Armour", "Tartaros","Cataphractii"]
#macro FACTION_NAMES ["","Your Chapter", "Imperium of Man","Adeptus Mechanicus","Inquisition","Ecclesiarchy","Eldar","Orks", "Tyranid Hive","Tau Empire","Chaos","Heretics","Genestealer Cults", "Necron Dynasties"]
#macro XENOS_FACTIONS [6,7,8,9]

#macro FLEET_MOVE_OPTIONS ["move", "crusade1","crusade2","crusade3", "mars_spelunk1"]

#macro ALLIANCE_GRADES ["Hated", "Hostile","Suspicious","Uneasy","Neutral","Allies","Close Allies","Battle Brothers"]

enum eFACTION {
    Player = 1,
    Imperium,
    Mechanicus,
    Inquisition,
    Ecclesiarchy,
    Eldar,
    Ork,
    Tau,
    Tyranids,
    Chaos,
    Heretics,
    Genestealer,
    Necrons = 13
}

enum MENU {
    Default = 0,
    Manage = 1,
    Apothecarion = 11,
    Reclusiam = 12,
    Librarium = 13,
    Armamentarium = 14,
    Recruiting = 15,
    Fleet = 16,
    EventLog = 17,
    Diplomacy = 20,
    Settings = 21,
    GameHelp = 30,
}

enum luck {
    bad = -1,
    neutral = 0,
    good = 1
}
enum GOD_MISSION {
    artifact
}
enum INQUISITION_MISSION {
    purge,
    inquisitor,
    spyrer,
    artifact,
    tomb_world,
    tyranid_organism,
    ethereal,
    demon_world
}

enum EVENT {
    //good
    space_hulk,
    promotion,
    strange_building,
    sororitas,
    rogue_trader,
    inquisition_mission,
    inquisition_planet,
    mechanicus_mission,
    //neutral
    strange_behavior,
    fleet_delay,
    harlequins,
    succession_war,
    random_fun,
    //bad
    warp_storms,
    enemy_forces,
    crusade,
    enemy,
    mutation,
    ship_lost,
    chaos_invasion,
    necron_awaken,
    fallen,
    //end
    none
}

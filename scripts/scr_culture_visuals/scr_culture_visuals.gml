function load_visual_sets(){
    var _vis_set_directory = working_directory + "\\main\\visual_sets";
    if (directory_exists(_vis_set_directory)){

        var _file_buffer = buffer_load($"{_vis_set_directory}\\use_sets.json");
        if (_file_buffer == -1) {
            throw ("Could not open file");
        }
        var _json_string = buffer_read(_file_buffer, buffer_string);
        buffer_delete(_file_buffer);
        var _raw_data = json_parse(_json_string);
        if (!is_array(_raw_data)){
            throw ("use_sets.json File Wrong Format");
        }
        for (var i=0;i<array_length(_raw_data);i++){
            var _sepcific_vis_set = $"{_vis_set_directory}\\{_raw_data[i]}";
            if (directory_exists(_sepcific_vis_set)){
                var _data_buffer = buffer_load($"{_sepcific_vis_set}\\data.json");
                if (_data_buffer == -1) {
                    buffer_delete(_data_buffer);
                    continue;
                } else {
                    var _data_string = buffer_read(_data_buffer, buffer_string);
                    buffer_delete(_data_buffer);
                    var _data_set = json_parse(_data_string);
                    load_vis_set_to_global(_sepcific_vis_set, _data_set);
                }
            }
        }

    }

    load_symbol_sets(global.chapter_symbols, "chapter_symbols", ["pauldron", "knees"]);
    load_symbol_sets(global.role_markings, "role_markings", ["pauldron", "knees"]);
}

function load_symbol_sets(global_area, main_key, sub_sets){
    var _cons_directory = working_directory + $"\\main\\{main_key}";
    if (directory_exists(_cons_directory)){
        show_debug_message($"{_cons_directory}")
        var _file_buffer = buffer_load($"{_cons_directory}\\load_sets.json");
        if (_file_buffer == -1) {
            throw (false);
        }
        var _json_string = buffer_read(_file_buffer, buffer_string);
        buffer_delete(_file_buffer);
        var _raw_data = json_parse(_json_string);
        if (!is_array(_raw_data)){
            throw ("use_sets.json File Wrong Format");
        }
        var _sprite_double_surface = surface_create(200,200);
        for (var i=0;i<array_length(_raw_data);i++){
            var _sepcific_vis_set = $"{_cons_directory}\\{_raw_data[i]}";
            if (directory_exists(_sepcific_vis_set)){
                for (var s=0;s<array_length(sub_sets);s++){
                    var _sub = sub_sets[s];
                    var sub_direct = $"{_sepcific_vis_set}\\{_sub}.png";
                    load_new_icon(_sprite_double_surface,sub_direct, global_area[$ _sub], _raw_data[i]);
                }
            }
        }
        surface_free(_sprite_double_surface);    
    }    
}


function load_new_icon(new_sprite_surface, path, add_place, key){
    if (file_exists(path)){
        var _new_sprite = sprite_add(path,1,0,0,0,0);
        var _width = sprite_get_width(_new_sprite);
        var _height = sprite_get_height(_new_sprite);
        surface_resize(new_sprite_surface, _width, _height)
        surface_set_target(new_sprite_surface);
        draw_clear_alpha(c_white,0);
        draw_sprite_ext(_new_sprite, 0, _width, 0, -1, 1, 0, c_white, 1);
        surface_reset_target();
        sprite_add_from_surface(_new_sprite, new_sprite_surface, 0, 0, _width, _height, 1, 0);
        add_place[$ key] = _new_sprite;
    }    
}
global.chapter_symbols  = {
    pauldron : {
        mantis_warriors : spr_mantis_warriors_icon,
    },
    knees : {

    }
}

global.role_markings = {
    pauldron : {
    },
    knees : {

    }
}
global.squad_markings = {
    pauldron : {
    },
    knees : {

    }
}
global.company_markings = {
    pauldron : {
    },
    knees : {

    }
}

function load_vis_set_to_global(directory, data){
    for (var i=0;i<array_length(data); i++){
        var _sprite_item = data[i];
        if (directory_exists(directory + $"\\{_sprite_item.name}")){
            var _sprite_direct = directory + $"\\{_sprite_item.name}";
            if (file_exists($"{_sprite_direct}\\1.png")){
                var _new_sprite = sprite_add(_sprite_direct + "\\1.png",1,0,0,0,0);
                var s = 2;
                _exit = false;
                while (file_exists(_sprite_direct + $"\\{s}.png")){
                    var _merge_sprite = sprite_add(_sprite_direct + $"\\{s}.png",1,0,0,0,0);
                    if (_merge_sprite == -1) {
                        sprite_delete(_new_sprite);
                        continue;
                    }                    
                    s++;
                    sprite_merge(_new_sprite, _merge_sprite);
                    sprite_delete(_merge_sprite);
                }
                var _s_data = _sprite_item.data;
                _s_data.sprite = _new_sprite;
                array_push(global.modular_drawing_items, _s_data);
            }
        }
    }
}
global.modular_drawing_items = [
    {
        sprite : spr_da_mk5_helm_crests,
        cultures : ["Knightly"],
        body_types :[0],
        armours : ["MK3 Iron Armour", "MK4 Maximus", "MK5 Heresy"],
        position : "crest",
        assign_by_rank : 2,
        exp : {
            min : 70,
        },         
    },
    {
        sprite : spr_da_mk7_helm_crests,
        cultures : ["Knightly"],
        body_types :[0],
        armours : ["MK7 Aquila", "Power Armour", "MK8 Errant","Artificer Armour"],
        position : "crest",
        assign_by_rank : 2,
    },
    {
        sprite : spr_terminator_laurel,
        armours : ["Terminator Armour", "Tartaros"],
        roles : [eROLE.Captain,eROLE.Champion],
        position : "crown",
        body_types :[2],
    },
    {
        sprite : spr_laurel,
        body_types :[0],
        armours : ["Terminator Armour", "Tartaros"],
        roles : [eROLE.Captain,eROLE.Champion],
        position : "crown",
    },
    {
        sprite : spr_special_helm,
        body_types :[0],
        armours_exclude : ["MK3 Iron Armour"],
        roles : [eROLE.Captain,eROLE.Champion],
        assign_by_rank : 2,
        position : "mouth_variants",
    },
    {
        cultures : ["Mongol"],
        sprite : spr_mongol_topknots,
        body_types :[0],
        position : "crest",
    },
    {
        cultures : ["Mongol"],
        sprite : spr_mongol_hat,
        body_types :[0],
        position : "crown",
    },
    {
        cultures : ["Prussian"],
        sprite : spr_prussian_spike,
        body_types :[0],
        position : "crest",
    },
    {
        cultures : ["Mechanical Cult"],
        assign_by_rank : 2,
        sprite : spr_metal_tabbard,
        role_type : ["forge"],
        body_types :[0],
        position : "tabbard",
        allow_either : ["cultures", "role_type"],
    },
    {
        cultures : ["Knightly"],
        sprite : spr_knightly_personal_livery,
        body_types :[0],
        assign_by_rank : 3,
        position : "left_personal_livery",        
    },
    {
        cultures : ["Gladiator"],
        sprite : spr_gladiator_crest,
        body_types :[0],
        assign_by_rank : 2,
        position : "crest",        
    },
    {
        cultures : ["Mechanical Cult"],
        assign_by_rank : 2,
        sprite : spr_terminator_metal_tabbard,
        role_type : ["forge"],
        body_types :[2],
        position : "tabbard",
        allow_either : ["cultures", "role_type"],       
    },
    {
        cultures : ["Flame Cult"],
        sprite : spr_mk3_mouth_flame_cult,
        body_types :[0],
        position : "mouth_variants",
        armours : ["MK3 Iron Armour"],    
    },
    {
        cultures : ["Prussian"],
        sprite : spr_mk3_mouth_prussian,
        body_types :[0],
        position : "mouth_variants",
        armours : ["MK3 Iron Armour"],    
    },
    {
        cultures : ["Prussian"],
        sprite : spr_mk6_mouth_prussian,
        body_types :[0],
        position : "mouth_variants",
        armours : ["MK3 Iron Armour"],    
    },
    {
        cultures : ["Prussian"],
        sprite : spr_mk7_prussia_chest,
        body_types :[0],
        position : "chest_variants",  
    },
    {
        cultures : ["Prussian"],
        sprite : spr_mk7_mouth_prussian,
        body_types :[0],
        position : "chest_variants",
        armours : ["MK8 Errant", "MK7 Aquila"],      
    }, 
    {
        cultures : ["Mongol"],
        sprite : spr_mk7_mongol_chest_variants,
        body_types :[0],
        position : "chest_variants",
        armours : ["MK8 Errant", "MK7 Aquila"],      
    },
    {
        cultures : ["Gladiator"],
        sprite : spr_mk7_gladiator_chest,
        body_types :[0],
        position : "chest_variants",
        armours : ["MK8 Errant", "MK7 Aquila"],      
    },
    {
        cultures : ["Mongol"],
        sprite : spr_mk4_mongol_chest_variants,
        body_types :[0],
        position : "chest_variants",
        armours : ["MK4 Maximus"],      
    },
    {
        cultures : ["Mongol"],
        sprite : spr_mk6_mongol_chest_variants,
        body_types :[0],
        position : "chest_variants",
        armours : ["MK6 Corvus"],      
    },
    {
        cultures : ["Knightly"],
        sprite : spr_knightly_robes,
        body_types :[0],
        position : "robe",
        assign_by_rank : 4,    
    },
    {
        cultures : ["Knightly"],
        sprite : spr_da_backpack,
        body_types :[0],
        position : "backpack",
        assign_by_rank : 3,
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour"],         
    },
    {
        chapter_adv : ["Reverent Guardians"],
        sprite : spr_pack_brazier3,
        body_types :[0],
        position : "backpack",
        assign_by_rank : 4,
    },
    {
        sprite : spr_gear_librarian,
        body_types :[0],
        position : "right_pauldron_icons",
        role_type : ["lib"],
    },
    {
        sprite : spr_gear_librarian_term,
        body_types :[2],
        position : "right_pauldron_icons",
        role_type : ["lib"],
    },
    {
        sprite : spr_roman_centurian_crest,
        body_types :[0],
        cultures : ["Roman", "Greek", "Gladiator"],
        position : "crest",
        role_type : ["captain_candidates"],
        assign_by_rank : 2,
    },
    {
        sprite : spr_purity_seal,
        body_types :[0,2],
        position : "purity_seals",
    },
    {
        sprite : spr_marksmans_honor,
        body_types :[0,2],
        position : "purity_seals",
        stats : [["ballistic_skill", 50, "exmore"]]
    },
    {
        sprite : spr_crux_on_chain,
        body_types :[0,2],
        position : "purity_seals",
        exp : {
            min : 100,
        }
    },    
    {
        cultures : ["Knightly"],
        sprite : spr_mk6_knightly_mouth_variants,
        body_types :[0],
        position : "mouth_variants",
        armours : ["MK6 Corvus"],    
    },
    {
        cultures : ["Knightly"],
        sprite : spr_mk6_forehead_knightly,
        body_types :[0],
        position : "forehead",
        armours : ["MK6 Corvus"],    
    },    
    {
        sprite : spr_mk7_complex_crux_belt,
        body_types :[0, 2],
        position : "belt",
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour", "Tartaros"],
        exp : {
            min : 100,
        },        
    },
    {
        cultures : ["Knightly", "Crusader"],
        sprite : spr_mk7_rope_belt,
        body_types :[0],
        position : "belt",
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour","MK4 Maximus"], 
        assign_by_rank : 2,   
    },
    {
        cultures : ["Knightly", "Crusader","Gladiator"],
        sprite : spr_lion_belt,
        body_types :[0],
        position : "belt",
        exp : {
            min : 70,
        },        
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour"], 
        assign_by_rank : 2,   
    },
    {
        cultures : ["Knightly"],
        sprite : spr_knightly_belt,
        body_types :[0],
        position : "belt",
        exp : {
            min : 50,
        } ,      
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour"], 
        assign_by_rank : 3,   
    }, 
    {
        sprite : spr_skulls_belt,
        body_types :[0],
        position : "belt",
        role_type : ["chap"],
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour"],  
    },
    {
        sprite : spr_tech_belt,
        body_types :[0],
        position : "belt",
        role_type : ["forge"],
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour"],  
    },     
    {
        cultures : ["Feral"],
        sprite : spr_teeth,
        body_types :[0,2],
        position : "purity_seals",
        traits : ["tyrannic_vet", "beast_slayer","feral"],
        allow_either : ["cultures", "traits"],
    },
    {
        cultures : ["Knightly"],
        sprite : spr_mk7_knightly_chest,
        body_types :[0],
        position : "chest_variants",
        armours : ["MK8 Errant", "MK7 Aquila","Artificer Armour"],  
    },
    {
        sprite : spr_ultra_belt,
        cultures : ["Ultra"],
        body_types :[0, 2],
        assign_by_rank : 3,
        position : "belt",
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour", "Tartaros"],  
    },
    {
        cultures : ["Roman", "Gladiator"],
        sprite : spr_roman_tabbard,
        body_types :[0, 2],
        position : "tabbard",
        max_saturation : 50,
        assign_by_rank : 3,
        exp : {
            min : 50,
        },
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour", "Tartaros","MK4 Maximus", "MK3 Iron Armour"], 
    },
    {
        cultures : ["Ultra"],
        sprite : spr_ultra_tassels,
        body_types :[0,2],
        position : "purity_seals",
        exp : {
            min : 80,
        },
    },
    {
        cultures : ["Ultra", "Roman"],
        sprite : spr_ultra_backpack,
        body_types :[0],
        position : "backpack",
        assign_by_rank : 2,
        exp : {
            min : 80,
        },
    },
    {
        cultures : ["Ultra", "Roman"],
        sprite : spr_roman_cloak,
        body_types :[0],
        position : "cloak",
        max_saturation : 35,
        overides : {
            "right_pauldron_hangings" : spr_ultra_right_shoulder_hanging,
        },
        assign_by_rank :2,
        exp : {
            min : 80,
        },
    }, 
    {
        cultures : ["Ultra"],
        sprite : spr_mk7_chest_ultra,
        body_types :[0],
        position : "chest_variants",
        armours : ["MK7 Aquila", "MK8 Errant", "Artificer Armour"]
    },
    {
        max_saturation : 50,
        cultures : ["Knightly"],
        sprite : spr_indomitus_knightly_robe,
        body_types :[2],
        position : "robe",
        armours : ["Terminator Armour"],
    },
    {
        cultures : ["Feral", "Gothic"],
        sprite : spr_skull_on_chain,
        body_types :[2],
        position : "purity_seals",
    },
    {
        cultures : ["Knightly"],
        sprite : spr_sword_pendant,
        body_types :[0,2],
        position : "purity_seals",
    },
    {
        sprite : spr_mk7_complex_belt,
        body_types :[0],
        position : "belt",
        armours_exclude : ["MK3 Iron Armour"],        
    },
    {
        sprite : spr_dev_pack_complex,
        body_types :[0],
        position : "backpack_augment",
        equipped : {
            "mobi" : "Heavy Weapons Pack"
        },
        overides : {
            "chest_fastening" : spr_backpack_fastening,
        },        
    },
    {
        sprite : spr_jump_pack_complex,
        body_types :[0],
        position : "backpack_augment",
        equipped : {
            "mobi" : "Jump Pack"
        },
        overides : {
            "chest_fastening" : spr_backpack_fastening,
        },        

    },
    {
        sprite : spr_gear_hood2,
        body_types :[0],
        position : "mouth_variants", 
        role_type : ["lib"],
        chapter_disadv : ["Warp Tainted"],    
    },
    {
        sprite : spr_mk4_chest_fastenings,
        body_types :[0],
        position : "chest_fastening",
        armours : ["MK4 Maximus"]
    }, 
    {
        sprite : spr_mk7_complex_left_pauldron,
        body_types :[0],
        position : "left_pauldron_base",
    } ,
    {
        sprite : spr_mk7_complex_right_pauldron,
        body_types :[0],
        position : "right_pauldron_base",
    },
    {
        sprite : spr_bonding_studs_left,
        body_types :[0],
        position : "left_pauldron_embeleshments",
        armours : ["MK5 Heresy", "MK6 Corvus"]
    },
    {
        sprite : spr_bonding_studs_left,
        body_types :[0],
        position : "left_pauldron_embeleshments",
        max_saturation : 15,
        armours_exclude : ["MK5 Heresy", "MK6 Corvus"]
    },
    {
        sprite : spr_bonding_studs_right,
        body_types :[0],
        position : "right_pauldron_embeleshments",
        armours : ["MK5 Heresy", "MK6 Corvus"],
    },
    {
        sprite : spr_bonding_studs_right,
        body_types :[0],
        position : "right_pauldron_embeleshments",
        max_saturation : 15,
        armours_exclude : ["MK5 Heresy", "MK6 Corvus"]
    },
    {
        cultures : ["Wolf Cult"],
        sprite : spr_chaplain_wolfterm_helm,
        body_types :[2],
        position : "head",
        prevent_others : true,
        ban : ["mouth_variants"],
        role_type : ["chap"],
    },
    {
        cultures : ["Wolf Cult"],
        sprite : spr_chaplain_wolf_helm,
        body_types :[0],
        position : "head",
        prevent_others : true,
        ban : ["mouth_variants"],
        role_type : ["chap"],
    },
    {   
        sprite : spr_chaplain_term_helm,
        body_types :[2],
        position : "head",
        prevent_others : true,
        ban : ["mouth_variants"],
        role_type : ["chap"],
    },
    {
        sprite : spr_chaplain_helm,
        body_types :[0],
        position : "head",
        prevent_others : true,
        ban : ["mouth_variants"],
        role_type : ["chap"],
    }, 
    {
        cultures : ["Feral", "Wolf Cult"],
        sprite : spr_wolf_tail,
        body_types :[2, 0],
        position : "purity_seals",
    },
    {
        cultures : ["Feral", "Wolf Cult"],
        sprite : spr_right_pauldron_fur_hanging,
        body_types :[0],
        position : "right_pauldron_hangings",
        max_saturation : 20,
    },
    {
        cultures : ["Feral", "Wolf Cult"],
        sprite : spr_left_pauldron_fur_hanging,
        body_types :[0],
        position : "left_pauldron_hangings",
        max_saturation : 20,
    }, 
    {
        cultures : ["Feral", "Wolf Cult"],
        sprite : spr_term_right_fur_hanging,
        body_types :[2],
        position : "right_pauldron_hangings",
        max_saturation : 20,
    },
    {
        cultures : ["Feral", "Wolf Cult"],
        sprite : spr_term_left_fur_hanging,
        body_types :[2],
        position : "left_pauldron_hangings",
        max_saturation : 20,
    },
    {
        cultures : ["Wolf Cult"],
        sprite : spr_fur_tail_topknot,
        body_types :[0],
        position : "crest",
        max_saturation : 30,
    },
    {
        cultures : ["Runic"],
        sprite : spr_runes_hanging,
        body_types :[0,2],
        position : "purity_seals",
    }, 
    {
        cultures : ["Wolf Cult"],
        sprite : spr_mk7_wolf_cult_chest_variants,
        body_types :[0],
        position : "chest_variants",
        armours : ["MK7 Aquila", "MK8 Errant", "Artificer Armour"],
    },
    {
        cultures : ["Wolf Cult"],
        sprite : spr_mk7_wolf_cult_belt,
        body_types :[0],
        position : "belt",
        armours_exclude : ["MK3 Iron Armour"],      
    }, 
    {
        cultures : ["Runic"],
        sprite : spr_mk7_runic_belt,
        body_types :[0],
        position : "belt",
        armours_exclude : ["MK3 Iron Armour"],      
    }, 
    {
        cultures : ["Wolf Cult"],
        sprite : spr_fur_tabbard,
        body_types :[0, 2],
        position : "tabbard",
        max_saturation : 20,
        armours : ["MK5 Heresy", "MK6 Corvus","MK7 Aquila", "MK8 Errant", "Artificer Armour", "Tartaros","MK4 Maximus", "MK3 Iron Armour"], 
    }, 
    {
        cultures : ["Runic"],
        sprite : spr_mk3_runic_chest,
        body_types :[0],
        position : "chest_variants",
        armours : ["MK3 Iron Armour"],      
    }, 
    {
        sprite : spr_mk3_chest,
        body_types :[0],
        position : "chest_variants",
        armours : ["MK3 Iron Armour"],      
    },                                                                
];


function fetch_marine_components_to_memory(){
    array_foreach(global.modular_drawing_items, function(_element, _index){
        if (sprite_exists((_element.sprite))){
            sprite_prefetch(_element.sprite);
            if (struct_exists(_element, "overides")){
                var _override_areas = struct_get_names(_element.overides);
                for (var i = 0;i<array_length(_override_areas);i++){
                    sprite_prefetch(_element.overides[$_override_areas[i]]);
                }
            }
        }
    });
}



function DummyMarine()constructor{
    static update = function(){
        delete body;
        body = generate_marine_body();
        add_purity_seal_markers();
    }
    update();
    static distribute_traits = scr_marine_trait_spawning;
    base_group="astartes";
    static alter_equipment = alter_unit_equipment;
    static stat_display = scr_draw_unit_stat_data;
    static draw_unit_image = scr_draw_unit_image;
    static display_wepaons = scr_ui_display_weapons;
    static unit_profile_text = scr_unit_detail_text;
    static has_equipped = unit_has_equipped;
    static get_body_data = scr_get_body_data;
    traits = [];
    company = irandom_range(1,10);
    static name_role= function(){
        return "jeff";
    } 
    static role = function(){
        with (obj_creation){
            return role[100][livery_picker.role_set > 0  ? livery_picker.role_set :eROLE.Tactical];
        }
    } 
    static weapon_one = function(){
        with (obj_creation){
            return wep1[100][livery_picker.role_set > 0  ? livery_picker.role_set :eROLE.Tactical];
        }
    } 
    static race = function(){
        return "1";
    }  
    static weapon_two = function(){
        with (obj_creation){
            return wep2[100][livery_picker.role_set > 0  ? livery_picker.role_set :eROLE.Tactical];
        }
    }  
    last_armour = "MK7 Aquila";
    static armour = function(){
        var armours = ARR_power_armour;
        var _last_armour = last_armour;
        with (obj_creation){
            if (!livery_picker.freeze_armour){
                var _armour  = armour[100][livery_picker.role_set > 0  ? livery_picker.role_set : eROLE.Tactical];
                if (array_contains(armours, _armour)){
                     _armour = array_random_element(armours);
                }
                if (_armour == "Power Armour"){
                     _armour = "MK7 Aquila";
                }
            } else {
                _armour = _last_armour;
            }
        }
        last_armour = _armour;
        return _armour;
    } 
    static gear = function(){
         with (obj_creation){
            return gear[100][livery_picker.role_set > 0  ? livery_picker.role_set :eROLE.Tactical];
        }
    }
    static mobility_item = function(){
         with (obj_creation){
            return mobi[100][livery_picker.role_set > 0  ? livery_picker.role_set :eROLE.Tactical];
        }
    }
    static IsSpecialist = function(search_type="standard",include_trainee=true, include_heads=true){
        return is_specialist(role(), search_type,include_trainee, include_heads);
    }
    static has_trait = marine_has_trait;

    experience = 120;
}

function scr_get_body_data (body_item_key,body_slot="none"){
    if (body_slot!="none"){
        if (struct_exists(body, body_slot)){
            if (struct_exists(body[$ body_slot], body_item_key)){
                return body[$ body_slot][$ body_item_key]
            } else {
                return false;
            }
        }else {
            return "invalid body area";
        }
    } else {
        var item_key_map = {};
        var body_part_area_keys
        var _body_parts = ARR_body_parts;
        for (var i=0;i<array_length(_body_parts);i++){//search all body parts
            body_area = body[$ _body_parts[i]]
            body_part_area_keys=struct_get_names(body_area);
            for (var b=0;b<array_length(body_part_area_keys);b++){
                if (body_part_area_keys[b]==body_item_key){
                    item_key_map[$ _body_parts[i]] = body_area[$ body_item_key]
                }
            }
            
        }
        return item_key_map;
    }
    return false;
}


function generate_marine_body(){
    var _body = {
        "left_leg":{
            leg_variants: irandom(100),
        }, 
        "right_leg":{
            leg_variants: irandom(100),
        }, 
        "torso":{
            cloth:{
                variation:irandom(100),
            },
            tabbard_variation:irandom(100),
            armour_choice :  irandom(100),
            variation: irandom(10),
            backpack_variation: irandom(100),
            backpack_decoration_variation : irandom(100),
            backpack_augment_variation : irandom(100),
            thorax_variation : irandom(100),
            chest_variation : irandom(100),
            belt_variation : irandom(100),
            chest_fastening : irandom(100),
        }, 
        "left_arm":{
            trim_variation : irandom(100),
            personal_livery : irandom(100),
            pad_variation : irandom(100),
            variation : irandom(100),
        },
        "right_arm":{
            trim_variation : irandom(100),
            personal_livery : irandom(100),
            pad_variation : irandom(100),
            variation : irandom(100),           
        }, 
        "left_eye":{
            variant : irandom(100),
        }, 
        "right_eye":{
            variant : irandom(100),
        },
        "throat":{
            variant : irandom(100),
        }, 
        "jaw":{
            variant: irandom(100),
        },
        "head":{
            variation:irandom(100),
            crest_variation : irandom(100),
            forehead_variation : irandom(100),
            crown_variation : irandom(100),
        },
        "cloak":{
            type: "none",
            variant: irandom(100)
        },
    }
    return _body; 
}

function add_purity_seal_markers (){
    if (irandom(3)==0){
        body[$ "torso"][$ "purity_seal"] = [irandom(100),irandom(100),irandom(100),irandom(100)];
    }
    if (irandom(3)==0){
        body[$ "left_arm"][$ "purity_seal"] = [irandom(100),irandom(100),irandom(100),irandom(100)];
    }
    if (irandom(3)==0){
        body[$ "right_arm"][$ "purity_seal"] = [irandom(100),irandom(100),irandom(100),irandom(100)];
    }   
    if (irandom(3)==0){
        body[$ "left_leg"][$ "purity_seal"] = [irandom(100),irandom(100),irandom(100),irandom(100)];
    }
    if (irandom(3)==0){
        body[$ "right_leg"][$ "purity_seal"] = [irandom(100),irandom(100),irandom(100),irandom(100)];
    }       
}






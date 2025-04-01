function active_roles(){
	var _roles =  instance_exists(obj_creation) ?  obj_creation.role[100] : obj_ini.role[100];
	return _roles;
}

function role_groups(group, include_trainee = false, include_heads = true) {
    var _role_list = [];
    var _roles = active_roles();
	var _chap_name = instance_exists(obj_creation) ? obj_creation.chapter_name : global.chapter_name;

    switch (group) {
        case "standard":
            _role_list = [
                _roles[eROLE.Captain],
                _roles[eROLE.Dreadnought],
                $"Venerable {_roles[eROLE.Dreadnought]}",
                _roles[eROLE.Champion],
                _roles[eROLE.Chaplain],
                _roles[eROLE.Apothecary],
                _roles[eROLE.Techmarine],
                _roles[eROLE.Librarian],
                "Codiciery",
                "Lexicanum",
                _roles[eROLE.HonourGuard]
            ];
            if (include_trainee) {
				_role_list = array_concat(_role_list, role_groups("trainee"));
            }
			if (include_heads) {
				_role_list = array_concat(_role_list, role_groups("heads"));
            }
            break;

        case "lib":
            _role_list = [
                _roles[eROLE.Librarian],
                "Codiciery",
                "Lexicanum"
            ];
			if (include_trainee) {
				array_push(_role_list, $"{_roles[eROLE.Librarian]} Aspirant");
            }
			if (include_heads) {
				array_push(_role_list, $"Chief {_roles[eROLE.Librarian]}");
            }
            break;
		case "forge":
			_role_list = [
				_roles[eROLE.Techmarine],
				"Techpriest"
			];
			if (include_trainee) {
				array_push(_role_list, $"{_roles[eROLE.Techmarine]} Aspirant");
			}
			if (include_heads) {
				array_push(_role_list, "Forge Master");
			}
			break;
		case "chap":
			_role_list = [_roles[eROLE.Chaplain]];
			if (_chap_name == "Iron Hands") {
				array_push(_role_list, _roles[eROLE.Techmarine]);
				if (include_trainee) {
					array_push(_role_list, $"{_roles[eROLE.Techmarine]} Aspirant");
				}
				if (include_heads) {
					array_push(_role_list, "Forge Master");
				}
			}
			if (include_trainee) {
				array_push(_role_list, $"{_roles[eROLE.Chaplain]} Aspirant");
			}
			if (include_heads) {
				array_push(_role_list, "Master of Sanctity");
			}
			break;
		case "apoth":
			_role_list = [_roles[eROLE.Apothecary]];
			if (_chap_name == "Space Wolves") {
				array_push(_role_list, _roles[eROLE.Chaplain]);
				if (include_trainee) {
					array_push(_role_list, $"{_roles[eROLE.Chaplain]} Aspirant");
				}
				if (include_heads) {
					array_push(_role_list, "Master of Sanctity");
				}
			}
			if (include_trainee) {
				array_push(_role_list, $"{_roles[eROLE.Apothecary]} Aspirant");
			}
			if (include_heads) {
				array_push(_role_list, "Master of the Apothecarion");
			}
			break;

        case "trainee":
            _role_list = [
                $"{_roles[eROLE.Librarian]} Aspirant",
                $"{_roles[eROLE.Apothecary]} Aspirant",
                $"{_roles[eROLE.Chaplain]} Aspirant",
                $"{_roles[eROLE.Techmarine]} Aspirant"
            ];
            break;
        case "heads":
            _role_list = [
                "Master of Sanctity",
                $"Chief {_roles[eROLE.Librarian]}",
                "Forge Master",
                "Chapter Master",
                "Master of the Apothecarion"
            ];
            break;
        case "veterans":
            _role_list = [
                _roles[eROLE.Veteran],
                _roles[eROLE.Terminator],
                _roles[eROLE.VeteranSergeant],
                _roles[eROLE.HonourGuard]
            ];
            break;
        case "rank_and_file":
            _role_list = [
                _roles[eROLE.Tactical],
                _roles[eROLE.Devastator],
                _roles[eROLE.Assault],
                _roles[eROLE.Scout]
            ];
            break;
        case "squad_leaders":
            _role_list = [
                _roles[eROLE.Sergeant],
                _roles[eROLE.VeteranSergeant]
            ];
            break;
        case "command":
            _role_list = [
                _roles[eROLE.Captain],
                _roles[eROLE.Apothecary],
                _roles[eROLE.Chaplain],
                _roles[eROLE.Techmarine],
                _roles[eROLE.Librarian],
                "Codiciery",
                "Lexicanum",
                _roles[eROLE.Ancient],
                _roles[eROLE.Champion]
            ];
            break;
        case "dreadnoughts":
            _role_list = [
                _roles[eROLE.Dreadnought],
                $"Venerable {_roles[eROLE.Dreadnought]}"
            ];
            break;
        case "captain_candidates":
            _role_list = [
                _roles[eROLE.Sergeant],
                _roles[eROLE.VeteranSergeant],
                _roles[eROLE.Champion],
                _roles[eROLE.Captain],
                _roles[eROLE.Terminator],
                _roles[eROLE.Veteran],
                _roles[eROLE.Ancient]
            ];
            break;
    }

    return _role_list;
}

function is_specialist(unit_role, type = "standard", include_trainee = false, include_heads = true) {
    var _specialists = role_groups(type, include_trainee, include_heads);

    return array_contains(_specialists, unit_role);
}

//TODO write this out with proper formatting when i can be assed
//Used to quikcly collect groups of marines with given parameters
// group takes a string relating to options in the role_groups function, to ignore filtering by group use "all"
	// can also pass an array to filter for mutiple groups
// location takes wther a string with a system name or an array with 3 parameters [<location name>,<planet number>,<ship number>]
// if opposite is true then then the roles defined in the group argument are ignored and all others collected
// search conditions
	// companies, takes either an int or an arrat to define which companies to search in
	// any stat allowed by the stat_valuator basically allows you to look for marines whith certain stat lines
	// job allows you to find marines forfuling certain tasks like garrison or forge etc

function collect_role_group(group="standard", location="", opposite=false, search_conditions = {companies:"all"}){
	var _units = [], unit, count=0, _add=false, _is_special_group;
	var _max_count = 0;
	var _total_count = 0;
	if (struct_exists(search_conditions, "max")){
		_max_count =  search_conditions.max;
	}
	if (!struct_exists(search_conditions, "companies")){
		search_conditions.companies = "all";
	}
	for (var com=0;com<=10;com++){
    	if (_max_count>0){
    		if (array_length(_units)>=_max_count){
    			break;
    		}
    	}		
		var _wanted_companies = search_conditions.companies;
		if (_wanted_companies!="all"){
			if (is_array(_wanted_companies)){
				if (!array_contains(_wanted_companies, com)) then continue;
			} else {
				if (_wanted_companies != com) then continue;
			}
		}
	    for (var i=0;i<array_length(obj_ini.TTRPG[com]);i++){
	    	if (_max_count>0){
	    		if (array_length(_units)>=_max_count){
	    			break;
	    		}
	    	}
	    	if array_length(_units)
	    	_add=false;
			unit=fetch_unit([com,i]);
			if (unit.name()=="") then continue;
			if (group!="all"){
				if (is_array(group)){
					if (array_length(group) == 3) {
						_is_special_group = unit.IsSpecialist(group[0], group[1], group[2]);
					} else {
						_is_special_group = unit.IsSpecialist(group[0], group[1]);
					}
				} else {
					_is_special_group = unit.IsSpecialist(group);
				}
			} else {
				_is_special_group = true;
			}
	        if ((_is_special_group && !opposite) || (!_is_special_group && opposite)){
	        	if (location==""){
	        		_add=true;
	       		} else if (!is_array(location)){
		       		_add=unit.is_at_location(location);
		       	} else {
		       		_add=unit.is_at_location(location[0], location[1], location[2]);
		       	}
	        }
	        if (_add){
	        	if (struct_exists(search_conditions, "stat")){
	        		_add = stat_valuator(search_conditions.stat, unit);
	        	}
	        	if (struct_exists(search_conditions,"job")){
	        		_add =  (unit.assignment() == search_conditions.job);
	        	}
	        }
	        if (_add) then array_push(_units, obj_ini.TTRPG[com][i]);
	    }    
	}
	return _units;
}

function stat_valuator(search_params, unit){
	match = true;
	for (var stat = 0;stat<array_length(search_params);stat++){
		var _stat_val = search_params[stat];		
		if (!struct_exists(unit,_stat_val[0])){
			match = false;
			break;
		}
		switch _stat_val[2] {
    		case "inmore":
	    	case "more":
    			if (unit[$ _stat_val[0]] < _stat_val[1]){
    				match = false;
					break;
    			}
			break;

    		case "exmore":
    			if (unit[$ _stat_val[0]] <= _stat_val[1]){
    				match = false;
					break;
    			}
			break;

    		case "inless":
	    	case "less":
    			if (unit[$ _stat_val[0]] > _stat_val[1]){
    				match = false;
					break;
    			}
			break;

    		case "exless":
    			if (unit[$ _stat_val[0]] >= _stat_val[1]){
    				match = false;
					break;
    			}
			break;
		}
	}
	return match;	
}

function collect_by_religeon(religion, sub_cult="", location=""){
	var _units = [], unit, count=0, _add=false;
	for (var com=0;com<=10;com++){
	    for (var i=1;i<array_length(obj_ini.TTRPG[com]);i++){
	    	_add=false;
			unit=obj_ini.TTRPG[com][i];
			if (unit.name()=="")then continue; 	
	        if (unit.religion == religion){
	        	if (sub_cult!=""){
	        		if (unit.religion_sub_cult != "sub_cult"){
	        			continue;
	        		}
	        	}
	        	if (location==""){
	        		_add=true;
	       		} else if (unit.is_at_location(location)){
	       			_add=true;
	       		}
	        }
	        if (_add) then array_push(_units, obj_ini.TTRPG[com][i]);
	    }    
	}
	return _units;
}

function group_selection(group, selection_data){
	try {
		var unit, s, unit_location;
		obj_controller.selection_data = selection_data;
		set_zoom_to_default();
		with (obj_controller){
				basic_manage_settings();
				with(obj_fleet_select){instance_destroy();}
				with(obj_star_select){instance_destroy();}

				exit_button = new ShutterButton();
				proceed_button = new ShutterButton();
				selection_data.start_count=0;
			// Resets selections for next turn
				man_size=0;
				selecting_location="";
				selecting_types="";
				selecting_ship=-1;
				selecting_planet=0;
				sel_uid=0;
				reset_manage_arrays();
				alll=0;              
				cooldown=10;
				sel_loading=-1;
				unload=0;
				alarm[6]=7;
				company_data={};
				view_squad=false;
				managing =-1; 
				var vehicles = [];
				for (var i = 0; i< array_length(group);i++){
					if (!is_struct(group[i])){
						if (is_array(group[i])){
							array_push(vehicles, group[i]);
						}
						continue;
					}
					unit = group[i];
					add_man_to_manage_arrays(unit);

					if (selection_data.purpose_code=="forge_assignment"){
						if (unit.job != "none"){
							if (unit.job.type=="forge" && unit.job.planet== selection_data.planet){
								man_sel[array_length(display_unit)-1]=1;
								man_size++;
								selection_data.start_count++;

							}                		
						}
					}       	
				}
				var last_vehicle=0;
			if (array_length(vehicles)>0){
				for (var veh=0;veh<array_length(vehicles);veh++){
					unit = vehicles[veh];
					add_vehicle_to_manage_arrays(unit)       		
				}
			}
			other_manage_data();
			man_current=0;
			man_max=array_length(display_unit)+2;
			man_see=38-4;
		}
	} catch(_exception) {
		handle_exception(_exception);
		scr_toggle_manage();//handle and send player back to map
	}
}

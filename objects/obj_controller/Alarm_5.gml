// TODO script description: This is the turn management in general 
// TODO refactor

try_and_report_loop("final end turn alarm 5",function(){
var recruit_count=0;
var random_marine, marine_position;
var eq1=1,eq2=1,eq3=1,t=0,r=0;
var marine_company=0;
var warn="",w5=0;
var g1=0,g2=0;
var onceh=0,stahp=0;
var disc=0,droll=0;
var rund=0;
var spikky=0;
var roll=0;
var novice_type="";
var unit;


try_and_report_loop("chaos_spread", function(){
    var times=max(1,round(turn/150));
    if (known[eFACTION.Chaos]==2) and (faction_defeated[eFACTION.Chaos]==0) then times+=1;
    var xx3, yy3, plani, _star;
    xx3=irandom(room_width)+1;
    yy3=irandom(room_height)+1;
    _star=instance_nearest(xx3,yy3,obj_star);
    plani=floor(random(_star.planets))+1;

    // ** Chaos influence / corruption **
    if (faction_gender[eFACTION.Chaos]==1) and (faction_defeated[eFACTION.Chaos]==0) and (turn>=chaos_turn) then repeat(times){
        if (_star.p_type[plani]!="Dead") and (_star.planets>0) and (turn>=20){
            var cathedral=0;
            if (planet_feature_bool(_star.p_feature[plani], P_features.Sororitas_Cathedral)==1) then cathedral=choose(0,1,1);
        
            if (cathedral=0){
                if (_star.p_heresy[plani]>=0) and (_star.p_heresy[plani]<10){
                    _star.p_heresy[plani]+=choose(0,0,0,0,0,0,0,0,5);
                }else if (_star.p_heresy[plani]>=10) and (_star.p_heresy[plani]<20){
                    _star.p_heresy[plani]+=choose(-2,-2,-2,5,10,15);
                }else if(_star.p_heresy[plani]>=20) and (_star.p_heresy[plani]<40){
                    _star.p_heresy[plani]+=choose(-2,-1,0,0,0,0,0,0,5,10);
                }else if(_star.p_heresy[plani]>=40) and (_star.p_heresy[plani]<60){
                    _star.p_heresy[plani]+=choose(-2,-1,0,0,0,0,0,0,5,10,15);
                }else if(_star.p_heresy[plani]>=60) and (_star.p_heresy[plani]<100){
                    _star.p_heresy[plani]+=choose(-1,0,0,0,0,5,10,15);
                }
            }
            if (_star.p_heresy[plani]<0) then _star.p_heresy[plani]=0;
        }
    }

    instance_activate_object(obj_star);
});

// ** Build new Imperial Ships **
build_planet_defence_fleets();

apothecary_training();
chaplain_training();
librarian_training();
techmarine_training();


if (obj_ini.fleet_type!=1){
    with(obj_temp5){instance_destroy();}
    with(obj_p_fleet){
        if (action!="") then instance_create(x,y,obj_temp5);
        if (x<0) or (x>room_width) or (y<0) or (y>room_height) then instance_create(x,y,obj_temp5);
    }
    if (instance_number(obj_temp5)>=instance_number(obj_p_fleet)) then stahp=1;
    with(obj_temp5){instance_destroy();}
}

var recruits_finished=0,recruit_first="";

var total_recruits = 0;
var i=0;
while (i<array_length(recruit_name)){
    if (recruit_name[i]==""){
        i++; 
        continue;
    };
    if  (recruit_distance[i]<=0) then recruit_training[i]-=1;
    if (recruit_training[i]<=0){
        scr_add_man(obj_ini.role[100][12],10,recruit_exp[i],recruit_name[i],recruit_corruption[i],false,"default",recruit_data[i]);
        if (recruit_first=="") then recruit_first=recruit_name[i];
        recruits_finished+=1;
        array_delete(recruit_name,i,1);
        array_delete(recruit_corruption,i,1);
        array_delete(recruit_distance,i,1);
        array_delete(recruit_training,i,1);
        array_delete(recruit_exp,i,1);
        array_delete(recruit_data,i,1);
        continue;
    } else {
        total_recruits++;
    }
    i++;
}
with(obj_ini){
    scr_company_order(10);
}
if (recruits_finished==1){
    scr_alert("green","recruitment",$"{obj_ini.role[100][12]} {recruit_first} has joined X Company.",0,0);
}else if  (recruits_finished>1){
    scr_alert("green","recruitment",$"{recruits_finished}x {obj_ini.role[100][12]} have joined X Company.",0,0);
}


recruits=total_recruits;

/* TODO implement Lamenters get Black Rage and story
if (turn=240) and (global.chapter_name="Lamenters"){
    obj_ini.strin2+="Black Rage";
    scr_popup("Geneseed Mutation","Your Chapter has begun to have visions and nightmares of Sanguinius' fall.  The less mentally disciplined of your battle-brothers no longer are able to sleep soundly, waking from sleep in a screaming, frothing rage.  It appears the Black Rage has returned.","black_rage","");    
}
*/
// ** Battlefield Loot **
if (scr_has_adv("Tech-Scavengers")){
    var lroll1,lroll2,loot="";
    lroll1=roll_dice_chapter(1, 100, "low");
    lroll2=roll_dice_chapter(1, 100, "low");
    if (lroll1<=5){
        loot=choose("Chainsword","Bolt Pistol","Combat Knife","Narthecium");
        if (lroll2<=80) then loot=choose("Power Sword","Storm Bolter");
        if (lroll2<=60) then loot=choose("Plasma Pistol","Chainfist","Lascannon","Heavy Bolter","Assault Cannon","Bike");
        if (lroll2<=30) then loot=choose("Artificer Armour","Plasma Gun","Chainfist","Rosarius","Psychic Hood");
        if (lroll2<=10) then loot=choose("Terminator Armour","Artificer Armour","Dreadnought","Plasma Gun","Power Fist","Thunder Hammer","Iron Halo");
        var tix="A "+string(loot)+" has been gifted to the Chapter.";
        tix=string_replace(tix,"A A","An A");
        tix=string_replace(tix,"A E","An E");
        tix=string_replace(tix,"A I","An I");
        tix=string_replace(tix,"A O","An O");
        scr_add_item(string(loot),1);
        scr_alert("","loot",tix,0,0);
    }
}
imperial_navy_fleet_construction();

// ** Adeptus Mechanicus Geneseed Tithe **
if (gene_tithe==0) and (faction_status[eFACTION.Imperium]!="War"){
    gene_tithe=24;

    var expected,txt="",mech_mad=false;
    var onceh=0;
    expected=max(1,round(obj_controller.gene_seed/20));
    if (obj_controller.faction_status[eFACTION.Mechanicus]=="War") then mech_mad=true;

    if (obj_controller.gene_seed<=0) or (mech_mad==true){
        onceh=2;
        gene_iou+=1;
        loyalty-=2;
        loyalty_hidden-=2;
        txt="No Gene-Seed for Adeptus Mechanicus tithe.  High Lords of Terra IOU increased to "+string(gene_iou)+".";
    }
    if (mech_mad==false){
        if (obj_controller.gene_seed>0) and (und_gene_vaults==0) and (onceh==0){
            obj_controller.gene_seed-=expected;
            onceh=1;
            if (obj_controller.gene_seed>=gene_iou) and (gene_iou>0){
                expected+=gene_iou;
                obj_controller.gene_seed-=gene_iou;
                gene_iou=0;
                onceh=3;
            }
            for(var i=0; i<50; i++){
                if (obj_controller.gene_seed<gene_iou) and (obj_controller.gene_seed>0) and (gene_iou>0){
                    expected+=1;
                    obj_controller.gene_seed-=1;
                    gene_iou-=1;
                    if (gene_iou==0) then onceh=3;
                }
            }

            if (gene_iou<0) then gene_iou=0;

            txt=string(expected)+" Gene-Seed sent to Adeptus Mechanicus for tithe.";
            if (gene_iou>0) then txt+="  IOU remains at "+string(gene_iou)+".";
            if (onceh==3) then txt+="  IOU has been payed off.";
        }

        if (obj_controller.gene_seed>0) and (und_gene_vaults>0) and (onceh==0){
            expected=1;
            obj_controller.gene_seed-=expected;
            onceh=1;

            if (obj_controller.gene_seed<gene_iou) and (obj_controller.gene_seed>0) and (gene_iou>0){
                expected+=1;
                obj_controller.gene_seed-=1;
                gene_iou-=1;
                if (gene_iou==0) then onceh=3;
            }

            if (gene_iou<0) then gene_iou=0;

            txt=string(expected)+" Gene-Seed sent to Adeptus Mechanicus for tithe.";
            if (gene_iou>0) then txt+="  IOU remains at "+string(gene_iou)+".";
            if (onceh==3) then txt+="  IOU has been payed off.";
        }

        if (onceh!=2){
            scr_alert("green","tithes",txt,0,0);
            scr_event_log("",txt);
        }
        if (onceh==2){
            scr_alert("red","tithes",txt,0,0);
            scr_event_log("red",txt);
        }
    }
}
if (gene_sold>0){
    disc=0;
    droll=0;
    gene_sold=floor(gene_sold*75)/100;

    if (gene_sold<1) then gene_sold=0;
    if (gene_sold>=50){
        disc=round(gene_sold/7);
        droll=floor(random(100))+1;

        // Inquisition takes notice
        if (droll<=disc) and (obj_controller.known[eFACTION.Inquisition]!=0){
            var disp_change=-3;
            if (gene_sold>=100) then disp_change=-5;
            if (gene_sold>=200) then disp_change=-7;
            if (gene_sold>=400) then disp_change=-10;
            gene_sold=0;
            scr_audience(4,"gene_trade",disp_change,"",2,0);
        }
    }
}
if (gene_xeno>0){
    disc=0;
    droll=0;
    gene_xeno=floor(gene_xeno*90)/100;

    if (gene_xeno<1) then gene_xeno=0;
    if (gene_xeno>=5){
        disc=round(gene_xeno/5);
        droll=floor(random(100))+1;

        // Inquisition takes notice
        if (droll<=disc) and (obj_controller.known[eFACTION.Inquisition]!=0){
            gene_xeno=99999;
            alarm[8]=1;
        }
    }
}
var p=0,penitorium=0, unit;
for (var c = 0; c < 11; c++){
    for (var e = 0; e < array_length(obj_ini.god[c]); e++){
        if (obj_ini.god[c][e] == 10){
            unit=fetch_unit([c,e]);
            p+=1;
            penit_co[p]=c;
            penit_id[p]=e;
            penitorium+=1;
            unit.alter_loyalty(-1);
            if (unit.corruption<90) and (unit.corruption>0){
                var heresy_old=0,heresy_new=0;
                heresy_old=round((unit.corruption*unit.corruption)/50)-0.5;
                heresy_new=(heresy_old*50)/unit.corruption;
                unit.corruption=max(0,heresy_new);
            }
        }
    }
}
// STC Bonuses
if (obj_controller.stc_ships>=6){
    //self healing ships logic
    for (var v=0; v<array_length(obj_ini.ship_hp); v++){
        if (obj_ini.ship[v]=="" || obj_ini.ship_hp[v]<0) then continue;
        if (obj_ini.ship_hp[v]<obj_ini.ship_maxhp[v]){
            var _max = obj_ini.ship_maxhp[v];
            obj_ini.ship_hp[v] = min(_max,obj_ini.ship_hp[v]+round(_max*0.06));
        }
    }
}

try_and_report_loop("Secret Chaos Warlord spawn", function(){
    if (turn==5) and (faction_gender[eFACTION.Chaos]==1) {// show_message("Turn 100");

        var _star_found = false;
        var _choice_star = noone;
        var _stars = scr_get_stars(true);
        for (var i=0;i<array_length(_stars);i++){
            if (is_dead_star(_stars[i])) then continue;
            with (_stars[i]){
                if (owner==eFACTION.Imperium && planets){
                    if (scr_orbiting_fleet(eFACTION.Imperium) != "none"){
                        _star_found=true;
                        _choice_star = self.id;
                        break;
                    }
                } 
            }
            if (_star_found){
                break;
            }
        }
        if (_star_found){
            var _planet = array_random_element(planets_without_type("Dead",_choice_star));
            _choice_star.warlord[_planet]=1;
            array_push(_choice_star.p_feature[_planet], new NewPlanetFeature(P_features.Warlord10));

            var _heresy_inc = _choice_star.p_type[_planet]=="Hive" ? 25 : 10;

            _choice_star.p_heresy[_planet] += _heresy_inc;

            if (_choice_star.p_heresy[_planet]<50) then _choice_star.p_heresy_secret[_planet]=10;        
        }
    }
});
// * Blood debt end *
if (blood_debt==1) and (penitent==1){
    penitent_turn+=1;
    // was -60
    penitent_turnly=((penitent_turn*penitent_turn)-512)*-1;
    if (penitent_turnly>0) then penitent_turnly=0;
    penitent_current+=penitent_turnly;
    if (penitent_current<=0){
        penitent=0;
        alarm[8]=1;
    }
    if (penitent_end<30000) then penitent_end+=41000;
    if (penitent_current>=penitent_max) or (((obj_controller.millenium*1000)+obj_controller.year)>=penitent_end){
        penitent=0;
        if (known[eFACTION.Inquisition]==2) or (known[eFACTION.Inquisition]>=4) then scr_audience(4,"penitent_end",0,"",0,0);
        if (known[eFACTION.Ecclesiarchy]>=2) then scr_audience(5,"penitent_end",0,"",0,0);
        disposition[eFACTION.Imperium]+=20;
        disposition[eFACTION.Mechanicus]+=15;
        disposition[eFACTION.Inquisition]+=20;
        disposition[eFACTION.Ecclesiarchy]+=20;
        var o=0;
        if (scr_has_adv("Reverent Guardians")) then o=500;
        if (o>100) then obj_controller.disposition[eFACTION.Ecclesiarchy]+=10;
        scr_event_log("","Blood Debt payed off.  You may once more recruit Astartes.");
    }
}
// * Penitent Crusade end *
if (penitent==1) and (blood_debt==0){
    penitent_turn+=1;
    penitent_current+=1;
    penitent_turnly=0;

    if (penitent_current<=0){
        penitent=0;
        alarm[8]=1;
    }
    if (penitent_current>=penitent_max){
        penitent=0;
        if (known[eFACTION.Inquisition]==2) or (known[eFACTION.Inquisition]>=4) then scr_audience(4,"penitent_end",0,"",0,0);
        if (known[eFACTION.Ecclesiarchy]>=2) then scr_audience(5,"penitent_end",0,"",0,0);
        disposition[eFACTION.Imperium]+=20;
        disposition[eFACTION.Mechanicus]+=15;
        disposition[eFACTION.Imperium]+=20;
        disposition[eFACTION.Ecclesiarchy]+=20;
        var o=0;
        if (scr_has_adv("Reverent Guardians")) then o=500;
        if (o>100) then obj_controller.disposition[eFACTION.Ecclesiarchy]+=10;
        scr_event_log("","Penitent Crusade ends.  You may once more recruit Astartes.");
    }
}
// ** Ork WAAAAGH **
if ((turn>=irandom(200)+100) or (obj_ini.fleet_type==eFACTION.Mechanicus)) and (faction_defeated[eFACTION.Ork]==0){

}

if (known[eFACTION.Ecclesiarchy]==1){
    spikky=choose(0,1,1);
    if (spikky){
        var _topic = faction_status[eFACTION.Ecclesiarchy]=="War" ? "declare_war" : "intro";
        scr_audience(eFACTION.Ecclesiarchy, _topic);
    }
}
if (known[eFACTION.Eldar]==1) and (faction_defeated[eFACTION.Eldar]==0){
    spikky=choose(0,1);
    if (spikky==1){
        scr_audience(eFACTION.Eldar, "intro1");
    }
}
if (known[eFACTION.Ork]==0.5) and (faction_defeated[eFACTION.Ork]==0){
    if (1==irandom(7)){
        scr_audience(eFACTION.Ork, "intro");
    }
}
if (known[eFACTION.Tau]==1) and (faction_defeated[eFACTION.Tau]==0){
    scr_audience(eFACTION.Tau, "intro");
}
// ** Quests here **
// 135 ; quests
for(var i=1; i<=40; i++){
    if (quest_end[i]<=turn) and (quest[i]!=""){
        scr_quest(1,quest[i],quest_faction[i],0);
        quest[i]="";
    }
    if (quest[i]=="") and (quest[i+1]!=""){
        quest[i]=quest[i+1];
        quest_faction[i]=quest_faction[i+1];
        quest_end[i]=quest_end[i+1];
        quest[i+1]+="";
        quest_faction[i+1]=0;
        quest_end[i+1]=0;
    }
}
// ** Inquisition stuff here **
if (disposition[eFACTION.Eldar]>=60) then scr_loyalty("Xeno Associate","+");
if (disposition[eFACTION.Ork]>=60) then scr_loyalty("Xeno Associate","+");
if (disposition[eFACTION.Tau]>=60) then scr_loyalty("Xeno Associate","+");

var loyalty_counter=0;
loyalty_counter=scr_role_count(obj_ini.role[100][15],"");
if (loyalty_counter==0) then scr_loyalty("Lack of Apothecary","+");

loyalty_counter=scr_role_count(obj_ini.role[100][14],"");
if (loyalty_counter==0) then scr_loyalty("Undevout","+");
// TODO in another PR rework how Non-Codex Size is determined, perhaps the inquisition needs to pass some checks or do an investigation event 
// which you could eventually interrupt (kill the team) and cover it up?
if (marines>=1050) then scr_loyalty("Non-Codex Size","+");

var last_inquisitor_inspection=0;
if (obj_ini.fleet_type=ePlayerBase.home_world) then last_inquisitor_inspection=last_world_inspection;
if (obj_ini.fleet_type != ePlayerBase.home_world) then last_inquisitor_inspection=last_fleet_inspection;

var inspec=false;
if (loyalty>=85) and ((last_inquisitor_inspection+59)<turn) then inspec=true;
if (loyalty>=70) and (loyalty<85) and ((last_inquisitor_inspection+47)<turn) then inspec=true;
if (loyalty>=50) and (loyalty<70) and ((last_inquisitor_inspection+35)<turn) then inspec=true;
if (loyalty<50) and ((last_inquisitor_inspection+11+choose(1,2,3,4))<turn) then inspec=true;

if (obj_ini.fleet_type != ePlayerBase.home_world){
    if (instance_number(obj_p_fleet)==1) and (obj_ini.fleet_type = ePlayerBase.home_world){// Might be crusading, right?
        if (obj_p_fleet.x<0) or (obj_p_fleet.x>room_width) or (obj_p_fleet.y<0) or (obj_p_fleet.y>room_height) then inspec=false;
    }
    if (instance_number(obj_p_fleet)==0) then inspec=false;
}
instance_activate_object(obj_p_fleet);

//setup inquisitor inspections
var inquisitor_fleet_count = 0;
with(obj_fleet){if (owner==eFACTION.Inquisition) then inquisitor_fleet_count++}

inspec = (inspec && faction_status[eFACTION.Inquisition]!="War" &&inquisitor_fleet_count==0);
if (inspec)  {
    new_inquisitor_inspection();
}

with(obj_temp6){instance_destroy();}

for(var i=1; i<=10; i++){
    if (turns_ignored[i]==0) and (annoyed[i]>0) then annoyed[i]-=1;
}

// ** Various checks for imperium and faction relations **
try{
    event_end_turn_action();
} catch(_exception){
    handle_exception(_exception);
}
// Right here need to sort the battles within the obj_turn_end
with(obj_turn_end){scr_battle_sort();}

for(var i=1; i<=10; i++){
    if (turns_ignored[i]>0) and (turns_ignored[i]<500) then turns_ignored[i]-=1;
}
if (known[eFACTION.Eldar]>=2) and (faction_gender[6]==2) and (turn%10==0) then turns_ignored[6]+=floor(random_range(0,6));

with(obj_ground_mission){instance_destroy();}
scr_random_event(true);

// ** Random events here **
if (hurssy_time>0) and (hurssy>0) then hurssy_time-=1;
if (hurssy_time==0) and (hurssy>0){hurssy_time=-1;hurssy=0;}
with(obj_p_fleet){
    if (hurssy_time>0) and (hurssy>0) then hurssy_time-=1;
    if (hurssy_time==0) and (hurssy>0){hurssy_time=-1;hurssy=0;}
}
with(obj_star){
    if (p_hurssy_time[1]>0) and (p_hurssy[1]>0) then p_hurssy_time[1]-=1;
    if (p_hurssy_time[1]==0) and (p_hurssy[1]>0){
        p_hurssy_time[1]=-1;
        p_hurssy[1]=0;
    }
    if (p_hurssy_time[2]>0) and (p_hurssy[2]>0) then p_hurssy_time[2]-=1;
    if (p_hurssy_time[2]==0) and (p_hurssy[2]>0){
        p_hurssy_time[2]=-1;
        p_hurssy[2]=0;
    }
    if (p_hurssy_time[3]>0) and (p_hurssy[3]>0) then p_hurssy_time[3]-=1;
    if (p_hurssy_time[3]=0) and (p_hurssy[3]>0){
        p_hurssy_time[3]=-1;
        p_hurssy[3]=0;
    }
    if (p_hurssy_time[4]>0) and (p_hurssy[4]>0) then p_hurssy_time[4]-=1;
    if (p_hurssy_time[4]==0) and (p_hurssy[4]>0){
        p_hurssy_time[4]=-1;
        p_hurssy[4]=0;
    }
}

if (turn==2){
    if (obj_ini.master_name=="Zakis Randi") or (global.chapter_name=="Knights Inductor") and (obj_controller.faction_status[eFACTION.Imperium]!="War") then alarm[8]=1;
}
// ** Player-set events **
if (fest_scheduled>0) and (fest_repeats>0){
    var lock="",cm_present=false;
    fest_repeats-=1;
    lock=scr_master_loc();

    if (fest_sid>0) and (obj_ini.ship[fest_sid]=lock) then cm_present=true;
    if (fest_wid>0) and (string(fest_star)+"."+string(fest_wid)=lock) then cm_present=true;

    if (cm_present==true){
        var imag="";

        if (fest_type=="Great Feast") then imag="event_feast";
        if (fest_type=="Tournament") then imag="event_tournament";
        if (fest_type=="Deathmatch") then imag="event_deathmatch";
        if (fest_type=="Imperial Mass") then imag="event_mass";
        if (fest_type=="Cult Sermon") then imag="event_ccult";
        if (fest_type=="Chapter Relic") then imag="event_ccrelic";
        if (fest_type=="Triumphal March") then imag="event_march";

        if (fest_wid>0) then scr_popup("Scheduled Event","Your "+string(fest_type)+" takes place on "+string(fest_star)+" "+scr_roman(fest_wid)+".  Would you like to spectate the event?",imag,"");
        if (fest_sid>0) then scr_popup("Scheduled Event","Your "+string(fest_type)+" takes place on the ship '"+string(obj_ini.ship[fest_sid])+".  Would you like to spectate the event?",imag,"");
    }
}

// ** Income **
// if (income_controlled_planets>0){

//     var tithe_string = income_controlled_planets==1? $"-{income_tribute} Requisition granted by tithes from 1 planet.": $"-{income_tribute} Requisition granted by tithes from {income_controlled_planets} planets.";
//     scr_alert("yellow", "planet_tithe", tithe_string);
//     instance_activate_object(obj_p_fleet);

//     with(obj_star){
//         if (x<-10000){
//             x+=20000;
//             y+=20000;
//         }
//     }
// }

//research and forge related actions

research_end();
merge_ork_fleets();
location_viewer.update_mission_log();
init_ork_waagh();
return_lost_ships_chance();
//complex route plotting for player fleets
with (obj_p_fleet){
    if (array_length(complex_route)>0  && action == ""){
        set_new_player_fleet_course(complex_route);
    }
}

});


instance_activate_object(obj_star);
instance_activate_object(obj_en_fleet);


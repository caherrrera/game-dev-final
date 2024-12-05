/// @description Insert description here
// You can write your code in this editor

enum STATES {
	COMP_DEAL,
	PLAYER_DEAL,
	PLAYER_CHOOSE,
	COMPARE,
	RESOLVE,
	ENDGAME
}

global.state = STATES.COMP_DEAL;

//variables
hand_x_offset = 100; 
start_x = room_width * 0.1;
num_cards = 8;
move_timer = 0;

end_timer = 100;
played = false;

in_player_hand = false; 
last_y = 0; 

comp_score = 0;
player_score = 0; 

//lists and arrays oh my
deck = ds_list_create();
player_deck = ds_list_create();

comp_hand = ds_list_create();
global.player_hand = ds_list_create(); 

global.player_select = []; 

zone_deck = ds_list_create(); 
global.zone_pos = []; 


for(var i = 0; i < num_cards; i++) {
	var new_card = instance_create_layer(x,y,"Cards", obj_card);
	
	new_card.face_up = false;
	new_card.face_index = i+1;
	
	new_card.target_x = x;
	new_card.target_y = y; 
	
	ds_list_add(deck, new_card);
}

for(var i = 0; i < num_cards; i++) {
	var new_card = instance_create_layer(x,y,"Zones", obj_card);
	
	new_card.face_index = 0;//zone sprite
	new_card.face_up = false;
	
	new_card.target_x = start_x;
	new_card.target_y = y; 
	
	ds_list_add(zone_deck, new_card);
}

for(var i = 0; i < num_cards; i++) {
	var new_card = instance_create_layer(x,y,"Cards", obj_card);
	
	new_card.face_index = i+1;
	new_card.face_up = true; //should always be true
	new_card.matched = false; 
	
	new_card.in_player_hand = false;
	
	new_card.target_x = x;
	new_card.target_y = y+500; 
	
	ds_list_add(player_deck, new_card);
}

randomize();
ds_list_shuffle(deck);

for(var i = 0; i < num_cards; i++) {
	deck[| i].depth = num_cards - i;
	deck[| i].target_y = y - (2 * i);
	deck[| i].target_x = start_x;
}

for(var i = 0; i < num_cards; i++) {
	player_deck[| i].depth = num_cards - i;
	player_deck[| i].target_y = y - (2 * i)+500;
	player_deck[| i].target_x = start_x;
}


//making particles yas
parts = part_system_create();
part_system_depth(parts,30);

w_glow = part_type_create(); //match effect
part_type_shape(w_glow, pt_shape_flare);
part_type_size(w_glow, 1, 2, 0,0.5);
part_type_speed(w_glow, 0,0.5, 0,0);
part_type_direction(w_glow, 0,360, 0,0);
part_type_life(w_glow, 30, 60);
part_type_color1(w_glow, c_white);
part_type_alpha3(w_glow, 0.1, 0.3, 0); 
part_type_blend(w_glow, true);

r_glow = part_type_create(); //no match effect
part_type_shape(r_glow, pt_shape_flare);
part_type_size(r_glow, 1, 2, 0,0.5);
part_type_speed(r_glow, 0,0.5, 0,0);
part_type_direction(r_glow, 0,360, 0,0);
part_type_life(r_glow, 30, 60);
part_type_color1(r_glow, c_red);
part_type_alpha3(r_glow, 0, 0.3, 0); 
//part_type_blend(r_glow, true);

g_glow = part_type_create(); //all match effect
part_type_shape(g_glow, pt_shape_flare);
part_type_size(g_glow, 1, 2, 0,0.5);
part_type_speed(g_glow, 0,0.5, 0,0);
part_type_direction(g_glow, 0,360, 0,0);
part_type_life(g_glow, 30, 50);
part_type_color1(g_glow, c_green);
part_type_alpha3(g_glow, 0.1, 0.3, 0); 
//part_type_blend(g_glow, true);








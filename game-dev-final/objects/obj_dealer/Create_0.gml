/// @description Insert description here
// You can write your code in this editor

enum STATES {
	COMP_DEAL,
	PLAYER_DEAL,
	PLAYER_CHOOSE,
	COMPARE,
	RESOLVE,
	RESHUFFLE
}

global.state = STATES.COMP_DEAL;

//variables
hand_x_offset = 100; 
start_x = room_width * 0.1;
num_cards = 8;
move_timer = 0;

in_player_hand = false; 

comp_score = 0;
player_score = 0; 

//lists
deck = ds_list_create();
player_deck = ds_list_create();

comp_hand = ds_list_create();
global.player_hand = ds_list_create(); 

global.player_select = []; 

zone_deck = ds_list_create(); //snap to drop in place 
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






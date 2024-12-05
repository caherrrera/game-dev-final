/// @description Insert description here
// You can write your code in this editor

switch(global.state){
	case STATES.COMP_DEAL:
	//show_debug_message("comp_deal state");
	if(move_timer == 0){
		var _comp_num = ds_list_size(comp_hand);
		if(_comp_num < 8){
			if (ds_list_size(deck) > 0) {
                var _comp_card = ds_list_find_value(deck, ds_list_size(deck) - 1);
                
                ds_list_delete(deck, ds_list_size(deck) - 1); // Remove from deck
                ds_list_add(comp_hand, _comp_card); // Add to computer hand

                // Set target positions for the card
                _comp_card.target_x = room_width / 4 + (_comp_num * hand_x_offset);
                _comp_card.target_y = room_height * 0.1;
				audio_play_sound(snd_move, 1, false);
                
                _comp_card.face_up = false;
			}
			
			if(ds_list_size(zone_deck) > 0){
				var _zone = ds_list_find_value(zone_deck, ds_list_size(zone_deck)-1);
			
				ds_list_delete(zone_deck, ds_list_size(zone_deck)-1);
				array_push(global.zone_pos, _zone);
				
				_zone.target_x = room_width / 4 + (_comp_num * hand_x_offset);
				_zone.target_y = (room_height * 0.1)+150;
				
				_zone.face_up = true; 
			}
		}
	}
	else if(ds_list_size(comp_hand) == 8) {
				global.state = STATES.PLAYER_DEAL;	
		}
	break;
	
	
	case STATES.PLAYER_DEAL:	
	
	if(move_timer == 0){
		var _player_num = ds_list_size(global.player_hand);
		if(_player_num < 8){
			if (ds_list_size(player_deck) > 0) {
                var _dealt_card = ds_list_find_value(player_deck, ds_list_size(player_deck) - 1);
                
                ds_list_delete(player_deck, ds_list_size(player_deck) - 1);
                ds_list_add(global.player_hand, _dealt_card);
                
                _dealt_card.target_x = x + room_width / 4 + _player_num * hand_x_offset;
                _dealt_card.target_y = 530; //used to b roomheight * 0.7
				//show_debug_message("player_deal target y: "+string(_dealt_card.target_y));
				audio_play_sound(snd_move, 1, false);
                
	            _dealt_card.in_player_hand = true; 
				
					//if(_dealt_card.y == 530 && _player_num==8){ //was moving on before last card could be placed
					//	cards_set = true;
					//}
				}
				show_debug_message("y" +  string(_dealt_card.y));
				show_debug_message("num" + string(_player_num));

			}
			for(i = 0; i < ds_list_size(global.player_hand); i++){
					if(i == 7){
						last_y = global.player_hand[| i].y;
					}
				}
			
		}	
		 if(last_y == 530) {
				global.state = STATES.PLAYER_CHOOSE;	
			//show_debug_message("list size:" + string(ds_list_size(player_hand)));
		}
	
	break;
	
	case STATES.PLAYER_CHOOSE:
		//show_debug_message("player choose state");
		//show_debug_message("choose state list size:" + string(ds_list_size(global.player_hand)));


		if(obj_button.is_pressed){ //player done placing 
			global.state = STATES.COMPARE;
			obj_button.is_pressed = false; 
		}
		
	break;
	
	case STATES.COMPARE:
	//show_debug_message("COMPARETIMEEE")
	show_debug_message("compare: player hand size:" + string(ds_list_size(global.player_hand)));
		var tolerance = 15; //how close x pos are 
		var unmatched_cards = 0; 
		show_debug_message("playerselectlength:"+string(array_length_1d(global.player_select)));
		show_debug_message("comp_hand length: " + string(ds_list_size(comp_hand)));

		for (var i = 0; i < array_length_1d(global.player_select); i++) {
			player_x = global.player_select[i].x;
			var paired = false;
			var player_card = global.player_select[i];
			
			for (var j = 0; j < ds_list_size(comp_hand); j++) {
				var comp_card = ds_list_find_value(comp_hand, j);
		
				if (abs(comp_card.x - player_x) <= tolerance) { //dist
					paired = true; 	//find what card player has matched it to 
					//show_debug_message("paired:"+string(comp_card.x)+string(player_x));
					if(player_card.face_index == comp_card.face_index) {
						comp_card.face_up = true;
						player_card.matched = true; 
						show_debug_message("match!!"+string(player_card.face_index)+string(comp_card.face_index));
						part_particles_create(parts,player_card.x+41,player_card.y+66,w_glow,10);
					
					} else {
						show_debug_message("no match");
						unmatched_cards++; 
						ds_list_add(global.player_hand, player_card);
						//part_particles_create(parts,player_card.x+41,player_card.y+66,r_glow,10);
					}
					break; //exit loop
				}
			}
		}
		

		if (unmatched_cards == array_length_1d(global.player_select)) { //no selected cards are matched
			audio_play_sound(snd_no_match, 1, false); 
	        global.state = STATES.RESOLVE;
	    } else if(unmatched_cards == 0) {
			audio_play_sound(snd_win, 1, false); //all cards match
	        global.state = STATES.ENDGAME;
		}	else if (unmatched_cards < array_length_1d(global.player_select)) { //some selected cards are matched
			audio_play_sound(snd_match, 1, false);
			global.state = STATES.RESOLVE;
			}
		
	break;
	
	case STATES.RESOLVE:
	//show_debug_message("**RESOLVE**");
		global.player_select = []; //clear array to select again
		
		var og_y = room_height * 0.7;  

	    for (var i = 0; i < ds_list_size(global.player_hand); i++) {
				var player_card = ds_list_find_value(global.player_hand, i);
			if(!player_card.matched){
				player_card.target_y = og_y;
				player_card.target_x = player_card.target_x;  
				
				player_card.in_player_hand = true; 
				
				player_card.in_zone = false;
				player_card.dropped = false; 
			}
				if(player_card.target_y == og_y){
				part_particles_create(parts,player_card.target_x+41,player_card.target_y+66,r_glow,10);	
			}
		}
		
		if (ds_list_size(global.player_hand) > 0) {
			//show_debug_message("end of resolve : playerhand size:" + string(ds_list_size(global.player_hand)));
			//show_debug_message("end of resolve : playerselect size:" + string(array_length_1d(global.player_select)));
			global.state = STATES.PLAYER_CHOOSE;
		}
		
	break;
	
	case STATES.ENDGAME:
		end_timer--;
		
		if(!played){
			for(i = 0; i < array_length_1d(global.player_select); i++){
				var _card = array_get(global.player_select, i);
				part_particles_create(parts, _card.x+41, _card.y+66, g_glow,10);
				played = true;
			}
		}
	
		if(end_timer == 0){
			room_goto_next();
		}
		
	break;
}


move_timer++;
if(move_timer == 16){
	move_timer = 0; 	
}
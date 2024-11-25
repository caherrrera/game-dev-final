/// @description Insert description here
// You can write your code in this editor

switch(global.state){
	case STATES.COMP_DEAL:
	//show_debug_message("comp_deal state");
	if(move_timer == 0){
		var _comp_num = ds_list_size(comp_hand);
		if(_comp_num < 8){
			if (ds_list_size(deck) > 0) {
                // Get the last card from the deck without creating a new instance
                var _comp_card = ds_list_find_value(deck, ds_list_size(deck) - 1);
                
                // Move this card to the computer hand
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
                _dealt_card.target_y = room_height * 0.7;
				audio_play_sound(snd_move, 1, false);
                
                _dealt_card.in_player_hand = true; 
			}
			
			}
		}
		 else if(ds_list_size(global.player_hand) == 8) {
				global.state = STATES.PLAYER_CHOOSE;	
			//show_debug_message("list size:" + string(ds_list_size(player_hand)));
		}
	
	break;
	
	case STATES.PLAYER_CHOOSE:
		//show_debug_message("player choose state");
		//show_debug_message("choose state list size:" + string(ds_list_size(global.player_hand)));

		if(obj_button.is_pressed){ //player done placing 
			var select_length = array_length_1d(global.player_select);
			var half_length = floor(select_length/2);//int
		
			for (var i = 0; i < half_length; i++){
				array_delete(global.player_select, 0, 1);	
				} 
			global.state = STATES.COMPARE;
				
			obj_button.is_pressed = false; 
		}
	//show_debug_message("select size after trimming:" + string(array_length_1d(global.player_select)));
	break;
	
	case STATES.COMPARE:
	//show_debug_message("COMPARETIMEEE")
	//show_debug_message("compare list size:" + string(ds_list_size(global.player_hand)));
		var tolerance = 15; //how close x pos are 
		var unmatched_cards = 0; 
		//show_debug_message("playerlength:"+string(array_length_1d(global.player_select)));
		//show_debug_message("comp_hand length: " + string(ds_list_size(comp_hand)));
		show_debug_message(array_length_1d(global.player_select));
		for (var i = 0; i < array_length_1d(global.player_select); i++) {
			//show_debug_message("array run");
			player_x = global.player_select[i].x;
			var paired = false;
			var player_card = global.player_select[i];
			
			for (var j = 0; j < ds_list_size(comp_hand); j++) {
				//show_debug_message("comp hand ");
				var comp_card = ds_list_find_value(comp_hand, j);
				
				//show_debug_message("Comparing comp_card.x: " + string(comp_card.x) + " with player_x: " + string(player_x));

				
				if (abs(comp_card.x - player_x) <= tolerance) { //dist
					paired = true; 	//find what card player has matched it to 
					//show_debug_message("paired:"+string(comp_card.x)+string(player_x));
					//show_debug_message("tolerance  ");
					if(player_card.face_index == comp_card.face_index) {
						//match = true;
						comp_card.face_up = true;
						player_card.matched = true; 
						show_debug_message("match!!"+string(player_card.face_index)+string(comp_card.face_index));
					} else {
						show_debug_message("no match");
						unmatched_cards++; 
						ds_list_add(global.player_hand, player_card);
					}
					break; //exit loop
				}
			}
		}
		
		var select_length = array_length_1d(global.player_select);

		if (unmatched_cards > 0) {
			audio_play_sound(snd_match, 1, false);
	        global.state = STATES.RESOLVE;
	    } else if (unmatched_cards == 8) {
			audio_play_sound(snd_no_match, 1, false);
			global.state = STATES.RESOLVE;
		} else {
			audio_play_sound(snd_win, 1, false);
	        global.state = STATES.RESHUFFLE;
	    }
		
	break;
	
	case STATES.RESOLVE:
	//show_debug_message("resolve list size:" + string(ds_list_size(global.player_hand)));
	//	show_debug_message("resolve state");
		global.player_select = []; //clear array to select again
		
		var og_y = room_height * 0.7;  

	    for (var i = 0; i < ds_list_size(global.player_hand); i++) {
				var player_card = ds_list_find_value(global.player_hand, i);
			if(!player_card.matched){
				player_card.target_y = og_y;
				player_card.target_x = player_card.target_x;  
				player_card.in_player_hand = true; 
				show_debug_message("player_hand cards reset");
			}
		}
		
		if (ds_list_size(global.player_hand) > 0) {
			global.state = STATES.PLAYER_CHOOSE;
		}
		
	break;
	
	case STATES.RESHUFFLE:
	//add cards back to decks --> comp_deal state
	//show_debug_message("reshuffle state");

		room_goto_next();
		
		global.state = STATES.COMP_DEAL;
		
	break;
}


move_timer++;
if(move_timer == 16){
	move_timer = 0; 	
}
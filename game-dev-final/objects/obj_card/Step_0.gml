/// @description Insert description here
// You can write your code in this editor

switch(global.state){
case STATES.PLAYER_CHOOSE:

	show_debug_message("player choose state start"); 
	show_debug_message("select array size:" + string(array_length_1d(global.player_select)));//should be empty
	show_debug_message("hand list size:" + string(ds_list_size(global.player_hand))); //should have cards
	show_debug_message("in player hand? "+string(in_player_hand)); 
	
	in_zone = false; 
		if(!dragging){
				show_debug_message("not dragging");//reaches here
			og_x = x;
			og_y = y;
			if (in_player_hand) { //sometimes false??
		        if (position_meeting(mouse_x, mouse_y, id) 
									&& mouse_check_button_pressed(mb_left)) { 
		            dragging = true; //not reached on second round
					//in_zone = false; //reset 
		        }
			}
		}
	
		if(dragging){
				show_debug_message("dragging");
			target_x = mouse_x - sprite_width/2;
			target_y = mouse_y - sprite_height/2;  
		}
		
	if (mouse_check_button_released(mb_left)) {
		show_debug_message("mouse check release");//not reaching here
	    dragging = false;
	    var nearest_distance = 1000; 
	    var snap_threshold = 50; 
	    var closest_x = og_x;
	    var closest_y = og_y;

	    for (var i = 0; i < array_length(global.zone_pos); i++) {
	        var zone_x = global.zone_pos[i].x; //go thru list and update x,y 
			var zone_y = global.zone_pos[i].y;

			var distance = point_distance(x, y, zone_x, zone_y);//find distance from card to zone

	            if (distance < nearest_distance) {//set to nearest_distance if small enough
	                nearest_distance = distance;
	                closest_x = zone_x;
	                closest_y = zone_y;
	            }
	        }
	    // Snap to closest zone if within threshold
	    if (nearest_distance <= snap_threshold) {
	        target_x = closest_x;
	        target_y = closest_y;
			audio_play_sound(snd_snap, 1, false);
	        in_zone = true;
	    } else {
	        target_x = og_x;
	        target_y = og_y;
			in_zone = false;
	    }
	}
	// Add to player_select if dropped in zone
	    if (in_zone && !dropped) {
			show_debug_message("in zone and not dropped");
			if(!array_has_item(global.player_select, id)){
				show_debug_message("array does not have item id"); 
				array_push(global.player_select, id);
				//in_zone = false;
				dropped = true; 
		        show_debug_message("card added to player_select: " + string(id));
				
				var card_index = ds_list_find_index(global.player_hand, id); // Find the card's index in player_hand
                if (card_index != -1) {  // if the card exists
                    ds_list_delete(global.player_hand, card_index); // Remove it from player_hand
                    show_debug_message("card removed from player_hand: " + string(id)); // Debug message
                }
			}
	    }
		in_zone = false;
		dropped = false; 
		show_debug_message("select size, end of player_choose:" + string(array_length_1d(global.player_select)));
        
	break;
}
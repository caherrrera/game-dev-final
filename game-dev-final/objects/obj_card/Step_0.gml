/// @description Insert description here
// You can write your code in this editor

if(in_player_hand){
	switch(global.state){
	case STATES.PLAYER_CHOOSE:
	
			if(!dragging){
				if(!og_y_set){
					og_x = x;
					og_y = y;
					og_y_set = true; 
					//show_debug_message("Original x=" + string(og_x) + ", y=" + string(og_y));
				}
				
				if(!in_zone){
		                if (position_meeting(mouse_x, mouse_y, id)) {
		                    if (target_y != og_y - 20) {
		                        target_y = og_y - 20; 
		                    }
		                } else {
		                    if (target_y != og_y) {
		                        target_y = og_y;
		                    }
		                }
				}
 
	                if (position_meeting(mouse_x, mouse_y, id) 
						&& mouse_check_button_pressed(mb_left)) { 
	                    dragging = true; 
	                }
			}
	
			if(dragging){
				target_x = mouse_x - sprite_width/2;
				target_y = mouse_y - sprite_height/2;  
				//show_debug_message("Dragging: Current position: x=" + string(x) + ", y=" + string(y));
			} 
		
		if (mouse_check_button_released(mb_left)) {
		    dragging = false;
		    var nearest_distance = 1000; 
		    var snap_threshold = 50; 
		    var closest_x = 0; 
		    var closest_y = 0; 
		
			//show_debug_message("player card dropped, Checking zones...");
		
		    for (var i = 0; i < array_length(global.zone_pos); i++) {
				var zone_instance = global.zone_pos[i]; 
			
		        var zone_x = zone_instance.x; //go thru list and update x,y 
				var zone_y = zone_instance.y;

				var distance = point_distance(x, y, zone_x, zone_y);
			
		            if (distance < nearest_distance) {//update nearest_distance if smaller than last
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
		    } 
		}
		// Add to player_select if dropped in zone
		    if (in_zone && !dropped) {

				if(!array_has_item(global.player_select, id)){
					array_push(global.player_select, id);
					dropped = true; 
			        show_debug_message("card added to player_select: " + string(id));
				
					var card_index = ds_list_find_index(global.player_hand, id); 
	                if (card_index != -1) {  
	                    ds_list_delete(global.player_hand, card_index); 
	                    //show_debug_message("card removed from player_hand: " + string(id)); 
	                }
				}
		    } 
			//show_debug_message("select size, end of player_choose:" + string(array_length_1d(global.player_select)));
		break;
	}
}
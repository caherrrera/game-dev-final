/// @description Insert description here
// You can write your code in this editor
if(in_player_hand){
	switch(global.state){
	case STATES.PLAYER_CHOOSE:
	
		//in_zone = false; 
			if(!dragging){
				if(!og_y_set){
					og_x = x;
					og_y = y;
					og_y_set = true; 
					show_debug_message("Original x=" + string(og_x) + ", y=" + string(og_y));
				}
				
				if(!in_zone){
		                if (position_meeting(mouse_x, mouse_y, id)) {
		                    if (target_y != og_y - 20) {
		                        target_y = og_y - 20; 
								show_debug_message("run");
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
				show_debug_message("Dragging: Current position: x=" + string(x) + ", y=" + string(y));
				//pos definitely updating correctly as its dragged
			} 
		
		if (mouse_check_button_released(mb_left)) {
		    dragging = false;
		    var nearest_distance = 1000; 
		    var snap_threshold = 50; 
		    var closest_x = 0; //used to be og x + y
		    var closest_y = 0; //doesnt make a diff ? 
		
			show_debug_message("player card dropped, Checking zones...");
		
		    for (var i = 0; i < array_length(global.zone_pos); i++) {
				var zone_instance = global.zone_pos[i]; 
			
		        var zone_x = zone_instance.x; //go thru list and update x,y 
				var zone_y = zone_instance.y;

				var distance = point_distance(x, y, zone_x, zone_y);//find distance from card to zone
				//dist definitely calculating correctly
				//show_debug_message("Card position: x=" + string(x) + ", y=" + string(y));
				//show_debug_message("Zone position: x=" + string(zone_x) + ", y=" + string(zone_y));
				//show_debug_message("Distance: " + string(distance));
				//show_debug_message("Zone " + string(i) + " - x: " + string(zone_x) + ", y: " + string(zone_y) + ", Distance: " + string(distance));
			
		            if (distance < nearest_distance) {//update nearest_distance if small enough
		                nearest_distance = distance;
		                closest_x = zone_x;
		                closest_y = zone_y;
						//show_debug_message("Nearest zone updated to Zone " + string(i) + " at distance " + string(nearest_distance));
						//loop to find closest zone is working
		            }
		        }
		    // Snap to closest zone if within threshold
			show_debug_message("Nearest distance: " + string(nearest_distance));
		    if (nearest_distance <= snap_threshold) {
				show_debug_message("Snapping to zone x: " + string(closest_x) + ", y: " + string(closest_y));
		        target_x = closest_x;
		        target_y = closest_y;
				show_debug_message("target: " + string(target_x)+","+string(target_y));
				//pos not updating to closest zone OR updating and immediately
				//goes back to original pos....... weird
				audio_play_sound(snd_snap, 1, false);
		        in_zone = true;
		    } //else {
				//show_debug_message("Returning to original position.");
		        //target_x = og_x;
		        //target_y = og_y;	//still reverting back to og pos?? with this commented out
		    //}
		}
		// Add to player_select if dropped in zone
		    if (in_zone && !dropped) {

				if(!array_has_item(global.player_select, id)){
					array_push(global.player_select, id);
					dropped = true; 
			        //show_debug_message("card added to player_select: " + string(id));
				
					var card_index = ds_list_find_index(global.player_hand, id); // Find the card's index in player_hand
	                if (card_index != -1) {  // if the card exists
	                    ds_list_delete(global.player_hand, card_index); // Remove it from player_hand
	                    //show_debug_message("card removed from player_hand: " + string(id)); // Debug message
	                }
				}
		    } 
			//show_debug_message("select size, end of player_choose:" + string(array_length_1d(global.player_select)));
        
		break;
	}
}
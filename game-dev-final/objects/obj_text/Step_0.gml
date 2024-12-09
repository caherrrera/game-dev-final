/// @description Insert description here
// You can write your code in this editor

if(room == rm_start){
	global.char_sprite = spr_match;
	if(!audio_is_playing(snd_bg_music)){
		audio_play_sound(snd_bg_music, 0, true);
		//bg music https://www.youtube.com/watch?v=8SIrVXr9hjA
		audio_sound_gain(snd_bg_music, 1, 1);
	}
		if(keyboard_check_released(vk_space)){
			audio_play_sound(snd_space, 1, false);
			room_goto_next();
		}
}

if(room == rm_main){
	audio_sound_gain(snd_bg_music, 0.5, 1000);	
}

else if(room == rm_game_over){
	global.char_sprite = spr_win;
	audio_sound_gain(snd_bg_music, 1, 1);
		if(keyboard_check_released(vk_space)){
			audio_play_sound(snd_space, 1, false);
			room_goto(rm_start);
		}
}





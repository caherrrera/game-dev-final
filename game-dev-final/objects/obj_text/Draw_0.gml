/// @description Insert description here
// You can write your code in this editor

draw_set_font(fnt_score);
draw_set_color(c_white);
draw_set_halign(fa_center);

if(room == rm_start){
	draw_text(room_width/2, room_height/2-50, string(title_txt));
	draw_text(room_width/2, room_height/2, string(start_txt));
} else if(room == rm_game_over){
	draw_text(room_width/2, room_height/2-50, string(end_text));
	draw_text(room_width/2, room_height/2, string(again_text));
}





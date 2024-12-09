/// @description Insert description here
// You can write your code in this editor

draw_set_halign(fa_center);

if(room == rm_start){
	draw_set_font(fnt_title);
	draw_set_color(c_white);
	draw_text(room_width/2, room_height/2-250, string(title_txt));
	
	draw_set_font(fnt_text);
	draw_set_color(c_gray);
	draw_text(room_width/2, room_height/2-100, string(start_txt));
	
} else if(room == rm_game_over){
	draw_set_font(fnt_title);
	draw_set_color(c_white);
	draw_text(room_width/2, room_height/2-250, string(end_text));
	
	draw_set_font(fnt_text);
	draw_set_color(c_gray);
	draw_text(room_width/2, room_height/2-100, string(again_text));
}





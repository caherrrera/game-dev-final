/// @description Insert description here
// You can write your code in this editor

if(abs(x - target_x) > 1){
	x = lerp(x, target_x, 0.2);
} else {
	x = target_x; 	
}

if(abs(y - target_y) > 1){
	y = lerp(y, target_y, 0.2);
} else {
	y = target_y; 	
}


//draw face
if(face_index == 1) sprite_index = spr_1;
if(face_index == 2) sprite_index = spr_2;
if(face_index == 3) sprite_index = spr_3;
if(face_index == 4) sprite_index = spr_4;
if(face_index == 5) sprite_index = spr_5;
if(face_index == 6) sprite_index = spr_6;
if(face_index == 7) sprite_index = spr_7;
if(face_index == 8) sprite_index = spr_8;

if(face_index == 0) sprite_index = spr_zone;

if(!face_up) sprite_index = spr_card;

draw_sprite(sprite_index, image_index, x,y);




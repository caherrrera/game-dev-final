// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function array_has_item(arr, item){
	for (var i = 0; i < array_length_1d(arr); i++) {
        if (arr[i] == item) return true;
    }
    return false;
}
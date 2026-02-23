shader_type canvas_item;

uniform float skew;

void vertex() {
   	VERTEX.x += (UV.y) * skew;
}

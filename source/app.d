import drawer;
import color;
import coord;
import render;
import model;
import vector;
import texture;

void main() 
{
	Drawer drawer = new Drawer("result.png", 1024, 1024);
	Render render = new Render(&drawer.setPixel, 1024 - 1, 1024 - 1);
	Model model = new Model("african_head.obj");
	Texture texture = DimTexture!3.loader("african_head_diffuse.tga");
	render.setTexture(texture);
	model.draw(render);
//	render.drawTriangle(Color(255,0,0), Coord!(3, double)(0.0, 0.0, 0.0),Coord!(3, double)(1.0, 0.0, 0.0), Coord!(3, double)(0.0, 1.0, 0.0));
	drawer.save();
/*	auto first = new Vector!(double)(Coord!(3, double)(1.0, 0.0, 0.0));
	auto second = new Vector!(double)(Coord!(3, double)(0.5, 0.5, 0.0));
*/

}
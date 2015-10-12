module drawer;

import std.string;
import color;
import coord;

alias Coord3i = Coord!(3, int);

class Drawer
{
public:
	this(immutable string name_, int width_, int height_)
	{
		name = name_;
		width = width_;
		height = height_;
		pixels = new ubyte[width_ * height_ * size_per_element];
		for(int i = 0; i < height; i++)
		{
			for(int j = 0; j < width; j++)
			{
				pixels[(i * width + j) * size_per_element + 3] = 255u;
			}
		}
	}
	void setPixel(in Coord3i coord, in Color color)
	{
		Coord3i tmp = coord;
		tmp.y = height - tmp.y - 1;
		pixels[(tmp.y * width + tmp.x) * size_per_element + 0] = color.r;
		pixels[(tmp.y * width + tmp.x) * size_per_element + 1] = color.g;
		pixels[(tmp.y * width + tmp.x) * size_per_element + 2] = color.b;
	}
	void save()
	{
		import imageformats;
		write_png(name, width, height, pixels);
	}
private:
	immutable string name;
	int width;
	int height;
	ubyte[] pixels;
	const int size_per_element = 4;
}
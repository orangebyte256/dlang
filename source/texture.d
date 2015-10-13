module texture;

import std.string;
import color;
import coord;

alias Coord2d = Coord!(2, double);
alias Coord2i = Coord!(2, int);

interface Texture
{
	Color getColor(in Coord2d coord);
	static ref Texture loader(string name);
}


class DimTexture(size_t N) : Texture
{
public:
	this(long width_, long height_)
	{
		width = width_;
		height = height_;
		pixels = new ubyte[cast(uint)(width * height)];
	}
	this(long width_, long height_, ubyte[] pixels_)
	{
		width = width_;
		height = height_;
		pixels = pixels_;
	}
	static Texture loader(string name)
	{
		import imageformats;
		IFImage im = read_image(name);
		return (new DimTexture!3(im.w, im.h, im.pixels));
	}
	Color getColor(in Coord2d coord)
	{
		Coord2i res = cast(Coord2i)(coord * Coord2d(width, height));
		int offset = cast(int)(((height - 1 - res.y) * width + res.x) * N);
		Color result;
		static if(N == 1)
		{
			result = Color(pixels[offset],pixels[offset],pixels[offset]);
		}
		else if(N == 3)
		{
			result = Color(pixels[offset + 0],pixels[offset + 1],pixels[offset + 2]);
		}
		else if(N == 4)
		{
			result = Color(pixels[offset + 0],pixels[offset + 1],pixels[offset + 2]);
		}
		return result; 
	}
private:
	long width;
	long height;
	ubyte[] pixels;
}
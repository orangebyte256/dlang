module color;

struct Color
{
public:
	ubyte r, g, b;
	this(ubyte r_, ubyte g_, ubyte b_)
	{
		r = r_;
		g = g_;
		b = b_;
	}
}
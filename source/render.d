module render;

import coord;
import color;

import std.math;

alias Coord3i = Coord!(3, int);
alias Coord3d = Coord!(3, double);

class Render
{
public:
	this(void delegate(const Coord3i, const Color) setPixel_, int width_, int height_)
	{
		setPixel = setPixel_;
		width = width_;
		height = height_;
		depth_buffer = new double[width_ * height_];
		foreach(ref val; depth_buffer)
		{
			val = -10000000.0;
		}
	}
	void drawLine(Coord3d first_, Coord3d second_, in Color color)
	{
		auto first = transfer!(int)(first_);
		auto second = transfer!(int)(second_);

		bool swap = false;
		if(std.math.abs(first.x - second.x) < std.math.abs(first.y - second.y))
		{
			swap = true;
			std.algorithm.mutation.swap(first.x, first.y);
			std.algorithm.mutation.swap(second.x, second.y);
		}
		if(first.x > second.x)
		{
			std.algorithm.mutation.swap(first, second);
		}	
		for(int x = first.x; x < second.x; x++)
		{
			double y = cast(double)(x - first.x)/(second.x - first.x);
			y = first.y + y * (second.y - first.y);
			Coord3i *coord = new Coord3i(x, cast(int)(std.math.round(y)), 0);
			if(swap)
			{
				std.algorithm.mutation.swap(coord.x, coord.y);
			}
			setPixel(*coord, color);
		}
	}
	void drawTriangle(in Color color, Coord3d[] vertex_...)
	{
		Coord3d[] vertex;
		foreach(element; vertex_)
		{
			Coord3d tmp = transfer!(double)(element);
			tmp = cast(Coord3d)(cast(Coord3i)(tmp));
			tmp.z = transfer!(double)(element).z;
			vertex ~= tmp;
		}
		auto func = ((Coord3d a, Coord3d b) => (a.y < b.y));
		std.algorithm.sorting.sort!(func, std.algorithm.SwapStrategy.stable)(vertex);
		std.stdio.writeln(vertex);
		Coord3d first, second;
		double first_step = 1.0/cast(double)(vertex[2].y - vertex[0].y);
		double second_first_step = 1.0/cast(double)(vertex[1].y - vertex[0].y);
		double second_second_step = 1.0/cast(double)(vertex[2].y - vertex[1].y);
		for(int y = cast(int)(vertex[0].y); y <= cast(int)(vertex[2].y); y++)
		{
			first = vertex[0] + (vertex[2] - vertex[0]) * (first_step * cast(double)(y - vertex[0].y));
			if(y < vertex[1].y)
			{
				second = vertex[0] + (vertex[1] - vertex[0]) * (second_first_step * cast(double)(y - vertex[0].y));
			}
			else
			{
				second = vertex[1] + (vertex[2] - vertex[1]) * (second_second_step * cast(double)(y - vertex[1].y));
			}
			if(second.x < first.x)
			{
				std.algorithm.swap(second, first);
			}
			for(int x = cast(int)(first.x); x <= cast(int)(second.x); x++)
			{
				double z = first.z * (1 - (cast(double)(x) / (second.x - first.x))) + (cast(double)(x) / (second.x - first.x)) * second.z;
				if(z > depth_buffer[y * width + x])
				{ 
					depth_buffer[y * width + x] = z;
					setPixel(Coord3i(x, y, 0), color);
				}
			}
		}
	}
private:
	void delegate(const Coord3i, const Color) setPixel;
	int width;
	int height;
	double[] depth_buffer;
	Coord!(3, T) transfer(T)(Coord3d val)
	{
		val = val + Coord!(3, double)(1.0f,1.0f,0.0f);
		val = val * Coord!(3, double)(cast(double)(width / 2),cast(double)(height / 2),0);
		return cast(Coord!(3, T))(val);
	}

}
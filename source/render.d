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
//		depth_buffer = new double[width_][height_]
	}
	void drawLine(Coord3d first_, Coord3d second_, in Color color)
	{
		auto first = transfer(first_);
		auto second = transfer(second_);

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
		std.stdio.writeln(vertex_);
		Coord3i[] vertex;
		foreach(element; vertex_)
		{
			vertex ~= transfer(element);
		}
		auto func = ((Coord3i a, Coord3i b) => (a.y < b.y));
		std.algorithm.sorting.sort!(func, std.algorithm.SwapStrategy.stable)(vertex);
		std.stdio.writeln(vertex);
		int first = 0, second = 0;
		double first_step = cast(double)(vertex[2].x - vertex[0].x)/(vertex[2].y - vertex[0].y);
		double second_first_step = cast(double)(vertex[1].x - vertex[0].x)/(vertex[1].y - vertex[0].y);
		double second_second_step = cast(double)(vertex[2].x - vertex[1].x)/cast(double)(vertex[2].y - vertex[1].y);
		for(int y = vertex[0].y; y < vertex[2].y; y++)
		{
			first = cast(int)(vertex[0].x + first_step * cast(double)(y - vertex[0].y));
			if(y < vertex[1].y)
			{
				second = cast(int)(vertex[0].x + second_first_step * cast(double)(y - vertex[0].y));
			}
			else
			{
				second = cast(int)(vertex[1].x + second_second_step * cast(double)(y - vertex[1].y));
			}
			if(second < first)
			{
				std.algorithm.swap(second, first);
			}
			for(int x = first; x <= second; x++)
			{
				setPixel(Coord3i(x, y, 0), color);
			}
		}
	}
private:
	void delegate(const Coord3i, const Color) setPixel;
	int width;
	int height;
//	double[][] depth_buffer;
	Coord3i transfer(Coord3d val)
	{
		std.stdio.writeln(val);
		val = val + Coord!(3, double)(1.0f,1.0f,0.0f);
		std.stdio.writeln(val);
		val = val * Coord!(3, double)(cast(double)(width / 2),cast(double)(height / 2),0);
		std.stdio.writeln(val);
		std.stdio.writeln(cast(Coord3i)(val));
		return cast(Coord3i)(val);
	}

}
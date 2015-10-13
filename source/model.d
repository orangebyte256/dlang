module model;

import coord;
import std.string;
import std.stdio;
import std.typetuple;
import render;
import std.conv;
import color;
import vector;

alias Coord3(T) = Coord!(3, T);

class Model
{
	this(string name)
	{
		auto file = File(name); // Open for reading
	    auto range = file.byLine();
	    foreach (line; range)
	    {
	    	if(line.indexOf(' ') == -1)
	    		continue;
	    	switch(line[0..line.indexOf(' ')])
	    	{
	    		case "v":
	    		case "vt":
	    		case "vn":
	    		{
	    			auto list = split(line[line.indexOf(' ') + 1..$]);
	    			auto arr = to!(const double[3])(list);
	    			auto res = Coord!(3, double)(arr);
	    			if(line[0..line.indexOf(' ')] == "v")
	    			{
	    				vertex_coords ~= res;
	    			}
	    			else if(line[0..line.indexOf(' ')] == "vt")
	    			{
	    				texture_coords ~= res;
	    			}
	    			else
	    			{
	    				normal_coords ~= res;
	    			}
	    		}
	    		break;
	    		case "f":
	    		{
	    			auto arr = split(line[line.indexOf(' ') + 1..$]);
	    			Coord3!int[3] res;
	    			int i = 0;
	    			foreach(elem; arr)
	    			{
	    				for(int j = 0; j < 3; j++)
	    				{
		    				res[j][i] = to!(int)(split(elem,'/')[j]) - 1;
		    			}
		    			i++;
	    			}
					indeces_vertex ~= res[0];
					indeces_texture ~= res[1];
					indeces_normal ~= res[2];
	    		}
	    		break;
	    		default:
	    		{
	    		}
    			break;
	    	}
	    }
	}

	void draw(Render render)
	{
		std.stdio.writeln(vertex_coords[0]);
		std.stdio.writeln(texture_coords[0]);
		std.stdio.writeln(normal_coords[0]);
		for(int i = 0; i < indeces_vertex.length; i++)
		{
			auto v = indeces_vertex[i];
			auto t = indeces_texture[i];
			auto first = new Vector!(double)(vertex_coords[v[0]], vertex_coords[v[1]]);
			auto second = new Vector!(double)(vertex_coords[v[0]], vertex_coords[v[2]]);
			first.norm();
			second.norm();
			auto dot = first * second;
			dot.norm();
			double res = dot.dot(new Vector!(double)(Coord!(3, double)(0,0,1.0)));
			ubyte color = cast(ubyte)(res * 255.0);
			if(res >= 0)
				render.drawTriangle(Color(color, 0, 0), [vertex_coords[v[0]], vertex_coords[v[1]], vertex_coords[v[2]]], 
					[texture_coords[t[0]], texture_coords[t[1]], texture_coords[t[2]]], [vertex_coords[v[0]], vertex_coords[v[1]], vertex_coords[v[2]]]);
		}
	}
private:
	Coord3!double[] vertex_coords;
	Coord3!double[] texture_coords;
	Coord3!double[] normal_coords;
	Coord3!int[] indeces_vertex;
	Coord3!int[] indeces_texture;
	Coord3!int[] indeces_normal;
}
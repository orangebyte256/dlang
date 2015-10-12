module model;

import coord;
import std.string;
import std.stdio;
import render;
import std.conv;
import color;
import vector;

alias Coord3(T) = Coord!(3, T);

class Model
{
	Coord3!double[] vertex;
	Coord3!int[] triangles;
	this(string name)
	{
		auto file = File(name); // Open for reading
	    auto range = file.byLine();
	    // Print first three lines
	    foreach (line; range)
	    {
	    	switch(line[0])
	    	{
	    		case 'v':
	    		{
	    			if(line[1] == ' ')
	    			{
		    			auto arr = split(line[2..$]);
		    			auto arr2 = to!(const double[3])(arr);
			    		vertex ~= Coord3!double(arr2);
			    	}
	    		}
	    		break;
	    		case 'f':
	    		{
	    			if(line[1] == ' ')
	    			{
		    			auto arr = split(line[2..$]);
		    			Coord3!int res;
		    			int i = 0;
		    			foreach(elem; arr)
		    			{
		    				res[i++] = to!(int)(split(elem,'/')[0]) - 1;
		    			}
		    			triangles ~= res;
		    		}
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
		foreach(v; triangles)
		{
			auto first = new Vector!(double)(vertex[v[0]], vertex[v[1]]);
			auto second = new Vector!(double)(vertex[v[0]], vertex[v[2]]);
			first.norm();
			second.norm();
			std.stdio.writeln(first);
			std.stdio.writeln(second);
			auto dot = first * second;
			std.stdio.writeln(dot);
			dot.norm();
			double res = dot.dot(new Vector!(double)(Coord!(3, double)(0,0,1.0)));
			std.stdio.writeln(res);
			ubyte color = cast(ubyte)(res * 255.0);
			if(res >= 0)
				render.drawTriangle(Color(color, color, color), vertex[v[0]], vertex[v[1]], vertex[v[2]]);
		}
	}
}
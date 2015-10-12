module vector;

import coord;

import std.math;
import std.conv;

alias Coord3(T) = Coord!(3, T);

class Vector(T)
{
public:

	this(E) (in Coord!(3,E) first, in Coord!(3,E) second)
	{
		for(int i = 0; i < 3; i++)
		{
			data[i] = cast(T)(second[i] - first[i]);
		}
	}

	this(E) (in Coord!(3,E) val)
	{
		for(int i = 0; i < 3; i++)
		{
			data[i] = cast(T)(val[i]);
		}
	}

	void smth(E) (Coord!(3,E) a)
	{
		std.stdio.writeln(a);
	}


	Vector!(T) opBinary(string op)(Vector!(T) rhs)
	{
		static if(op == "*")
		{
			Coord3!(T) res;
			res[0] = data.y * rhs.data.z - data.z * rhs.data.y;
			res[1] = -data.x * rhs.data.z + data.z * rhs.data.x;
			res[2] = data.x * rhs.data.y - data.y * rhs.data.x;
			data = res;
			return this;
		}
		else
			return Super.opBinary(ip)(rhs);
	}
	Vector!(T) norm()
	{
		double sum = 0;
		for(int i = 0; i < 3; i++)
		{
			sum += data[i] * data[i];
		}
		sum = std.math.sqrt(sum);
		for(int i = 0; i < 3; i++)
		{
			data[i] /= sum;
		}
		return this;
	}
	double dot(Vector!(T) rhs)
	{
		double sum = 0;
		norm();
		rhs.norm();
		for(int i = 0; i < 3; i++)
		{
			sum += data[i] * rhs.data[i];
		}
		return sum;
	}
	override string toString()
	{
		return to!string(data[0]) ~ " " ~ to!string(data[1]) ~ " " ~ to!string(data[2]);
	}
private:
	Coord3!(T) data;
}
module coord;

import std.math;

struct Coord(size_t N, T)
{
public:
	T[N] data;
	alias data this;
	this(in T[N] val...)
	{
		data = val;
	}
    this(size_t V)(in T[V] val) if(V > N)
    {
        int count = 0;
        static if(V > N)
        {   
            for(int i = 0; i < N; i++)
            {
                data[i] = val[i];
            }
        }
    }
    auto opBinary(string op)( in Coord!(N,T) b ) const
    {
        Coord!(N,T) ret;
        foreach( i; 0 .. N )
            mixin( "ret.data[i] = data[i] " ~ op ~ " b.data[i];" );
        return ret;
    }
    auto opBinary(string op)( in T rhs ) const
    {
        Coord!(N,T) ret;
        foreach( i; 0 .. N )
            mixin( "ret.data[i] = data[i] " ~ op ~ " rhs;" );
        return ret;
    }
    ref T x()
    {
    	static if(N > 0)
    	{
    		return data[0];
    	}
    	else static assert(0, "wrong count of elements");
    }
    ref T y()
    {
    	static if(N > 1)
    	{
    		return data[1];
    	}
        else 
        {
            return *(new T);
        }
    }
    ref T z()
    {
    	static if(N > 2)
    	{
    		return data[2];
    	}
    	else 
        {
            return *(new T);
        }
    }
    L opCast(L)() if(is(L == Coord!(N,int)))
    {
        L result;
        for(int i = 0; i < N; i++)
        {
            result[i] = cast(int)(std.math.round(data[i]));
        }
        return result;
    }
    L opCast(L)() if(!is(L == Coord!(N,int)))
    {
        L result;
        for(int i = 0; i < N; i++)
        {
            result[i] = cast(typeof(result[0]))(data[i]);
        }
        return result;
    }
}
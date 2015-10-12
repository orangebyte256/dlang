module coord;

struct Coord(size_t N, T)
{
public:
	T[N] data;
	alias data this;
	this(in T[N] val...)
	{
		data = val;
	}
	auto opBinary(string op)( in Coord!(N,T) b ) const
    {
        Coord!(N,T) ret;
        foreach( i; 0 .. N )
            mixin( "ret.data[i] = data[i] " ~ op ~ " b.data[i];" );
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
    	else static assert(0, "wrong count of elements");
    }
    ref T z()
    {
    	static if(N > 2)
    	{
    		return data[2];
    	}
    	else static assert(0, "wrong count of elements");
    }
    L opCast(L)()
    {
        L result;
        for(int i = 0; i < N; i++)
        {
            result[i] = cast(typeof(result[0]))(data[i]);
        }
        return result;
    }
}
module overload_enum;

mixin template Enum(string s) {
	mixin({
		import std.algorithm, std.array, std.conv, std.string;
		auto ss = s.split("-");
		auto sss = ss[1].split(",").filter!(a => chop(a)).filter!(a => a != "").array;

		string r = "struct " ~ ss[0] ~ "{";
			r ~= q{
				int n; alias n this;
				this(typeof(this) function() f){ this = f(); }
				void opAssign(typeof(this) function() f){ this = f(); }
				bool opEquals(typeof(this) function() f){ return this.n == f().n; }
			};
			r ~= "enum count = " ~ sss.length.to!string ~ ";";
			r ~= "string toString(){";
				r ~= "final switch(n){";
				foreach(i, z; sss) r ~= "case " ~ i.to!string ~ ": return \"" ~ z ~ "\";";
				r ~= "}";
			r ~= "}";
		r ~= "}";
		foreach(i, z; sss) r ~= ss[0] ~ " " ~ z ~ "(){ typeof(return) m; m.n = " ~ i.to!string ~ "; return m; }";
		return r;
	}());
}


/*
import std.stdio;

import overload_enum;

mixin Enum!`Color - red, green, blue`;
mixin Enum!`AlphaColor - red, green, blue, alpha`;


void main(){
	Color c = &green;
	AlphaColor ac = &green;

	if(ac == &green && c != &red && c != &blue){
		writeln("colors green");
	}
	writeln(c.count); // 3
	writeln(ac.count); // 4
	writeln(ac.to!string);
}
*/

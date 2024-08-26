package;

typedef ByteInt = #if cpp cpp.Int8 #else Int #end;
typedef ByteUInt = #if cpp cpp.UInt8 #else Int #end;
typedef ShortInt = #if cpp cpp.Int16 #else Int #end;
typedef ShortUInt = #if cpp cpp.UInt16 #else Int #end;
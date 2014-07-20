local ffi=require("ffi")

return ffi.cdef[[
int *__errno_location (void);
char *strerror(int errnum);
]]

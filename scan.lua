local ffi=require"ffi"

require"ptrace_cdef"
require"error_cdef"
local S=require"syscall"

local errnol = ffi.C.__errno_location()

pid=ffi.cast('pid_t',tonumber(arg[1]))

regs=regs_struct()

local function e()
  print(ffi.string(ffi.C.strerror(errnol[0])))
end

ret = ffi.C.ptrace (ffi.C.PTRACE_ATTACH, pid, nil, nil);

ffi.C.wait(nil)


running=true
while running do
  ffi.C.ptrace(ffi.C.PTRACE_GETREGS, pid, nil, regs);
  if regs.rip == 0x40063e then
    for k,v in pairs(regs) do
      print(k,v)
    end
    word = ffi.C.ptrace (ffi.C.PTRACE_PEEKDATA, pid, regs.rip+0x200a12, nil);
    print(regs.rip+0x200a12,word)
    ffi.C.ptrace (ffi.C.PTRACE_POKEDATA, pid, regs.rip+0x200a12, word+1);
    running=false
  end
  ffi.C.ptrace (ffi.C.PTRACE_SINGLESTEP, pid, nil, nil);
  ffi.C.wait(nil)
end

word=ffi.C.ptrace (ffi.C.PTRACE_PEEKDATA, pid, 0x601050ULL, nil);
print(0x601050ULL,word)
ffi.C.ptrace (ffi.C.PTRACE_POKEDATA, pid, 0x601050ULL, word+1);

ret = ffi.C.ptrace (ffi.C.PTRACE_DETACH, pid, nil, nil);
e()

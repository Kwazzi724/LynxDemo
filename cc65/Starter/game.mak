#http://msdn.microsoft.com/en-us/library/dd9y37ha(v=VS.80).aspx

!INCLUDE <lynxcc65.mak>

target = game.lnx
objects = lynx-160-102-16.o lynx-stdjoy.o \
					game.o

all: $(target)

$(target) : $(objects)
	$(CL) -t $(SYS) -o $@ $(objects) lynx.lib 
	
clean:

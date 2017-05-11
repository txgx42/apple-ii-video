AFLAGS  =
PLFLAGS  = -C player.cfg
LLFLAGS  = -C loader.cfg
PBINFILE = player.bin
LBINFILE = loader.bin
POBJS    = player.o
LOBJS	 = loader.o

$(PBINFILE): $(POBJS)
	ld65 $(PLFLAGS) $(POBJS) -o $(PBINFILE)

$(LBINFILE): $(LOBJS)
	ld65 $(LLFLAGS) $(LOBJS) -o $(LBINFILE)

player.o: player.s
	ca65 -W9 $(AFLAGS) $<

loader.o: loader.s
	ca65 -W9 $(AFLAGS) $<

clean:	
	rm player.bin	player.o
	rm loader.bin	loader.o


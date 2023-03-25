.PHONY : all default linux macosx clean skynet_clean

all : default

default: linux

linux :
	cd skynet && make linux

macosx :
	cd skynet && make macosx

clean : skynet_clean

skynet_clean :
	cd skynet && make clean

.PHONY : all skynet clean skynet_clean

all : skynet

skynet :
	cd skynet && make linux

clean : skynet_clean

skynet_clean :
	cd skynet && make clean

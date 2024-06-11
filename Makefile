#
# Makefile
#
.PHONY: all

all: hp4

hp4:
	rsync -avzd ./hp4/ hp4:~/rpmScripts/hp4/

#scp -C ./hp4/* hp4:~/rpmScripts/hp4/

#end
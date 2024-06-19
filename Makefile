#
# Makefile
#
.PHONY: all

all: hp4 hp3

hp3:
	rsync -avzd ./ hp3:~/rpmScripts/

hp4:
	rsync -avzd ./ hp4:~/rpmScripts/

#scp -C ./hp4/* hp4:~/rpmScripts/hp4/

#end

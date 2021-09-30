
ifeq ($(USER),root)
    $(info )
    $(info "$0 can't run by $(USER). exit." )
    $(info )
    $(error exit )
endif

dateX1:=$(shell LC_ALL=C date +%Y_%m%d_%H%M%P_%S )

c01:=$(wildcard src0?/*.c src0?/*.cpp )
c02:=$(foreach aa1,$(c01), ../$(aa1))
c09:=$(c01)

h01:=$(wildcard h0?/*.h h0?/*.hpp )
h02:=$(foreach aa1,$(h01), ../$(aa1))
h09:=$(h01)

$(if $(c09),,$(error "c09 don't exit. check <projName> and run again. Exit."))


all:
#	@echo
	@echo "$${helpText}" 
#	@echo


ca: 
	cd $(dstDir02) && rm -f ` \
		find -type f \
		-name "*.o" \
		-o -name "*.d" \
		-o -name "*.d_raw" \
		-o -name "*.obj" \
		-o -name "*.map" \
		-o -name "*~" \
		-o -name "BlinkLED*.out" \
		`

m:
	vim Makefile ; echo

vp : vim_prepare
vim_prepare :
	mkdir -p _vim/
	echo Makefile            > _vim/file01.txt
	echo $(c01) |xargs -n 1 >> _vim/file01.txt
	echo $(h01) |xargs -n 1 >> _vim/file01.txt
	#echo /home/ti/ti/ccs1040/ccs/ccs_base/msp430/include_gcc/msp430fr2433.h \
	#	>>                                                 _vim/file01.txt
	cscope -q -R -b -i                                     _vim/file01.txt
	ctags -L                                               _vim/file01.txt


gs:=git status
gc:=git commit -a
gd:=git diff
up:=git push -u origin main

gitgit:= gs gc gd up
define gitctr
$1 :
	$$($$@)
endef
$(foreach ee1,$(gitgit),$(eval $(call gitctr,$(ee1))))



#v1:=$(dstDir01)/main.c
#v2:=$(dstDir01)/_cable_tester_mainloop_once.c
#v1 v2: 
#	vim $($@)

c2idx:=1
c2vP1:=
c2vP2:=
c2vP3:=
define c2v
c2now:=v$(c2idx)
c2vP1 += $1
c2vP2 += $(c2idx)
c2vP3 += $(c2now)
$$(c2now):=$1
$$(c2now): $1

c2idx:=$(shell expr $(c2idx) + 1 )

endef

$(foreach bb1,$(c09),$(eval $(call c2v,$(bb1))))

#	vim $($@)
$(c2vP3) : 
	vim $<





define helpText2
	c09 -> $(c09)
	h09 -> $(h09)
	c2vP1 -> $(c2vP1)
	c2vP2 -> $(c2vP2)
	c2vP3 -> $(c2vP3)
	v1 -> $(v1)
	v2 -> $(v2)
endef

define helpText
 $(foreach ee1,$(gitgit),$(ee1) -> $($(ee1))
)
 $(foreach ee1,$(c2vP3),$(ee1) -> vim $($(ee1))
)
endef
export helpText

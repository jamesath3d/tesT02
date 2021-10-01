
ifeq ($(USER),root)
    $(info )
    $(info "$0 can't run by $(USER). exit." )
    $(info )
    $(error exit )
endif

all:
	@echo "$${helpText}" 


include Makefile.env

dateX1:=$(shell LC_ALL=C date +%Y_%m%d_%H%M%P_%S )

ca: clean_all

m:
	vim Makefile ; echo

vp : vim_prepare
Makefile:=$(shell test -L Makefile && realpath --relative-to=. Makefile || echo Makefile)
vim_prepare :
	mkdir -p _vim/
	echo $(Makefile)                            > _vim/file01.txt
	echo Makefile.env                          >> _vim/file01.txt
	echo $(vim_tags_objS) |xargs -n 1          >> _vim/file01.txt
	cscope -q -R -b -i                            _vim/file01.txt
	ctags -L                                      _vim/file01.txt

clean_all:
	$(if $(projName),cd $(projName)/ &&) \
		rm -f ` \
		find -type f \
		-name "*.o" \
		-o -name "*.d" \
		-o -name "*.d_raw" \
		-o -name "*.obj" \
		-o -name "*.map" \
		-o -name "*~" \
		-o -name "BlinkLED*.out" \
		`


c2idx:=1
c2vP1:=
c2vP2:=
c2vP3:=
define c2v
$(eval c2now:=v$(c2idx))
c2vP1 += $1
c2vP2 += $(c2idx)
c2vP3 += $(c2now)
$$(c2now):=$1
$$(c2now): $1

c2idx:=$(shell expr $(c2idx) + 1 )

endef

$(foreach bb1,$(vim_edit_objS),$(eval $(call c2v,$(bb1))))

#	vim $($@)
$(c2vP3) : 
	vim $<



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




d2u:=dos2unix
d2u:$(d2u)
dos2unix:
	dos2unix $(vim_tags_objS)

msp430idx:=1
msp430vP1:=
msp430vP2:=
msp430vP3:=
define msp430build
$(eval msp430now:=b4$(msp430idx))
msp430vP1 += $1
msp430vP2 += $(msp430idx)
msp430vP3 += $(msp430now)
$$(msp430now):=$(projName)/$1/
$$(msp430now): $(projName)/$1/
	cd $$($$@) && make clean

msp430idx:=$(shell expr $(msp430idx) + 1 )

endef
$(foreach ee1,$(msp430DebugNameS),$(eval $(call msp430build,$(ee1))))


define helpText
 $(foreach ee1,$(c2vP3),$(ee1) -> vim $($(ee1))
) 
 $(foreach ee1,$(msp430vP3),$(ee1) -> vim $($(ee1))
) 
 $(foreach ee1,$(gitgit) d2u,$(ee1) -> $($(ee1))
)$(helpText2)
msp430vP1 -> $(msp430vP1)
msp430vP2 -> $(msp430vP2)
msp430vP3 -> $(msp430vP3)
endef
export helpText


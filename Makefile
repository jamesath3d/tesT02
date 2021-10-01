
ifeq ($(USER),root)
    $(info )
    $(info "$0 can't run by $(USER). exit." )
    $(info )
    $(error exit )
endif
define EOL


endef
makefile_path:=$(shell realpath Makefile)

all:
	@echo "$${helpText}" 


ifndef  Makefile_env
include Makefile.env
Makefile_env:=1
endif

#projName:= 
projName:=$(strip $(projName))
$(if $(projName),,$(eval projName=.))

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
		-o -name "*_linkInfo.xml" \
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
$(d2u):
	$(d2u) $(vim_tags_objS)

msp430idx:=1
msp430vP1:=
msp430vP2:=
msp430vP3:=
b4a:=
b4c:=
b4m:=
define msp430build
$$(eval msp430now:=b4$$(msp430idx))
$$(eval $$(msp430now):=$(projName)/$1/)
msp430vP1 += $1
msp430vP2 += $$(msp430idx)
msp430vP3 += $$(msp430now)


$$(msp430now)m: $$($$(msp430now))
	make -C $$<

$$(msp430now)c: $$($$(msp430now))
	make -C $$< clean

b4a += $$(msp430now)
b4c += $$(msp430now)c
b4m += $$(msp430now)m
$$(msp430now): $$(msp430now)c $$(msp430now)m 

$$(eval msp430idx:=$$(shell expr $$(msp430idx) + 1 ))

endef
$(foreach ee1,$(msp430DebugNameS),$(eval $(call msp430build,$(ee1))))

b4a:$(b4a)
b4c:$(b4c)
b4m:$(b4m)

#cmd_exeS:=pwd;sed -i -e 's;^SHELL\s*=.*$$;^&;g' makefile *.mk
#Makefile_env:=1
cmdc:=makefile_change_from_win_to_linux
$(cmdc):
	sed -i \
		-e 's;^SHELL = cmd.exe;SHELL = /usr/bin/sh;g' \
		-e 's;C:/ti/ccs1040;/home/ti/ti/ccs1040;g' \
		-e 's;C:/devJames/workspace_v10;/home/$(USER)/workspace_v10;g' \
		-e 's;_win64\b;_linux64;g' \
		-e 's;gcc-9.3.1.exe;gcc-9.3.1;g' \
		-e 's;^RM := DEL /F;RM := rm -fr;g' \
		-e 's;^RMDIR := RMDIR /S/Q;RMDIR := rm -rf;g' \
		`find -name makefile -o -name "*.mk" -o -name "*.d"`

cmdc:
	$(foreach ee1,$(msp430vP3),@Makefile_env=1 make -C $($(ee1)) -f $(makefile_path) $(cmdc) ; echo $(EOL))

lls:=ls -l `find $(projName)/ -name "*.out" -o -name "*.hex" -o -name "*.txt" 2>/dev/null `
lls:
	$($@)

define helpDebug2
msp430vP1 -> $(msp430vP1)
msp430vP2 -> $(msp430vP2)
msp430vP3 -> $(msp430vP3)
makefile_path -> $(makefile_path)
b41 -> $(b41)
b42 -> $(b42)
b43 -> $(b43)
b4c -> $(b4c)
b4m -> $(b4m)
endef

define helpDebug
 lls -> $(lls)
endef

define helpText
 $(foreach ee1,$(c2vP3),$(ee1) -> vim $($(ee1))
) 
 $(foreach ee1,$(msp430vP3),$(ee1) -> build in $($(ee1))
) 
 $(foreach ee1,cmdc $(gitgit) d2u b4a b4c b4m,$(ee1) -> $($(ee1))
)$(helpText2)$(helpDebug)
endef
export helpText


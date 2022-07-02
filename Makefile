
ifeq ($(USER),root)
    $(info )
    $(info "$0 can't run by $(USER). exit." )
    $(info )
    $(error exit )
endif
define EOL


endef
define callFUNC
$1 :
	@echo
	$($1)
endef

PWD         := $(shell pwd)
KVERSION    := $(shell uname -r)
KERNEL_DIR  ?= /lib/modules/$(KVERSION)/build


makefile_real:=$(shell realpath Makefile)
makefile_dir:=$(shell dirname $(makefile_real))

uname_p:=$(shell uname -p)
ifeq ($(uname_p),x86_64)
msp430gcc93X:=/home/m430/x64/local/bin/msp430-elf-gcc
msp430objcopy:=/home/m430/x64/local/bin/msp430-elf-objcopy
msp430objdump:=/home/m430/x64/local/bin/msp430-elf-objdump
disable_hex430:=
else
msp430gcc93X:=/home/m430/a64/local/bin/msp430-elf-gcc
msp430objcopy:=/home/m430/a64/local/bin/msp430-elf-objcopy
msp430objdump:=/home/m430/a64/local/bin/msp430-elf-objdump
disable_hex430:=\#echo disable
endif
export uname_p
export msp430gcc93X
export msp430objcopy
export msp430objdump
export disable_hex430
msp430srec:=/usr/bin/srec_cat
export msp430srec


all: # ex03/i2cget_v4.2.c ex03/i2cbusses_v4.2.c ex03/smbus_v4.2.c 
	@echo "$${helpText}" 

e8:
	@echo; echo; echo; echo; echo; echo; echo; echo; 
e16: e8
	@echo; echo; echo; echo; echo; echo; echo; echo; 

ex03/i2cget_v4.2.c : i2c-tools/tools/i2cget.c
	cat $^ > $@
ex03/i2cbusses_v4.2.c : i2c-tools/tools/i2cbusses.c
	cat $^ > $@
ex03/smbus_v4.2.c : i2c-tools/lib/smbus.c
	cat $^ > $@

vv:
	@echo "$${vimTextV1}"

vvv:
	@echo "$${vimText}"


ifndef  Makefile_env
include Makefile.env
Makefile_env:=1

projName:=$(strip $(firstword $(projName)))
projFullName:=$(strip $(projFullName))
projFullName:=$(if $(projFullName),$(projFullName),$(projName))

projNeeds:=projName msp430DebugNameS testOBJs
projNeeds:=projName testOBJs
projNeeds:=projName
$(foreach aa1,$(projNeeds),$(if $($(aa1)),,$(info undefined VAR "$(aa1)" in Makefile.env, exit)$(error 838111831)))

c01:=$(foreach aa1,$(wildcard                 src0?/ $(projName)/ ) ,$(shell find $(aa1) -name "*.c" -o -name "*.ino" -o -name "*.cpp" ))
h01:=$(foreach aa1,$(wildcard  xl_tt?/ xh_tt?/  h0?/ $(projName)/ ) ,$(shell find $(aa1) -name "*.h"))
o01:=$(foreach aa1,$(wildcard                   o0?/ $(projName)/ ) ,$(shell find $(aa1) -name makefile -o -name Makefile -o -name "*.mk"))

ex01:=$(foreach aa1,$(wildcard                 ex0?/              ) ,$(shell find $(aa1) -name "*.c" -o -name "Makefile*"))

c09:=$(c01)
h09:=$(h01)
o09:=$(o01)
ex09:=$(ex01) $(wildcard ./Makefile ./Makefile.env)

$(if $(c09),,$(error "c09 don't exit. check <projName> and run again. Exit. 83491981831 "))

vim_tags_objS:=$(sort $(shell  echo . $(ex09) $(c09) $(h09) $(o09)|xargs -n 1 realpath --relative-to=.|sort -u))
vim_edit_objS1:=$(sort $(shell echo . $(ex09) $(c09)              |xargs -n 1 realpath --relative-to=.|sort -u))
export vim_edit_objS1
vim_edit_objS:=$(shell \
	echo "${vim_edit_objS1}" |xargs -n 1 |grep    /main.c$$ ; \
	echo "${vim_edit_objS1}" |xargs -n 1 |grep -v /main.c$$ \
	)

endif

projName:=$(strip $(projName))
$(if $(projName),,$(eval projName=.))
testOBJs:=$(strip $(testOBJs))

dateX1:=$(shell LC_ALL=C date +%Y_%m%d_%H%M%P_%S )

ca: clean_all

m:
	vim Makefile ; echo
v:
	vim Makefile.msp430v001 ; echo

vp : vim_prepare
Makefile:=$(shell test -L Makefile && realpath --relative-to=. Makefile || echo Makefile)
vim_prepare :
	rm -f tags \
		cscope.in.out \
		cscope.out \
		cscope.po.out 
	mkdir -p _vim/
	echo $(Makefile)                            > _vim/file01.txt
	echo Makefile.env                          >> _vim/file01.txt
	echo $(vim_tags_objS) |sort |xargs -n 1    >> _vim/file01.txt
	sed -i -e '/^\.$$/d' -e '/^$$/d'              _vim/file01.txt
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
		-o -name "BlinkLED*.out.elf" \
		-o -name "BlinkLED*.out.strip" \
		-o -name "BlinkLED*.txt" \
		-o -name "BlinkLED*.ss.elf" \
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

$(foreach bb1,$(filter-out .,$(vim_edit_objS)),$(eval $(call c2v,$(bb1))))

#	vim $($@)
$(c2vP3) : 
	make vp
	vim $<



X:=make ga gcX up
ga:=git add .
gs:=git status
gc:=git commit -a
gcX:=git commit -a -m "$(dateX1)"
gd:=git diff
up:=git push -u origin main
gas:=cd $(projName)/     && $(ga)
gam:=cd $(makefile_dir)/ && $(ga)
gss:=cd $(projName)/     && $(gs)
gsm:=cd $(makefile_dir)/ && $(gs)
gcs:=cd $(projName)/     && $(gc)
gcm:=cd $(makefile_dir)/ && $(gc)
ups:=cd $(projName)/     && $(up)
upm:=cd $(makefile_dir)/ && $(up)
gds:=cd $(projName)/     && $(gd)
gdm:=cd $(makefile_dir)/ && $(gd)
Xs:=cd $(projName)/      && $(X)
Xm:=cd $(makefile_dir)/  && $(X)

gitgit:= gds gdm ups upm gcs gcm gss gsm gas gam ga gs gc gd up gcX X Xs Xm
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
	make -C $$< | tee log.$$@.txt

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
		-e 's;msp430-elf-objcopy.exe;msp430-elf-objcopy;g' \
		-e 's;^RM := DEL /F;RM := rm -fr;g' \
		-e 's;^RMDIR := RMDIR /S/Q;RMDIR := rm -rf;g' \
		`find -name makefile -o -name "*.mk" -o -name "*.d"`

cmdc:
	$(foreach ee1,$(msp430vP3),@Makefile_env=1 make -C $($(ee1)) -f $(makefile_real) $(cmdc) ; echo $(EOL))

objFiles:=\
	$(foreach aa1,$(projName) $(testOBJs), \
	`find $(aa1)/ -name "*.out.elf" -o -name "*.ss.elf" -o -name "*.ti.txt" 2>/dev/null ` \
	)
txtFiles:=\
	$(foreach aa1,$(projName) $(testOBJs), \
	`find $(aa1)/                                   -name "*.ti.txt" 2>/dev/null ` \
	)
asmFiles:=\
	$(foreach aa1,$(projName) $(testOBJs), \
	`find $(aa1)/                                   -name "*.ss.elf.asm" 2>/dev/null ` \
	)

lls:= ls -l $(objFiles)
llt:= ls -l $(txtFiles)
lla:= ls -l $(asmFiles)

lls llt lla :
	$($@)

txtCMD1:="/home/ti/ti/ccs1040/ccs/tools/compiler/ti-cgt-msp430_20.2.5.LTS/bin/hex430"
txtCMD2:=--memwidth=8 --romwidth=8 --diag_wrap=off --ti_txt -o
txtCMD9:=$(txtCMD1) $(txtCMD2)
txtFOR:=\
	for aa1 in \
	`find $(projName)/ -name "*.out.elf" 2>/dev/null ` \
	$(if $(testOBJs),$(foreach aa1,$(testOBJs), \
	`find $(aa1)/      -name "*.out.elf" 2>/dev/null ` \
	)) ; do 
txt:=\
	$(txtFOR) \
	bb1=$${aa1%.*}.ti.txt ; \
	rm -f $${bb1} ; \
	done ; \
	$(txtFOR) \
	bb1=$${aa1%.*}.ti.txt ; \
	$(txtCMD9) $${bb1} $${aa1} ; \
	done ; \
	$(txtFOR) \
	bb1=$${aa1%.*}.ti.txt ; \
	ls -l $${aa1} ; \
	ls -l $${bb1} ; \
	done

txt:
	$($@)

ss:=\
	for aa1 in `find $(projName)/ -name "*.out.elf"` ; do \
	cp $${aa1} $${aa1}.strip ; \
	/home/ti/ti/ccs1040/ccs/tools/compiler/msp430-gcc-9.3.1.11_linux64/bin/msp430-elf-strip \
	$${aa1}.strip ; \
	ls -l $${aa1}* $${aa1%.out.elf}.map ; \
	done

strip:ss
ss:
	$($@)


testOBJidx:=1
testOBJvP1:=
testOBJvP2:=
testOBJvP3:=
testOBJvP4:=
t5a:=
v5a:=
define testOBJfunc
$$(eval testOBJnow:=k5$$(testOBJidx))
$$(eval testOBJvim:=e5$$(testOBJidx))
$$(eval testOBJlog:=l5$$(testOBJidx))
$$(eval testOBJmake:=$$(shell realpath Makefile.$1))
$$(eval $$(testOBJnow):=make -C $1/ -f $$(testOBJmake) $1)
$$(eval $$(testOBJvim):=vim $$(testOBJmake))
$$(eval $$(testOBJlog):=vim log.$$(testOBJnow).txt)
testOBJvP1 += $1
testOBJvP2 += $$(testOBJidx)
testOBJvP3 += $$(testOBJnow)
testOBJvP4 += $$(testOBJvim)
v5a += $$(testOBJvim)
t5a += $$(testOBJnow)

$$(testOBJnow) :
	rm -fr ./$1/ ; mkdir ./$1/
	#$$($$@) | tee log.$$@.txt
	$$($$@) > log.$$@.txt 2>&1 || ( \
		echo ; echo ==error found ===; \
		cat log.$$@.txt \
		|sed -n  -e '/error/I,+20 p' |head -n 20 ; \
		echo ; \
		cat log.$$@.txt \
		|grep '\bgcc\b' ; \
		echo ; \
		echo "see log.$$@.txt for details <<<< === error" ; \
		echo ; exit 33 )
	cat log.$$@.txt |grep gcc |grep Wall ; \
		echo ; echo " build $$@ -> $$($$@) ok " ; echo 
	msp430-objdump -D $1/$1.ss.elf > $1/$1.ss.elf.asm ### --disassemble-all ###
	@echo
$$(testOBJvim) $$(testOBJlog) :
	$$($$@) 
	@echo

#$$(testOBJvim)_txt:= \#\# $$($1_txt)
#$$(testOBJvim)_txt:= kkkkz $1_txt) : $$(testOBJvim)_txt
$$(testOBJvim)_thelp:= \# $$(shell test -f Makefile.$1 \
	&& (( grep ^tHelp:= Makefile.$1 \
	|| echo " error 18381818181 !  \n file Makefile.$1  forgot define ^tHelp:=.  " \
	)|head -n 1 |sed -e 's;^tHelp:=;;g') \
	|| echo "file Makefile.$1 don't exist. error 18381818183 !") \#
$$(testOBJvim)_txt:=$$($$(testOBJvim)_thelp) 
$$(testOBJnow)_txt:=$$($$(testOBJvim)_thelp) 


$$(eval testOBJidx:=$$(shell expr $$(testOBJidx) + 1 ))

endef 
# end of : define testOBJfunc
$(foreach aa1,$(testOBJs),$(eval $(call testOBJfunc,$(aa1))))

ttt:=$(t5a)
ttt: $(ttt)

mspFlash_path:=/home/dyn/ti/MSPFlasher/
mspFlash_txt:=input.ti.txt
mspFlash_cmd=LD_PRELOAD=$(mspFlash_path)/libmsp430.so $(mspFlash_path)/MSP430Flasher -w input.ti.txt -v -g -z [VCC]
mspFlash_cmd:=LD_PRELOAD=$(mspFlash_path)/libmsp430.so $(mspFlash_path)/MSP430Flasher -w $${aa1} -v -g -z [VCC]
mspFlash_erase:=LD_PRELOAD=$(mspFlash_path)/libmsp430.so $(mspFlash_path)/MSP430Flasher -v -e ERASE_ALL

erase:
	$(mspFlash_erase)

burnIdx:=0
burnCMDs:=
define burnFunc
$(eval burnIdx:=$$(shell expr $$(burnIdx) + 1 ))
$(eval burnNow:=burn$$(burnIdx))
$(eval $(burnNow):=$$(mspFlash_cmd))
$(burnNow):
	LD_PRELOAD=$(mspFlash_path)/libmsp430.so $(mspFlash_path)/MSP430Flasher -w $1 -v -g -z [VCC]
export $(burnNow)
burnCMDs += $(burnNow)

$$(iinfo burn -- '$1' "$(burnIdx)" "$(burnNow)" "$($(burnNow))" )

endef

$(foreach aa1,$(shell echo $(txtFiles)|xargs -n 1),$(eval $(call burnFunc,$(aa1))))

define burnHelpText

if ' ERROR: The Debug Interface to the device has been secured ' , add ' -e ERASE_USER_CODE ' 

you can use the following command : begin

    $(foreach aa1,$(burnCMDs), $(aa1) -> $($(aa1)) $(EOL)    )

you can use the following command : end
endef
export burnHelpText

burn := list burn files command
burn :
	@echo "$${burnHelpText}"



define helpDebug3
testOBJvP1 -> $(testOBJvP1)
testOBJvP2 -> $(testOBJvP2)
testOBJvP3 -> $(testOBJvP3)
testOBJvP4 -> $(testOBJvP4)
t51 -> $(t51)
v51 -> $(v51)
endef

define helpDebug2
msp430vP1 -> $(msp430vP1)
msp430vP2 -> $(msp430vP2)
msp430vP3 -> $(msp430vP3)
makefile_real -> $(makefile_real)
b41 -> $(b41)
b42 -> $(b42)
b43 -> $(b43)
b4c -> $(b4c)
b4m -> $(b4m)
endef

define helpDebug
 lls -> $(lls)
 burn -> $(burn)
endef

#helpDebug +=$(EOL)$(helpDebug3)

define vimText
 $(foreach ee1,$(c2vP3),$(ee1) -> vim $($(ee1))
) 
endef
export vimText

define vimTextV1
 $(foreach ee1,$(c2vP3),$(if 
 $(shell test "`dirname $($(ee1))`" = $(projName) && echo 11 )
 ,$(ee1) -> vim $($(ee1)) $(EOL))) 
endef
export vimTextV1

define helpText
$(vimText)
 $(foreach ee1,cmdc $(gitgit) d2u b4a b4c b4m $(v5a) $(t5a),$(ee1) -> $($(ee1)) $($(ee1)_txt) 
) ttt -> $(ttt)
 ss  -> strip
 vv  -> list all vim files
$(helpText2)$(helpDebug)
## ## ##     $(projFullName)     ## ## ## 

endef
export helpText


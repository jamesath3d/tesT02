
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







define helpText
 $(foreach ee1,$(gitgit),$(ee1) -> $($(ee1))
)
$(helpText2)
endef
export helpText


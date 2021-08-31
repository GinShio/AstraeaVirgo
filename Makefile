THRIFT_COMPILE=thrift
THRIFT_SOURCE_DIR=thrift

THRIFT_FILES=$(foreach d,$(shell find $(THRIFT_SOURCE_DIR) -maxdepth 3 -type d),$(wildcard $(d)/*.thrift))

define get_path
	$(eval path := $(subst thrift,$(2),$(dir $(1))))	\
	$(eval $(shell mkdir -p $(path)))	\
	$(path)
endef

.PHONY: all cpp erl clean

all: cpp erl

cpp: LANGUAGE=cpp
cpp: gen_cpp

erl: LANGUAGE=erl
erl: gen_erl

gen_%:
	$(foreach f,$(THRIFT_FILES),	\
		$(shell $(THRIFT_COMPILE)	\
			-r -I base -I thrift	\
			--out $(call get_path,$(f),$(LANGUAGE))	\
			--gen $(LANGUAGE)	\
			$(f)))

clean:
	-@rm -rf cpp
	-@rm -rf erl

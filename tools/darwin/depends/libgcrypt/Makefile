include ../Makefile.include

# lib name, version
LIBNAME=libgcrypt
VERSION=1.6.4
SOURCE=$(LIBNAME)-$(VERSION)
ARCHIVE=$(SOURCE).tar.bz2

# configuration settings
export PATH:=$(TOOLCHAIN)/bin:$(PATH) 
CONFIGURE=./configure --prefix=$(PREFIX)

ifeq ($(DARWIN),osx)
CONFIGURE+=--disable-asm --disable-avx-support --disable-avx2-support
endif

LIBDYLIB=$(SOURCE)/.libs/libgcrypt.dylib

CLEAN_FILES=$(ARCHIVE) $(SOURCE)

all: $(LIBDYLIB) .installed

$(TARBALLS_LOCATION)/$(ARCHIVE):
	$(RETRIEVE_TOOL) $(RETRIEVE_TOOL_FLAGS) $(BASE_URL)/$(ARCHIVE)

$(SOURCE): $(TARBALLS_LOCATION)/$(ARCHIVE)
	rm -rf $(SOURCE)
	$(ARCHIVE_TOOL) $(ARCHIVE_TOOL_FLAGS) $(TARBALLS_LOCATION)/$(ARCHIVE)
	echo $(SOURCE) > .gitignore
	#cd $(SOURCE); patch -p1 < ../01-asm-Allow-building-x86-and-amd64-using-old-compilers.patch
	#cd $(SOURCE); patch -p0 < ../02-armasm.patch
	cd $(SOURCE); patch -p0 < ../03-gcrypt-android-select.patch
	#cd $(SOURCE); patch -p0 < ../04-oflagmunging.patch
	cd $(SOURCE); $(CONFIGURE)

$(LIBDYLIB): $(SOURCE)
	make -j $(MAKE_JOBS) -C $(SOURCE)

.installed:
	make -C $(SOURCE) install
	touch $@

clean:
	make -C $(SOURCE) clean
	rm -f .installed

distclean::
	rm -rf $(SOURCE) .installed


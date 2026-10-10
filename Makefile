ifndef OO_PS4_TOOLCHAIN
$(error OO_PS4_TOOLCHAIN is not set. Please set it to your OpenOrbis PS4 Toolchain directory)
endif

# Naziv tvog konačnog projekta
TARGET := URLInstaller

# Postavke kompajlera za C++ i Linkera
CXX     := clang++
OBJCOPY := objcopy
ODIR    := build

# PS4 Specifične zastavice za C++ (FreeBSD target)
CXXFLAGS := -target x86_64-pc-freebsd12-elf -fno-stack-protector -fPIC -O2 -Wall -std=c++17
LDFLAGS  := -target x86_64-pc-freebsd12-elf -nostdlib -Wl,--art-extension -Wl,--eh-frame-hdr

# Glavni ciljevi za build
all: $(TARGET).pkg

# Kompajliranje main.cpp u objektni fajl unutar build foldera
$(ODIR)/main.o: main.cpp
	@mkdir -p $(ODIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Povezivanje u ELF fajl
$(TARGET).elf: $(ODIR)/main.o
	$(CXX) $(ODIR)/main.o -o $@ $(LDFLAGS)

# Pakovanje u PS4 PKG koristeći tvoj config.gp4
$(TARGET).pkg: $(TARGET).elf
	@mkdir -p sce_sys
	# 1. Kreiranje eboot.bin datoteke iz ELF-a
	$(OBJCOPY) --input-target=elf64-x86-64 --output-target=elf64-x86-64 --binary-architecture=i386:x86-64 $(TARGET).elf sce_sys/eboot.bin
	# 2. OpenOrbis pakovanje preko tvog gp4 projekta
	orbis-pub-cmd img_create config.gp4 $(TARGET).pkg
	@echo "--- PKG Uspješno izgrađen! ---"

clean:
	rm -rf $(ODIR) $(TARGET).elf $(TARGET).pkg sce_sys/eboot.bin

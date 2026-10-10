ifndef OO_PS4_TOOLCHAIN
$(error OO_PS4_TOOLCHAIN is not set. Please set it to your OpenOrbis PS4 Toolchain directory)
endif

# Naziv tvoje aplikacije
TARGET := URLInstaller

CXX    := clang++
OBJCOPY:= objcopy
ODIR   := build

# Standardne FreeBSD/PS4 postavke kompajlera
CXXFLAGS := -target x86_64-pc-freebsd12-elf -fno-stack-protector -fPIC -O2 -Wall -std=c++17
LDFLAGS  := -target x86_64-pc-freebsd12-elf -nostdlib -Wl,--art-extension -Wl,--eh-frame-hdr

all: $(TARGET).bin

$(ODIR)/main.o: main.cpp
	@mkdir -p $(ODIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(TARGET).elf: $(ODIR)/main.o
	$(CXX) $(ODIR)/main.o -o $@ $(LDFLAGS)

# Pretvaranje u čisti .bin fajl koji PS4 payload loaders mogu učitati
$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $(TARGET).elf $(TARGET).bin
	@echo "--- PS4 BIN Uspjesno izgradjen! ---"

clean:
	rm -rf $(ODIR) $(TARGET).elf $(TARGET).bin

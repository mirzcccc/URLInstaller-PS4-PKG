TARGET := URLInstaller
CXX    := clang++
OBJCOPY:= objcopy
ODIR   := build

# Direktne FreeBSD/PS4 arhitekturne zastavice bez eksternog SDK-a
CXXFLAGS := -target x86_64-pc-freebsd12-elf -fno-stack-protector -fPIC -O2 -Wall -std=c++17
LDFLAGS  := -target x86_64-pc-freebsd12-elf -nostdlib -Wl,--art-extension -Wl,--eh-frame-hdr

all: $(TARGET).bin

$(ODIR)/main.o: main.cpp
	@mkdir -p $(ODIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(TARGET).elf: $(ODIR)/main.o
	$(CXX) $(ODIR)/main.o -o $@ $(LDFLAGS)

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $(TARGET).elf $(TARGET).bin
	@echo "--- PS4 BIN Uspjesno izgradjen! ---"

clean:
	rm -rf $(ODIR) $(TARGET).elf $(TARGET).bin

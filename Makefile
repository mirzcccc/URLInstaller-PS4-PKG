TARGET := URLInstaller
CXX    := orbis-clang++
OBJCOPY := orbis-objcopy
ODIR   := build

CXXFLAGS := -fno-stack-protector -fPIC -O2 -Wall -std=c++17
LDFLAGS  := -nostdlib -Wl,--eh-frame-hdr

all: $(TARGET).bin

$(ODIR)/main.o: main.cpp
	@mkdir -p $(ODIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(TARGET).elf: $(ODIR)/main.o
	$(CXX) $(ODIR)/main.o -o $@ $(LDFLAGS)

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $(TARGET).elf $(TARGET).bin
	@echo "--- PS4 BIN Successfully built! ---"

clean:
	rm -rf $(ODIR) $(TARGET).elf $(TARGET).bin

#include <stdio.h>

// Osnovne PS4 funkcije iz OpenOrbis SDK-a
extern "C" {
    int sceUserServiceInitialize(void* args);
}

int main(int argc, char* argv[]) {
    // Inicijalizacija osnovnog PS4 servisa
    sceUserServiceInitialize(NULL);
    
    printf("URLInstaller je uspjesno pokrenut na PS4!\n");
    return 0;
}

#include <lynx.h>
#include "chipsong.h" // furnace song .raw turned c array

void play_audio(void) {
    unsigned int i; 
    for (i = 0; i < song_raw_len; i++) {
        *((volatile unsigned char*)0xFF1F) = song_raw[i];
    }
}

int main(void) {
    play_audio();
    while (1) {}
    return 0;
}

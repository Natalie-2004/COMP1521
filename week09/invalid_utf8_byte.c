// Given an UTF-8 string, return the index of the first invalid byte.
// If there are no invalid bytes, return -1.

int codepoint_width(char *codepoint) {
    if ((*codepoint & 0x80) == 0x00) return 1;
    if ((*codepoint & 0xe0) == 0xc0) return 2;
    if ((*codepoint & 0xf0) == 0xe0) return 3;
    if ((*codepoint & 0xf8) == 0xf0) return 4;
    return 0; // Return 0 for invalid UTF-8 bytes.
}

int invalid_utf8_byte(char *utf8_string) {
    int i = 0;
    while (utf8_string[i] != '\0') {
        int width = codepoint_width(&utf8_string[i]);
        if (width == 0) return i;
        for (int j = 1; j < width; j++) {
            // Check that continuation bytes are valid.
            if ((utf8_string[i + j] & 0xc0) != 0x80) return i + j;
        }
        i += width;
    }

    return -1; 
}
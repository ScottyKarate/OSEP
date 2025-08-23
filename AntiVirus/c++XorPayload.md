void xor_encode(uint8_t* data, size_t len, uint8_t key);

void xor_encode(uint8_t* data, size_t len, uint8_t key) {
for (size_t i = 0; i < len; i++) {
data[i] ^= key;
}
}


 //printf("unsigned char buf[] = \"");
//for (size_t i = 0; i < sizeof(buf); i++) {
// printf("\\x%02x", buf[i]);
//}
//printf("\";\n");

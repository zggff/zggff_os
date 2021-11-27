void print(char string[]);

void main() {
    char *video_memory = (char *)0xB8000;
    char string[] = "zggff";
    print(string);
}

void print(char string[]) {
    int index = 0;
    char *video_memory = (char *)0xB8000;
    while (string[index]) {
        *video_memory = string[index];
        index++;
        video_memory += 2;
    }
}
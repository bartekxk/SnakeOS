#define DOWN 0x50
#define num1 0x2
#define num2 0x3
#define key_b 0x30
#define esc 0x1

void _start()
{
    main();
}

void clear_screen()
{
    int i = 0;
    char * video_memory = (char *) 0xb8000;
    for(; i < 2000; i++)
    {
        *video_memory = ' ';
        video_memory+=2;
    }
    return;
}

void printf(char data[256])
{
    char * video_memory = (char *) 0xb8000;
    int i = 0;
    for(;; i++, video_memory += 2)
    {
        char x = data[i];
        if(x == '\0')
            break;
        *video_memory = x;
        *(video_memory + 1) = (char) 0x0F;
    }

    return;
}

void printf_char(char data, int x, int y)
{
    char * video_memory = (char *) 0xb8000;
    video_memory += (x + (y * 80)) * 2;
    *video_memory = data;
    *(video_memory + 1) = (char) 0x0F;

    return;
}

void printf_xy(char data[256], int x, int y)
{
    char * video_memory = (char *) 0xb8000;
    video_memory += (x + (y * 80)) * 2;
    int i = 0;
    for(;; i++, video_memory += 2)
    {
        char c = data[i];
        if(c == '\0')
            break;
        *video_memory = c;
        *(video_memory + 1) = (char) 0x0F;
    }

    return;
}

void outb( unsigned short port, unsigned char val )
{
   asm volatile("outb %0, %1" : : "a"(val), "Nd"(port) );
}

static __inline char inb (unsigned short int port)
{
  char _v;

  __asm__ __volatile__ ("inb %w1,%0":"=a" (_v):"Nd" (port));
  return _v;
}

char get_scancode()
{
    char inputdata = inb(0x60);
    return inputdata;
}

void exit()
{
    clear_screen();
    char exit_info[256] = "The system is shutted down, you can power off the computer.";
    exit_info[59] = 0;
    printf(exit_info);
    __asm__ __volatile__ ("hlt");
}

void draw_board()
{
    char x = 'x';
    char s = ' ';
    char game_legend[256] = "Arrow keys, esc to exit.";
    game_legend[24] = 0;
    int i=0, j=0;
    for(;i<24;i++)
    {
        j = 0;
        for(; j < 80;j++)
        {
            if(j == 0 || j == 79 || i == 0 || i ==23)
                printf_char(x, j, i);
            else
                printf_char(s, j, i);
        }
    }
    printf_xy(game_legend, 0, 24);
    return;
}

void snake()
{
    clear_screen();
    draw_board();
    for(;;)
    {
        char key = get_scancode();
        if(key == esc)
        {
            return;
        }
    }
    return;
}

void notepad()
{
    return;
}

void apps()
{
    for(;;)
    {
        clear_screen();
        char app1[256] = "Snake[1]";
        char app2[256] = "Notepad[2]";
        char back[256] = "Back[B]";
        app1[8] = 0;
        app2[10] = 0;
        back[7] = 0;
        
        printf(app1);
        printf_xy(app2, 0, 1);
        printf_xy(back, 0, 2);

        for(;;)
        {
            char key = get_scancode();
            if(key == num1)
            {
                snake();
                break;
            } else if (key == num2){
                notepad();
                break;
            } else if (key == key_b)
            {
                return;
            }
        }
    }
    return;
}

void menu()
{
    for(;;)
    {
        clear_screen();
        char title[256] = "Snake Operating System";
        char option1[256] = "Apps[1]";
        char option2[256] = "Exit[2]";
        title[22] = 0;
        option1[7] = 0;
        option2[7] = 0;
        printf(title);
        printf_xy(option1, 0, 1);
        printf_xy(option2, 0, 2);
        for(;;)
        {
            char key = get_scancode();
            if(key == num1)
            {
                apps();
                break;
            } else if (key == num2){
                exit();
                break;
            }
        }
    }
    return;
}

int main()
{
    menu();
    for(;;){}
}

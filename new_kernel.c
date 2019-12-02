#define DOWN 0x50
#define UP 0x48
#define RIGHT 0x4D
#define LEFT 0x4B
#define num1 0x2
#define num2 0x3
#define key_b 0x30
#define esc 0x1
#define S_KEY 0x1F
#define N_KEY 0x32

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
        *(video_memory + 1) = 0;
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

void printf_char_color(char data, int x, int y, char color)
{
    char * video_memory = (char *) 0xb8000;
    video_memory += (x + (y * 80)) * 2;
    *video_memory = data;
    *(video_memory + 1) = color;

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

void restart_keyboard()
{    
   int data = inb(0x61);     
   outb(0x61,data | 0x80);//Disables the keyboard  
   outb(0x61,data & 0x7F);//Enables the keyboard  
   return;
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
    char game_legend[256] = "Arrow keys, esc to exit. Points:";
    game_legend[32] = 0;
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
    char game_over[256] = "Game over. Press esc to exit.";
    int direction =0;
    game_over[28] = 0;
    int i = 0, snake_len = 3, steps = 0, last_x, last_y, points = 0;
    int to_addx=0, to_addy=0;
    int snake_position[256][2];
    int apples[2][2] = {{10, 2}, {60,20}};   
    snake_position[0][0]=40;
    snake_position[0][1]=12;
    snake_position[1][0]=40;
    snake_position[1][1]=13;
    snake_position[2][0]=40;
    snake_position[2][1]=14;
    snake_position[3][0]=-1;
    clear_screen();
    draw_board();
    for(;;)
    {
        if(apples[1][0] == snake_position[0][0] && apples[1][1] == snake_position[0][1])
        {
            snake_len++;
            snake_position[snake_len -1][0] =snake_position[snake_len -2][0] + to_addx;
            snake_position[snake_len -1][0] =snake_position[snake_len -2][0] + to_addy;
            apples[1][0] = (snake_position[0][0] * snake_len *8 %79) + 1;
            apples[1][0] = ((snake_position[1][1] - snake_len) *8 %22) + 1;
            points++;
        }
        if(apples[0][0] == snake_position[0][0] && apples[0][1] == snake_position[0][1])
        {
            snake_len++;
            snake_position[snake_len -1][0] =snake_position[snake_len -2][0] + to_addx;
            snake_position[snake_len -1][0] =snake_position[snake_len -2][0] + to_addy;
            apples[0][0] = (snake_position[0][0] * snake_len *steps %78) + 1;
            apples[0][0] = ((snake_position[1][1] - snake_len) *steps %22) + 1;
            points++;
        }
        for(i = 0;i < snake_len;i++)
        {
            printf_char_color('$',snake_position[i][0],snake_position[i][1],0b00110000);
        }
        printf_char_color('o',apples[0][0],apples[0][1],0b01010000);
        printf_char_color('o',apples[1][0],apples[1][1],0b01010000);
        printf_char((points/10) + 48, 32,24);
        printf_char((points%10) + 48, 33,24);
        for(i = 10000000;i>0;i--){}
        steps++;
        char key = get_scancode();
        switch(key)
        {
            case esc:
                return;
            case LEFT:
                if(direction != 2)
                    direction = 1;   
                break;
            case RIGHT:
                if(direction != 1)
                    direction = 2;   
                break;
            case UP:
            if(direction != 4)
                    direction = 3;   
                break;
            case DOWN:
                if(direction != 3)
                    direction = 4;    
                break;
        }
            if(direction == 1){
                to_addx = 1;
                to_addy = 0;
                if(snake_position[0][0] != 1)
                {
                    last_x = snake_position[snake_len - 1][0];
                    last_y = snake_position[snake_len - 1][1];
                    for(i = snake_len - 1; i > 0;i --)
                    {
                        snake_position[i][0] = snake_position[i - 1][0];
                        snake_position[i][1] = snake_position[i - 1][1];
                    }
                    snake_position[i][0]--;
                    printf_char(' ',last_x, last_y);
                }else
                {
                    printf_xy(game_over,26,12);
                    for(;;)
                    {
                        key = get_scancode();
                        if(key == esc)
                        {
                            return;
                        }
                    }
                }
            }else if(direction == 2) {
                to_addx = -1;
                to_addy = 0;
                if(snake_position[0][0] != 78)
                {
                    last_x = snake_position[snake_len - 1][0];
                    last_y = snake_position[snake_len - 1][1];
                    for(i = snake_len - 1; i > 0;i --)
                    {
                        snake_position[i][0] = snake_position[i - 1][0];
                        snake_position[i][1] = snake_position[i - 1][1];
                    }
                    snake_position[i][0]++;
                    printf_char(' ',last_x, last_y);
                }else
                {
                    printf_xy(game_over,26,12);
                    for(;;)
                    {
                        key = get_scancode();
                        if(key == esc)
                        {
                            return;
                        }
                    }
                }
            }else if(direction == 3) {
                to_addx = 0;
                to_addy = 1;
                if(snake_position[0][1] != 1)
                {
                    last_x = snake_position[snake_len - 1][0];
                    last_y = snake_position[snake_len - 1][1];
                    for(i = snake_len - 1; i > 0;i --)
                    {
                        snake_position[i][0] = snake_position[i - 1][0];
                        snake_position[i][1] = snake_position[i - 1][1];
                    }
                    snake_position[i][1]--;
                    printf_char(' ',last_x, last_y);
                }else
                {
                    printf_xy(game_over,26,12);
                    for(;;)
                    {
                        key = get_scancode();
                        if(key == esc)
                        {
                            return;
                        }
                    }
                }
            }else if(direction == 4) {
                to_addx = 0;
                to_addy = -1;
                if(snake_position[0][1] != 22)
                {
                    last_x = snake_position[snake_len - 1][0];
                    last_y = snake_position[snake_len - 1][1];
                    for(i = snake_len - 1; i > 0;i --)
                    {
                        snake_position[i][0] = snake_position[i - 1][0];
                        snake_position[i][1] = snake_position[i - 1][1];
                    }
                    snake_position[i][1]++;
                    printf_char(' ',last_x, last_y);
                }else
                {
                    printf_xy(game_over,26,12);
                    for(;;)
                    {
                        key = get_scancode();
                        if(key == esc)
                        {
                            return;
                        }
                    }
                }
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
    int i;
    for(;;)
    {
        clear_screen();
        char app1[256] = "Snake[S]";
        char app2[256] = "Notepad (Not implemented in new kernel)[N]";
        char back[256] = "Back[B]";
        app1[8] = 0;
        app2[42] = 0;
        back[7] = 0;
        
        printf(app1);
        printf_xy(app2, 0, 1);
        printf_xy(back, 0, 2);

        for(;;)
        {
            char key = get_scancode();
            if(key == S_KEY)
            {
                snake();
                break;
            } else if (key == N_KEY){
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
    restart_keyboard();
    menu();
    for(;;){}
}

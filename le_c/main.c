#include <stdio.h>
#include <string.h>

char char2glyph(char input)
{
    // char minuscule starts at 97 on scii table and 10 on glyph table
    if (input >= 97)
    { // si lettre minuscule
        return input - 97 + 10;
    }
    else if (input >= 48 && input <= 57) // 48 -- 57 = 9 chiffres
    {
        return input - 97;
    }
    else if(input==' ')
    {
        return 36;
    }
    else
        return 64; // return case pleine
}

int main()
{
    /*
    Tout doit etre ecris sans accent et en minuscule
    */
    char *text_string = "cberthelot t bo";
    unsigned long text = 0;

    if (text == 0)
    {
        unsigned long result = 0;
        unsigned long plein = 1;
        unsigned long couleur = 1;
        unsigned long forme = 00;

        unsigned long x = 147;
        unsigned long y = 9;
        unsigned long x2 = 149;
        unsigned long y2 = 9;
         result =
	(plein << 43) + (couleur << 42) + (forme << 41) + (y2 << 30) +
	(x2 << 20) + (y << 10) + x;

        printf("result : %lx\n", result);
    }
    else
    {
        unsigned long glyph0 = 1;

        unsigned long x = 200;
        unsigned long y = 250;
        printf("x:%ld || y:%ld\n", x, y);
        printf("result :\n");
        int str_size=strlen(text_string);
        for(int i=0;i<str_size;i++){
        unsigned long result = (text << 38 + 6) + ((unsigned long)char2glyph(text_string[i]) << 20) + (y << 10) + x;
        x=x+6;
        printf("x\"%lx\",\n", result);
        }
    }

    return 0;
}

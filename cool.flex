/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex
#define W [ \t]
/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */


int lcount = 1;



%}

/*
 * Define names for regular expressions here.
 */

DARROW          =>
%x classname inherit inhetype

%%
[\n] lcount++;

class|CLASS { printf("#%d " ,lcount);
	printf("CLASS\n");}
[i|I][f|F]  {  printf("#%d ",lcount); printf("IF\n");}
[e|E][l|L][s|S][e|E] {  printf("#%d ",lcount); printf("ELSE\n");}
[f|F][i|I]  {  printf("#%d ",lcount); printf("FI\n");}
[l|L][e|E][t|T]  {  printf("#%d ",lcount); printf("LET\n");}
[i|I][n|N][h|H][e|E][r|R][i|I][t|T][s|S] {printf("#%d ",lcount);printf("INHERITS\n");}
[i|I][n|N] {printf("#%d ",lcount);printf("IN\n");}
[i|I][s|S][v|V][o|V][i|I][d|D] {printf("#%d ",lcount);printf("ISVOID\n");}
[l|L][o|O][o|O][p|P] {printf("#%d ",lcount);printf("LOOP\n");}
[p|P][o|O][o|O][l|L] {printf("#%d ",lcount);printf("POOL\n");}
[t|T][h|H][e|E][n|N] {printf("#%d ",lcount);printf("THEN\n");}
[w|W][h|H][i|I][l|L][e|E] {printf("#%d ",lcount);printf("WHILE\n");}
[c|C][a|A][s|S][e|E] {printf("#%d ",lcount);printf("CASE\n");}
[e|E][s|S][a|A][c|C] {printf("#%d ",lcount);printf("ESAC\n");}
[n|N][e|E][w|W] {printf("#%d ",lcount);printf("NEW\n");}
[o|O][f|F] {printf("#%d ",lcount);printf("OF\n");}
[n|N][o|O][t|T] {printf("#%d ",lcount);printf("NOT\n");}
[t][r|R][u|U][e|E] {printf("#%d ",lcount);printf("BOOL_CONST true\n");}
[f][a|A][l|L][s|S][e|E] {printf("#%d ",lcount);printf("BOOL_CONST false\n");}
	

			
[{|}|;|:|(|)|=|.|\/|\\|+|\-|*|~|`|,|<|@|#|$|%|^|&]   {  printf("#%d ",lcount);
		printf("'%s'\n",yytext);	}
> {printf("#%d ",lcount); printf("ERROR \">\"\n");}
[ |\t] ;
"--"[^\n]* ;

[a-z]+[0-9_A-Za-z]* {printf("#%d ",lcount); printf("OBJECTID %s\n",yytext);} 
[A-Z]+[0-9_a-zA-Z]*  {printf("#%d ",lcount);printf("TYPEID %s\n",yytext);}


[0-9]+ {printf("#%d ",lcount); printf("INT_CONST %s\n",yytext);}
\<\- {printf("#%d ",lcount); printf("ASSIGN\n");}
"*)" {printf("#%d ",lcount);printf("ERROR \"Unmatched *)\"\n");}
"(*" {
	char c;
	for(;;)
	{
		while( (c = yyinput()) != '*' && c != EOF && c != '\n');

		if(c == '*') {
			while((c = yyinput()) == '*');
		if(c == ')')
			break;
		}
		if(c == EOF)
		{
			printf("#%d ",lcount);
			printf("ERROR (\"EOF IN COMMENT\")");
            		break;
		}
		if(c == '\n') lcount++;

	}
     }

 /*
  *  Nested comments
  */


 /*
  *  The multiple-character operators.
  */
{DARROW}		{ return (DARROW); }

 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  */


 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */


%%

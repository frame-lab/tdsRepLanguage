%{

/*
*	inicilização de headers incluindo AST e Table
*/   

  #include <stdlib.h>
  #include <stdio.h>
  #include <string.h>
  #include "../headers/Enum.h"	
  //#include "../headers/Node.h"

  int yylex(void);
  FILE *fp;   //AST
  FILE *fp2;  //(scope) - Stable

  int yyparse();
  FILE *yyin;
 
  void yyerror(const char *s);

%}

/*
*	union para retornar os tipos desejados de dados para os tokens do lexer
	retornados como um yystype.  em que devemos definir os tipos por meio de uma union (pode assumir qualquer um dos valores dela)
*/ 



%union {
  int ival;
  float fval
  char *sval;
  bool boolean
}


/*
  definição dos tokens relacionados aos tipos
*/

%token <ival> RAWNUMBERDATA
%token <sval> EQUAL  
%token <sval> ASSIGN
%token <boolean> BOOLEAN
%token <sval> RETURN
%token <sval> FOR
%token <sval> TO
%token <sval> DO
%token <sval> LBRACE
%token <sval> RBRACE
%token <sval> LPAREN
%token <sval> RPAREN
%token <sval> IF
%token <sval> COLON
%token <sval> COMMA
%token <sval> AND
%token <sval> OR
%token <sval> IMPLIES
%token <sval> ELSE
%toekn <sval> NULL
%token <sval> XOR
%token <sval> LE
%token <sval> GE
%token <sval> LT
%token <sval> GT
%token <sval> PLUS
%token <sval> MINUS
%token <sval> TIMES
%token <sval> DIVIDE
%token <sval> ID


%%

/*
	Gramatica para o parser
*/

prog: cmd
      | functiondef
      {printf("comando ou definição de função /n")};

data: ID
	  | RAWNUMBERDATA
	  | BOOLEAN
	  | NULL
	  {printf("dados /n")};

functiondef: ID LPAREN  paramsoptional RPAREN LBRACE cmd RBRACE optionalreturn
            {printf("definição de função /n")};

paramsoptional: params 
			    | /* empty */
			    {printf("parametros opcionais /n")};

params:	ID paramslist 
	    | tdsformat paramslist
	    {printf("parametros /n")};

paramslist: paramslist COMMA ID
		    | paramslist COMMA tdsformat
		    | /* empty */
		    {printf("mais parametros /n")};

optionalreturn: RETURN data
				| RETURN tdsformat
				| /* empty */
				{printf("return /n")};

cmd: expr
	 | FOR ID ASSIGN expr TO expr DO COMMA cmd
	 | functioncall
	 | cond
	 | ID ASSIGN LBRACE content RBRACE 
	 | ID ASSIGN data
	 {printf("comando /n")};

expr: arit 
	 | logical
	 | ineq
	 {printf("expressao /n")};


arit: aritoperator
	  | arit aritoperation aritoperator
	  {printf("expressao ARITIMETICA /n")};

aritoperator: RAWNUMBERDATA
	  		  | ID
	  		  {printf("operarador ARITIMETICO /n")};

aritoperation: PLUS
			   | MINUS
			   | TIMES
			   | DIVIDE
			   {printf("operacao ARITIMETICO /n")};

logical: clause
		 | logical conec clause
		 {printf("exp logica  /n")};

clause: BOOLEAN 
		| NOT BOOLEAN
		| ID
		| NOT ID
		{printf(" clausula /n")};

conec: AND
	   | OR
	   | IMPLIES
	   | XOR
	   {printf("conector logico  /n")};

ineq: expr ineqop expr
	  {printf("inequacao /n")};

ineqop: LT 
	  | LE 
	  | GT 
	  | GE 
	  | EQUAL
	  {printf("inequacao operador  /n")};;

functioncall: ID LPAREN paramsoptional RPAREN
			  {printf("chamada de função /n")};

cond: IF LPAREN logical RPAREN LBRACE cmd RBRACE matchornot
	  {printf("if /n")};

matchornot: ELSE LBRACE cmd RBRACE 
			| /* empty */
			{printf("else /n")};

content: content COMMA tdsformat 
		 | tdsformat
		 {printf("conjunto de tds's /n")};

tdsformat: LPAREN data COMMA RAWNUMBERDATA COMMA ID RPAREN
		   {printf("tds /n")};


%%


int main(int argc, char* argv[]) {
  
  
  FILE *fp;

  fp = fopen(argv[1], "r");
  if(!fp){
  	printf("CADE MEU CODIGO!?");
  	return -1;
  } 
  yyin = fp;
  yyparse();
}


void yyerror(const char *s) {
  printf("Erro de parsing! %s",s);
  exit(-1);
}
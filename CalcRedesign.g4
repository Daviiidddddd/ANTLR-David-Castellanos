grammar CalcRedesign;

prog : stat+ ;

stat
  : expr NEWLINE
  | NEWLINE
  ;

expr : add ;

add
  : pow (op=('+'|'-') add)?   # AddRight
  ;

mul
  : add (op=('*'|'/') add)*   # MulLeft
  ;

pow
  : unary ( '^' pow )?        # PowRight
  ;

unary
  : '-' unary                 # UnaryMinusR
  | postfix
  ;

postfix
  : primary ('!')*            # PostfixR
  ;

primary
  : NUMBER
  | '(' expr ')'
  ;

NUMBER : [0-9]+ ('.' [0-9]+)? ;
WS : [ \t]+ -> skip ;
NEWLINE: '\r'? '\n' ;

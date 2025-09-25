// placeholder CalcRedesign.g4 David Castellanos

grammar CalcOriginal;

prog : stat+ ;

stat
  : expr NEWLINE            # printExpr
  | NEWLINE                 # blank
  ;

expr : add ;

add
  : mul (op=('+'|'-') mul)*  # Add
  ;

mul
  : pow (op=('*'|'/') pow)*  # Mul
  ;

pow
  : unary ( '^' unary )*     # PowLeft
  ;

unary
  : '-' unary                # UnaryMinus
  | postfix                  # ToPostfix
  ;

postfix
  : primary ('!')*           # Postfix
  ;

primary
  : NUMBER                   # Number
  | '(' expr ')'             # Parens
  ;

NUMBER : [0-9]+ ('.' [0-9]+)? ;
WS : [ \t]+ -> skip ;
NEWLINE: '\r'? '\n' ;


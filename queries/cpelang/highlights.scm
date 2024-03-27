"def" @keyword
"if" @keyword
"then" @keyword
"else" @keyword
"match" @keyword
"with" @keyword
"let" @keyword
"in" @keyword
"and" @keyword

"+" @operator
"-" @operator
"*" @operator
"/" @operator
"//" @operator
"%" @operator
"==" @operator
"!=" @operator
"<" @operator
"<=" @operator
">=" @operator
">" @operator
"||" @operator
"&&" @operator
"::" @operator
"." @operator
"$" @operator
"++" @operator

(type_or_constructor_name) @type
(typeexpr (variable) @type)

(type_or_constructor_name (unit)) @type

(func_def (variable) @function)
(arg (variable) @variable.parameter)

(stringlit) @string
(charlit) @string
(intlit) @number
(floatlit) @number.float
(boollit) @boolean

(letbinding (variable)) @variable.parameter
(literal (variable) @variable.parameter)

(comment) @comment

(bslash) @keyword.operator
(darrow) @keyword.operator

(funcapp (variable)) @function.call

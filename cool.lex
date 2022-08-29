/*
 *  The scanner definition for COOL.
 */

import java_cup.runtime.Symbol;

%%

%{

/*  Stuff enclosed in %{ %} is copied verbatim to the lexer class
 *  definition, all the extra variables/functions you want to use in the
 *  lexer actions should go here.  Don't remove or modify anything that
 *  was there initially.  */

    // Max size of string constants
    static int MAX_STR_CONST = 1025;

    // For assembling string constants
    StringBuffer string_buf = new StringBuffer();

    private int curr_lineno = 1;
    int get_curr_lineno() {
	return curr_lineno;
    }

    private AbstractSymbol filename;

    void set_filename(String fname) {
	filename = AbstractTable.stringtable.addString(fname);
    }

    AbstractSymbol curr_filename() {
	return filename;
    }
%}

%init{

/*  Stuff enclosed in %init{ %init} is copied verbatim to the lexer
 *  class constructor, all the extra initialization you want to do should
 *  go here.  Don't remove or modify anything that was there initially. */

    // empty for now
%init}

%eofval{

/*  Stuff enclosed in %eofval{ %eofval} specifies java code that is
 *  executed when end-of-file is reached.  If you use multiple lexical
 *  states and want to do something special if an EOF is encountered in
 *  one of those states, place your code in the switch statement.
 *  Ultimately, you should return the EOF symbol, or your lexer won't
 *  work.  */

    switch(yy_lexical_state) {
    case YYINITIAL:
	/* nothing special to do in the initial state */
	break;
	/* If necessary, add code for other states here, e.g:
	   case COMMENT:
	   ...
	   break;
	*/
    }
    return new Symbol(TokenConstants.EOF);
%eofval}

%class CoolLexer
%cup

DIGIT = [0-9]+

%%

<YYINITIAL>"=>"			{ /* Sample lexical rule for "=>" arrow.
                                     Further lexical rules should be defined
                                     here, after the last %% separator */
                                  return new Symbol(TokenConstants.DARROW); }


<YYINITIAL>[Cc][Ll][Aa][Ss][Ss] {
	return new Symbol(TokenConstants.CLASS); }
	
	
<YYINITIAL>[ ] { 

}

<YYINITIAL>[Ee][Ll][Ss][Ee] {
	return new Symbol(TokenConstants.ELSE); }


<YYINITIAL>[t][Rr][Uu][Ee] {
	return new Symbol(TokenConstants.BOOL_CONST, true); }

<YYINITIAL>[A-Z][A-Za-z0-9_]* {
	AbstractSymbol typeIdentifier = AbstractTable.idtable.addString(yytext()); 
	return new Symbol(TokenConstants.TYPEID, typeIdentifier); }

<YYINITIAL>[a-z][A-Za-z0-9_]* {
	AbstractSymbol objectIdentifier = AbstractTable.idtable.addString(yytext()); 
	return new Symbol(TokenConstants.OBJECTID, objectIdentifier); }

<YYINITIAL>[{] {
	return new Symbol(TokenConstants.LBRACE); }

<YYINITIAL>[(] {
	return new Symbol(TokenConstants.LPAREN); }
	
<YYINITIAL>[)] {
	return new Symbol(TokenConstants.RPAREN); }

<YYINITIAL>[:] {
	return new Symbol(TokenConstants.COLON); }

{DIGIT} {
  AbstractSymbol num = AbstractTable.inttable.addString(yytext());
  return new Symbol(TokenConstants.INT_CONST, num);
}

<YYINITIAL>[\n] {
	curr_lineno++; }

<YYINITIAL>[}] {
	return new Symbol(TokenConstants.RBRACE); }

<YYINITIAL>[;] {
	return new Symbol(TokenConstants.SEMI); }






.                               { /* This rule should be the very last
                                     in your lexical specification and
                                     will match match everything not
                                     matched by other lexical rules. */
                                  System.err.println("LEXER BUG - UNMATCHED: " + yytext()); }

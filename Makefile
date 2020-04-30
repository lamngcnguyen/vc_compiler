#
# make test (or just: make)
#    generates lexer & parser, compiles all *.java files, and runs test
#

# main class
MAIN = Main

# test data
#TEST_IN  = src/test/data/test.txt
#OUT_GOOD = src/test/data/output.good

# jflex input and output
LEXER_IN = src/main/jflex/vc.flex
LEXER_CLASS = Scanner

# cup file
PARSER_IN = src/main/cup/vc.cup

include ../common/Makefile.inc

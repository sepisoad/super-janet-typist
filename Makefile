#
# In order to execute this "Makefile" just type "make"
#	A. Delis (ad@di.uoa.gr)
#

SRCDIR = src
OBJS	= janet.o main.o
SOURCE	= janet.c main.c
#SOURCELST = $(foreach fn, $(SOURCE), $(SRCDIR)/$(fn))
HEADER	= cfuncs.h janetconf.h janet.h
OUT	= engine
CC	 = gcc
FLAGS	 = -ggdb -c -Wall
LFLAGS	 = -lm -lraylib -ldl
# -g option enables debugging mode 
# -c flag generates object code for separate files

all: $(OBJS)
	$(CC) -g $(OBJS) -o $(OUT) $(LFLAGS)

# create/compile the individual files >>separately<<
janet.o: $(SRCDIR)/janet.c
	$(CC) $(FLAGS) $(SRCDIR)/janet.c -std=c11

main.o: $(SRCDIR)/main.c
	$(CC) $(FLAGS) $(SRCDIR)/main.c -std=c11

# clean house
clean:
	rm -f $(OBJS) $(OUT)

# run the program
run: $(OUT)
	./$(OUT)

# compile program with debugging information
debug: $(OUT)
	valgrind $(OUT)

# run program with valgrind for errors
valgrind: $(OUT)
	valgrind $(OUT)

# run program with valgrind for leak checks
valgrind_leakcheck: $(OUT)
	valgrind --leak-check=full $(OUT)

# run program with valgrind for leak checks (extreme)
valgrind_extreme: $(OUT)
	valgrind --leak-check=full --show-leak-kinds=all --leak-resolution=high --track-origins=yes --vgdb=yes $(OUT)
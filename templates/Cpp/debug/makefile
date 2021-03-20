CC = /usr/bin/g++
CCFLAGS = -Wall -g
INCPATH = -I ../headers/
OBJ = classname.o main.o
BIN = appname

../$(BIN): $(OBJ)
	$(CC) $(CCFLAGS) -o ../$(BIN) $(OBJ)

%.o: ../src/%.cpp
	$(CC) $(CCFLAGS) -c $< $(INCPATH)

clean:
	rm -rf $(BIN) $(OBJ)

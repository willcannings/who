SRCS	 = $(shell find src -name '*.cpp')
OBJS	 = ${SRCS:.cpp=.o}
DEPS	 = ${OBJS:.o=.d}
INCFLAGS = -Isrc -I/usr/local/include
CPPFLAGS += -O4
LIB		 = libwho.a

# OS X
#CXX		   = clang++
STATIC_LIB = libtool -o
OBJ_FLAGS  = -MD
CPPFLAGS   += -std=c++11 -stdlib=libc++

.SUFFIXES:
.SUFFIXES: .cpp .o .d

-include $(DEPS)

%.o: %.cpp
	$(CXX) $(INCFLAGS) $(CPPFLAGS) $(OBJ_FLAGS) -emit-llvm -o $@ -c $<

$(LIB): $(OBJS)
	$(STATIC_LIB) obj/$(LIB) $(OBJS) -lwiredtiger

server: $(LIB)
	$(CXX) $(INCFLAGS) $(CPPFLAGS) -o bin/server src/main/server.cpp

unittests: $(LIB)
	$(CXX) $(INCFLAGS) $(CPPFLAGS) -o bin/unittest tests/unittests.cpp obj/$(LIB)

all: server

clean:
	rm -rf $(OBJS)
	rm -rf $(DEPS)
	rm -rf obj/*
	rm -rf bin/*


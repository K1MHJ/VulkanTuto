.PHONY: all run
CC := clang
CXX := clang++
LD := clang++
AR := ar
RANLIB :=
CFLAGS := -g -O0 -Wall -MP -MMD
CXXFLAGS := $(CFLAGS) -std=c++20 -xc++
SRCDIR := ./src
OBJDIR := ./obj
BINDIR := ./bin
INCLUDE := -I/opt/homebrew/include/ -I/usr/include/ -I/usr/local/include/ 
INCLUDE := $(INCLUDE) -I$(VULKAN_SDK)/include -I$(VULKAN_SDK)/lib
DEFINES := 
TARGET := ./bin/VulApp
OPENGLLIB := -L/opt/homebrew/Cellar/glfw/3.4/lib
LDFLAGS   := -L/usr/lib -L/usr/local/lib $(OPENGLLIB) -L$(VULKAN_SDK)/lib -lglfw.3.4 -lvulkan
FRAMEWORKS :=

PCH_OUT := 
PCH_SRC := 
PCH_HEADERS := 

SRC := main.cpp
# SRC := $(SRC) vendor/stb_image/stb_image.cpp 
#
SRC := $(SRC)

OBJS  := $(addprefix $(OBJDIR)/, $(SRC:.cpp=.o)) 
DEPS  := $(addprefix $(OBJDIR)/, $(SRC:.cpp=.d))

all: $(TARGET)

run:
	$(TARGET)

$(TARGET): $(OBJS)
	@echo '$$'LDFLAGS is $(LDFLAGS)
	mkdir -p $(@D)
	$(LD) $^ -o $@ $(LDFLAGS) $(FRAMEWORKS)

$(PCH_OUT): $(PCH_SRC) $(PCH_HEADERS)
	mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(INCLUDE) -o $@ -c $< -x c++-header

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp $(PCH_OUT)
	# @[ -d $(OBJDIR) ]
	mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(INCLUDE) -o $@ -c $< 

$(OBJDIR)/%.o: %.cpp $(PCH_OUT)
	# @[ -d $(OBJDIR) ]
	mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(INCLUDE) -o $@ -c $< -include $(PCH_HEADERS)

debug : $(TARGET)
	@echo "debug $(TARGET)"
	lldb $(TARGET)

clean :
	rm -rf $(BINDIR) $(OBJDIR)

-include $(DEPS)

# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.29

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /nix/store/q1nssraba326p2kp6627hldd2bhg254c-cmake-3.29.2/bin/cmake

# The command to remove a file.
RM = /nix/store/q1nssraba326p2kp6627hldd2bhg254c-cmake-3.29.2/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/runner/FAQ-Langchain/poppler-23.09.0

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/runner/FAQ-Langchain/poppler-23.09.0/build

# Include any dependencies generated for this target.
include utils/CMakeFiles/pdfattach.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include utils/CMakeFiles/pdfattach.dir/compiler_depend.make

# Include the progress variables for this target.
include utils/CMakeFiles/pdfattach.dir/progress.make

# Include the compile flags for this target's objects.
include utils/CMakeFiles/pdfattach.dir/flags.make

utils/CMakeFiles/pdfattach.dir/parseargs.cc.o: utils/CMakeFiles/pdfattach.dir/flags.make
utils/CMakeFiles/pdfattach.dir/parseargs.cc.o: /home/runner/FAQ-Langchain/poppler-23.09.0/utils/parseargs.cc
utils/CMakeFiles/pdfattach.dir/parseargs.cc.o: utils/CMakeFiles/pdfattach.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/runner/FAQ-Langchain/poppler-23.09.0/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object utils/CMakeFiles/pdfattach.dir/parseargs.cc.o"
	cd /home/runner/FAQ-Langchain/poppler-23.09.0/build/utils && /nix/store/9bv7dcvmfcjnmg5mnqwqlq2wxfn8d7yi-gcc-wrapper-13.2.0/bin/g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT utils/CMakeFiles/pdfattach.dir/parseargs.cc.o -MF CMakeFiles/pdfattach.dir/parseargs.cc.o.d -o CMakeFiles/pdfattach.dir/parseargs.cc.o -c /home/runner/FAQ-Langchain/poppler-23.09.0/utils/parseargs.cc

utils/CMakeFiles/pdfattach.dir/parseargs.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/pdfattach.dir/parseargs.cc.i"
	cd /home/runner/FAQ-Langchain/poppler-23.09.0/build/utils && /nix/store/9bv7dcvmfcjnmg5mnqwqlq2wxfn8d7yi-gcc-wrapper-13.2.0/bin/g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/runner/FAQ-Langchain/poppler-23.09.0/utils/parseargs.cc > CMakeFiles/pdfattach.dir/parseargs.cc.i

utils/CMakeFiles/pdfattach.dir/parseargs.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/pdfattach.dir/parseargs.cc.s"
	cd /home/runner/FAQ-Langchain/poppler-23.09.0/build/utils && /nix/store/9bv7dcvmfcjnmg5mnqwqlq2wxfn8d7yi-gcc-wrapper-13.2.0/bin/g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/runner/FAQ-Langchain/poppler-23.09.0/utils/parseargs.cc -o CMakeFiles/pdfattach.dir/parseargs.cc.s

utils/CMakeFiles/pdfattach.dir/Win32Console.cc.o: utils/CMakeFiles/pdfattach.dir/flags.make
utils/CMakeFiles/pdfattach.dir/Win32Console.cc.o: /home/runner/FAQ-Langchain/poppler-23.09.0/utils/Win32Console.cc
utils/CMakeFiles/pdfattach.dir/Win32Console.cc.o: utils/CMakeFiles/pdfattach.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/runner/FAQ-Langchain/poppler-23.09.0/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object utils/CMakeFiles/pdfattach.dir/Win32Console.cc.o"
	cd /home/runner/FAQ-Langchain/poppler-23.09.0/build/utils && /nix/store/9bv7dcvmfcjnmg5mnqwqlq2wxfn8d7yi-gcc-wrapper-13.2.0/bin/g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT utils/CMakeFiles/pdfattach.dir/Win32Console.cc.o -MF CMakeFiles/pdfattach.dir/Win32Console.cc.o.d -o CMakeFiles/pdfattach.dir/Win32Console.cc.o -c /home/runner/FAQ-Langchain/poppler-23.09.0/utils/Win32Console.cc

utils/CMakeFiles/pdfattach.dir/Win32Console.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/pdfattach.dir/Win32Console.cc.i"
	cd /home/runner/FAQ-Langchain/poppler-23.09.0/build/utils && /nix/store/9bv7dcvmfcjnmg5mnqwqlq2wxfn8d7yi-gcc-wrapper-13.2.0/bin/g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/runner/FAQ-Langchain/poppler-23.09.0/utils/Win32Console.cc > CMakeFiles/pdfattach.dir/Win32Console.cc.i

utils/CMakeFiles/pdfattach.dir/Win32Console.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/pdfattach.dir/Win32Console.cc.s"
	cd /home/runner/FAQ-Langchain/poppler-23.09.0/build/utils && /nix/store/9bv7dcvmfcjnmg5mnqwqlq2wxfn8d7yi-gcc-wrapper-13.2.0/bin/g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/runner/FAQ-Langchain/poppler-23.09.0/utils/Win32Console.cc -o CMakeFiles/pdfattach.dir/Win32Console.cc.s

utils/CMakeFiles/pdfattach.dir/pdfattach.cc.o: utils/CMakeFiles/pdfattach.dir/flags.make
utils/CMakeFiles/pdfattach.dir/pdfattach.cc.o: /home/runner/FAQ-Langchain/poppler-23.09.0/utils/pdfattach.cc
utils/CMakeFiles/pdfattach.dir/pdfattach.cc.o: utils/CMakeFiles/pdfattach.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/runner/FAQ-Langchain/poppler-23.09.0/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object utils/CMakeFiles/pdfattach.dir/pdfattach.cc.o"
	cd /home/runner/FAQ-Langchain/poppler-23.09.0/build/utils && /nix/store/9bv7dcvmfcjnmg5mnqwqlq2wxfn8d7yi-gcc-wrapper-13.2.0/bin/g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT utils/CMakeFiles/pdfattach.dir/pdfattach.cc.o -MF CMakeFiles/pdfattach.dir/pdfattach.cc.o.d -o CMakeFiles/pdfattach.dir/pdfattach.cc.o -c /home/runner/FAQ-Langchain/poppler-23.09.0/utils/pdfattach.cc

utils/CMakeFiles/pdfattach.dir/pdfattach.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/pdfattach.dir/pdfattach.cc.i"
	cd /home/runner/FAQ-Langchain/poppler-23.09.0/build/utils && /nix/store/9bv7dcvmfcjnmg5mnqwqlq2wxfn8d7yi-gcc-wrapper-13.2.0/bin/g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/runner/FAQ-Langchain/poppler-23.09.0/utils/pdfattach.cc > CMakeFiles/pdfattach.dir/pdfattach.cc.i

utils/CMakeFiles/pdfattach.dir/pdfattach.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/pdfattach.dir/pdfattach.cc.s"
	cd /home/runner/FAQ-Langchain/poppler-23.09.0/build/utils && /nix/store/9bv7dcvmfcjnmg5mnqwqlq2wxfn8d7yi-gcc-wrapper-13.2.0/bin/g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/runner/FAQ-Langchain/poppler-23.09.0/utils/pdfattach.cc -o CMakeFiles/pdfattach.dir/pdfattach.cc.s

# Object files for target pdfattach
pdfattach_OBJECTS = \
"CMakeFiles/pdfattach.dir/parseargs.cc.o" \
"CMakeFiles/pdfattach.dir/Win32Console.cc.o" \
"CMakeFiles/pdfattach.dir/pdfattach.cc.o"

# External object files for target pdfattach
pdfattach_EXTERNAL_OBJECTS =

utils/pdfattach: utils/CMakeFiles/pdfattach.dir/parseargs.cc.o
utils/pdfattach: utils/CMakeFiles/pdfattach.dir/Win32Console.cc.o
utils/pdfattach: utils/CMakeFiles/pdfattach.dir/pdfattach.cc.o
utils/pdfattach: utils/CMakeFiles/pdfattach.dir/build.make
utils/pdfattach: utils/CMakeFiles/pdfattach.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/home/runner/FAQ-Langchain/poppler-23.09.0/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Linking CXX executable pdfattach"
	cd /home/runner/FAQ-Langchain/poppler-23.09.0/build/utils && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/pdfattach.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
utils/CMakeFiles/pdfattach.dir/build: utils/pdfattach
.PHONY : utils/CMakeFiles/pdfattach.dir/build

utils/CMakeFiles/pdfattach.dir/clean:
	cd /home/runner/FAQ-Langchain/poppler-23.09.0/build/utils && $(CMAKE_COMMAND) -P CMakeFiles/pdfattach.dir/cmake_clean.cmake
.PHONY : utils/CMakeFiles/pdfattach.dir/clean

utils/CMakeFiles/pdfattach.dir/depend:
	cd /home/runner/FAQ-Langchain/poppler-23.09.0/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/runner/FAQ-Langchain/poppler-23.09.0 /home/runner/FAQ-Langchain/poppler-23.09.0/utils /home/runner/FAQ-Langchain/poppler-23.09.0/build /home/runner/FAQ-Langchain/poppler-23.09.0/build/utils /home/runner/FAQ-Langchain/poppler-23.09.0/build/utils/CMakeFiles/pdfattach.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : utils/CMakeFiles/pdfattach.dir/depend

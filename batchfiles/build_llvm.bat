@set UTILS_FOLDER=<Absolute path of Win Flex-Bison>
@set LLVM_SRC=<Relative path of LLVM repo>
@set PATH=%PATH%;%UTILS_FOLDER%
@regsvr32 /s "%VSINSTALLDIR%\DIA SDK\bin\msdia140.dll"
@regsvr32 /s "%VSINSTALLDIR%\DIA SDK\bin\amd64\msdia140.dll"
@cmake -S llvm\llvm -B buildllvm -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_USE_CRT_RELEASE=MT -DLLVM_USE_CRT_DEBUG=MTd -DCMAKE_INSTALL_PREFIX=<LLVM_INSTALL_PREFIX> -G "Visual Studio 17 2022" -Ax64 -T ClangCL
@cd buildllvm
@msbuild /p:Configuration=Release INSTALL.vcxproj /m
@regsvr32 /u /s "%VSINSTALLDIR%\DIA SDK\bin\msdia140.dll"
@regsvr32 /u /s "%VSINSTALLDIR%\DIA SDK\bin\amd64\msdia140.dll"
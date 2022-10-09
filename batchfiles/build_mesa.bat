@set UTILS_FOLDER=<Absolute path of Win Flex-Bison>
@set MESA_SRC=<Mesa3D source>
@set LLVM=<Path to LLVM bin>
@set PATH=%PATH%;%UTILS_FOLDER%;%LLVM%
@set INSTALL_PATH=<INSTALL_PREFIX>
@set CC=clang-cl
@set CXX=clang-cl
@set CC_LD=lld-link
@set WINDRES=llvm-rc
@cd %MESA_SRC%
@meson setup --backend=vs builddir/ -Dbuildtype=release -Db_vscrt=static_from_buildtype -Dosmesa=true -Ddri-drivers= -Dgallium-drivers=swrast -Dvulkan-drivers=swrast
@echo Check the solution file
@pause
@meson compile -C builddir
@meson install -C builddir --destdir %INSTALL_PATH%

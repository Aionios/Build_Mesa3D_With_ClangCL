# Using Visual Studio 2022 ClangCL to build LLVMPipe
## Requirements
* Install `Python3` and use `pip` to install
  * `mako`
  * `meson`
  * `psutil`
* download the [Win Flex-Bisn](https://sourceforge.net/projects/winflexbison/) portable and extract to a folder

## Build LLVM 15.0.2
* clone the llvm project to llvm and checkout 15.0.2

* `set PATH=%PATH%;<absolute Flex and Bison Path>`
* Configure the LLVM
```
cmake -S llvm\llvm -B buildllvm -DLLVM_TARGETS_TO_BUILD=X86 \
-DLLVM_USE_CRT_RELEASE=MT -DLLVM_USE_CRT_DEBUG=MTd \
-DCMAKE_INSTALL_PREFIX=E:\LLVM15.0.2 \
-G "Visual Studio 17 2022" -Ax64 -T ClangCL
```
* `msbuild /p:Configuration=Release INSTALL.vcxproj`
## Build LLVMPipe 22.2.0
* Set clang-cl for meson
```
set CC=clang-cl
set CXX=clang-cl
set CC_LD=lld-link
set WINDRES=llvm-rc
```
* Find windows.py in mesonbuild's module folder and add

`('/?', '^.*Resource Converter*$', ResourceCompilerType.rc)`
to
```
for (arg, match, rc_type) in [
                ('/?', '^.*Microsoft.*Resource Compiler.*$', ResourceCompilerType.rc),
                ('--version', '^.*GNU windres.*$', ResourceCompilerType.windres),
                ('--version', '^.*Wine Resource Compiler.*$', ResourceCompilerType.wrc),
        ]:
```
if the code doesn't contain output string of `llvm-rc /?`. Otherwise the meson cannot find `llvm-rc`.
* `set PATH=%PATH%;<LLVM INSTALL PREFIX>/bin`
* `set LLVM=<LLVM INSTALL PREFIX>` (not necessary?)

* Configure the Mesa3d 
```
meson setup --backend=vs2022 builddir/ -Dbuildtype=release \
-Db_vscrt=static_from_buildtype \
-Dosmesa=true \
-Ddri-drivers= \
-Dgallium-drivers=swrast \
-Dvulkan-drivers=swrast \
-Db_vscrt=static_from_buildtype
```
* `meson compile -C builddir`
* `meson install -C builddir --destdir <INSTALL_PREFIX>`

## Known issues for mesa22.2.0 and LLVM 15.0.2
### conflicting types
make sure the function signature are the same for both declaration and definition, if not modify it

### unresolve symbol
Add following libs to ***vulkan_lvp***, ***osmesa*** and ***libgallium_wgl*** projects
`<LLVM INSTALL PREFIX>/lib/LLVMObjCARCOpts.lib`
`<LLVM INSTALL PREFIX>/lib/LLVMPasses.lib`

### lld unknown file type
Remove the `osmesa.sym` in linker option of ***osmesa***

# Use the batch files
Use the batch file to build
* `build_llvm.bat` needs admminstrator privilege

## Usage
### OpenGL
Place the Dlls (except the vulan_lvp.dll) to the application folder
Some environment varialbes can be overrided, e.g.
```
set MESA_GL_VERSION_OVERRIDE=4.6
set MESA_GLSL_VERSION_OVERRIDE=460
```
### Vulkan
Set environment variable

`set VK_ICD_FILENAMES=<INSTALL_PREFIX>\share\vulkan\icd.d\lvp_icd.x86_64.json`

Make sure the json file contains right path for dll
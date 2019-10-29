
## Instructions

Building SuiteSparse with static runtime and MKL:

1. Download and install [Intel MKL](https://software.intel.com/en-us/mkl) from the official website, or reuse existing files downloaded internally.

2. Copy the headers + precompiled libs in a folder called `mkl/` alongside this project, or update the CMake variable `MKL_ROOT` to point to your MKL installation. The default directory structure should look as follows:

    ```
    mkl/
        include/
            mkl.h
            ...
        lib/
            mkl_core.lib
            ...
    suitesparse/
    ```

3. Compile SuiteSparse using CMake as usual. Everything should work out of the box. Do not forget to build both in **Debug** and **Release** modes.

4. In Visual Studio, build the target `INSTALL`, and copy the content of the `<build>/install/` folder to the desired target folder.

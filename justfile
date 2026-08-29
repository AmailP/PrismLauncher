preset := env_var_or_default("CMAKE_PRESET", "macos")
build_type := env_var_or_default("BUILD_TYPE", "Debug")
ninja := env_var_or_default("NINJA", "ninja")
deployment_target := env_var_or_default("CMAKE_OSX_DEPLOYMENT_TARGET", "12")

_default:
    @just --list

configure:
    cmake --preset "{{preset}}" \
        -D CMAKE_MAKE_PROGRAM="{{ninja}}" \
        -D CMAKE_OSX_DEPLOYMENT_TARGET="{{deployment_target}}"

build: configure
    cmake --build --preset "{{preset}}" --config "{{build_type}}"

# Build and install the complete optimized Release application bundle.
release: configure
    cmake --build --preset "{{preset}}" --config "Release"
    cmake -E remove_directory "$PWD/install/PrismLauncher.app"
    cmake --install build --config "Release"
    codesign --force --deep --sign - "$PWD/install/PrismLauncher.app"
    codesign --verify --deep --strict "$PWD/install/PrismLauncher.app"
    @echo "$PWD/install/PrismLauncher.app"

run: build
    cmake -E copy_directory build/jars \
        "build/{{build_type}}/prismlauncher.app/Contents/MacOS/jars"
    build/{{build_type}}/prismlauncher.app/Contents/MacOS/prismlauncher \
        --dir "$PWD/build/dev-data"

test: build
    ctest --preset "{{preset}}" --build-config "{{build_type}}"

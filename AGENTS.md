# Repository Guidelines

## Project Structure & Module Organization

Prism Launcher is primarily a Qt/C++ application. Core launcher code lives in `launcher/`, grouped by domain such as `minecraft/`, `modplatform/`, `net/`, and `ui/`. Bundled C++ and Java components are under `libraries/`. Tests are in `tests/`, with fixtures in `tests/testdata/`. CMake helpers and dependency overrides live in `cmake/`; icons, metadata, and packaging assets live in `program_info/`. Automation is defined in `.github/workflows/`, while maintenance utilities are in `scripts/` and `tools/`.

## Build, Test, and Development Commands

The supported workflow uses CMake 3.28+ and Ninja Multi-Config. Choose the preset for your host (`linux`, `macos`, `macos_universal`, `windows_mingw`, or `windows_msvc`):

```sh
cmake --preset macos
cmake --build --preset macos --config Debug
ctest --preset macos --build-config Debug
```

The first command configures `build/`; the second compiles the launcher; the third runs all tests and reports failures. Use `ctest --test-dir build -R FileSystem --output-on-failure` for a focused test. Platform dependencies and API-key considerations are documented in the linked build instructions in `README.md`.

## Coding Style & Naming Conventions

Use four spaces, LF endings, and UTF-8; YAML and Nix files use two spaces. Format changed C++ files with `clang-format` using the repository `.clang-format`, and use `.clang-tidy` for static checks. Follow existing Qt/C++ patterns: `PascalCase` types and enum constants, `camelCase` functions and public fields, `m_camelCase` instance members, `s_camelCase` static members, and `SCREAMING_SNAKE_CASE` macros/constants. Avoid unrelated renames or broad formatting churn.

## Testing Guidelines

Tests use Qt Test through ECM/CMake. Add behavioral tests as `tests/Feature_test.cpp`, register them in `tests/CMakeLists.txt` with a concise `TEST_NAME`, and place reusable fixtures under `tests/testdata/Feature/`. Run the relevant test locally, then the full preset suite before submitting.

## Commits & Pull Requests

Recent commits favor short, imperative subjects, often with `fix:`, `change:`, or a scope such as `fix(JavaChecker): ...`. Keep each commit focused. Human contributors must sign off commits (`git commit -s`) for DCO compliance. Agents must never add `Signed-off-by`; AI-assisted work instead requires an `Assisted-by: AGENT_NAME:MODEL_VERSION` trailer, with the human reviewing and adding the legal sign-off. PRs should explain the problem and solution, link relevant issues, include screenshots for UI changes, and pass build, test, and clang-tidy checks.

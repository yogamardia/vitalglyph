# Contributing to VitalGlyph

Thank you for your interest in contributing to VitalGlyph! We welcome contributions from everyone. By participating in this project, you agree to abide by the [Code of Conduct](CODE_OF_CONDUCT.md).

## How Can I Contribute?

### Reporting Bugs
- Ensure the bug was not already reported by searching on GitHub under Issues.
- If you're unable to find an open issue addressing the problem, open a new one.
- Be sure to include a title and clear description, as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behavior that is not occurring.

### Suggesting Enhancements
- Open a new issue with a clear title and description.
- Explain why this enhancement would be useful to most users.
- You can also suggest enhancements by opening a Pull Request with the proposed changes.

### Pull Requests
1. Fork the repo and create your branch from `main`.
2. If you've added code that should be tested, add tests.
3. If you've changed APIs, update the documentation.
4. Ensure the test suite passes (`flutter test`).
5. Make sure your code passes the analyzer (`flutter analyze`).
6. Issue that pull request!

## Development Setup

1. **Install Flutter:** Make sure you have the Flutter SDK installed (version `^3.11.0`).
2. **Clone the repository:**
   ```bash
   git clone https://github.com/your-org/vitalglyph.git
   cd vitalglyph
   ```
3. **Install dependencies:**
   ```bash
   flutter pub get
   ```
4. **Generate code:**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
5. **Run tests:**
   ```bash
   flutter test
   ```

## Coding Style

- Use `very_good_analysis` lint rules (or what's specified in `analysis_options.yaml`).
- Format your code with `dart format`.
- Follow the Clean Architecture principles established in the project.

## License

By contributing, you agree that your contributions will be licensed under its MPL-2.0 License.
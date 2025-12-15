# Contributing to musubi

Thanks for your interest in contributing!

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/musubi.git`
3. Open `musubi.xcodeproj` in Xcode
4. Create a branch for your changes: `git checkout -b feature/your-feature`

## Development

- The project uses SwiftUI with MVVM architecture
- No external dependencies - pure Apple frameworks
- Target: macOS 15.0+

### Project Structure

```
musubi/
├── musubiApp.swift      # App entry point
├── Model/               # Data models
├── View/                # SwiftUI views
├── ViewModel/           # Business logic
└── UIHelpers/           # Reusable components
```

## Submitting Changes

1. Make sure your code builds without warnings
2. Test your changes on macOS
3. Commit with clear, descriptive messages
4. Push to your fork and open a Pull Request
5. Describe what your changes do and why

## Code Style

- Follow Swift conventions and SwiftUI best practices
- Keep views simple; put logic in ViewModels
- Use meaningful variable and function names

## Reporting Issues

- Check existing issues before opening a new one
- Include macOS version and steps to reproduce
- Screenshots help for UI issues

## Questions?

Open an issue or discussion if you have questions about contributing.

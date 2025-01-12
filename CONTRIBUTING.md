# Contributing to [Project Name]

Thank you for your interest in contributing to our project! We welcome contributions from everyone.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Environment](#development-environment)
- [Making Changes](#making-changes)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [Style Guide](#style-guide)
- [Community](#community)

## Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/your-username/project-name.git
   ```
3. Add the upstream remote:
   ```bash
   git remote add upstream https://github.com/original-owner/project-name.git
   ```

## Development Environment

1. Install required dependencies:
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh
   curl -L https://raw.githubusercontent.com/foundry-rs/starknet-foundry/master/scripts/install.sh | sh
   ```

2. Verify installation:
   ```bash
   scarb --version
   snforge --version
   ```
3. Install frontend dependencies
    ```bash
    npm install
    ```

4. Start the development server
    ```bash
    npm run dev
    ```

## Making Changes

1. Create a new branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```
   or 
   ```bash
   git checkout -b fix/issue-number
   ```


2. Make your changes

3. Follow the [Style Guide](#style-guide)

4. Commit your changes:
   ```bash
   git commit -m "Description of changes"
   ```

## Testing

Before submitting your changes, ensure:

1. All tests pass:
    /contracts
   ```bash
   snforge test
   ```

2. Code is formatted:
    /contracts
   ```bash
   scarb fmt
   ```
   /frontend
   ```bash
   prettier write .
   ```

## Pull Request Process

1. Update your fork:
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. Push your changes:
   ```bash
   git push origin feature/your-feature-name
   ```
   or
   ```bash
   git push origin fix/issue-number
   ```

3. Open a Pull Request with:
   - Clear title and description
   - Reference to related issues
   - Screenshots/GIFs if applicable
   - Updated documentation

4. Address review feedback

## Style Guide

### Cairo Code Style

- Follow the official [Cairo style guide](https://github.com/starkware-libs/cairo/blob/main/docs/reference/src/components/style-guide/introduction.md)
- Use meaningful variable names
- Add comments for complex logic
- Include docstrings for functions

### Commit Messages

- Use present tense ("Add feature" not "Added feature")
- First line should be:
  - Concise (50 chars or less)
  - Complete sentence
  - Capitalized

Example:
```
feat: add new component
fix: resolve button click issue
docs: update README
```

## Community

- Join our [Discord](link-to-discord)
- Follow us on [Twitter](link-to-twitter)
- Subscribe to our [Newsletter](link-to-newsletter)

## Questions?

Feel free to reach out to the maintainers or open an issue. We're here to help!
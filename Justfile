default:
    @just --list

build:
    cargo build --release

fmt:
    cargo fmt
    cargo clippy --all-targets --all-features -- -D warnings
    # cargo shear --fix # first install shear: cargo install shear

install-hook:
    #!/usr/bin/env bash
    cat > .git/hooks/pre-commit << 'EOF'
    #!/bin/sh

    # Pre-commit Quality Guard

    set -e
    echo "Running pre-commit quality checks..."

    # Step 1: Enforce formatting
    echo "Checking formatting (cargo fmt --check)..."
    cargo fmt --check

    # Step 2: Deny all warnings
    echo "Checking lints (cargo clippy -- -D warnings)..."
    cargo clippy -- -D warnings

    echo "Success! The code is clean. Proceeding with commit..."
    EOF
    chmod +x .git/hooks/pre-commit
    echo "Pre-commit hook installation confirmed."

remove-hook:
    rm .git/hooks/pre-commit
    echo "Pre-commit hook uninstallation confirmed."

# Run unit tests
test: fmt
    cargo test


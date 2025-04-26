.PHONY: format lint typecheck check all

# Format code using ruff
format:
	uv run ruff format

# Run ruff linter
lint:
	uv run ruff check

# Run pyright type checker
typecheck:
	uv run pyright

# Run all checks
check: format lint typecheck

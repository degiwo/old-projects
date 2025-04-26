.PHONY: format lint typecheck test check all

# Format code using ruff
format:
	uv run ruff format

# Run ruff linter
lint:
	uv run ruff check

# Run pyright type checker
typecheck:
	uv run pyright

# Run pytest
test:
	uv run pytest -v

# Run all checks
check: format lint typecheck test

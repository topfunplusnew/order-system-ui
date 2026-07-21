# Fund Change Template Export Implementation Plan

**Goal:** Add consistent XLSX export behavior to all fourteen fund change templates.

**Architecture:** A pure data builder creates detail and summary matrices. A shared Vue button calls the XLSX writer. Each business template only supplies its existing columns, processed rows, summary rows, label, and summary-only state.

### Task 1: Tests
- [x] Test detail headers and row mapping.
- [x] Test summary-only and empty-data behavior.
- [x] Test filename normalization.
- [x] Test all fourteen templates render the shared button.
- [x] Run tests and confirm failures are caused by missing implementation.

### Task 2: Shared export implementation
- [x] Create the pure export-data utility.
- [x] Create the XLSX writer and shared button.
- [x] Handle disabled, loading, success, and failure states.

### Task 3: Integrate templates
- [x] Import and register the shared button in all templates.
- [x] Render it above the current tables.
- [x] Pass columns, rows, summaries, labels, and summary-only state.
- [x] Add required top-of-file comments.

### Task 4: Verify
- [x] Run focused Jest tests.
- [x] Run targeted ESLint.
- [x] Run the staging build.
- [x] Run `git diff --check` and inspect worktree scope.

#!/bin/bash

#######################################################################
# Mermaid Diagram Validation Script
#
# This script validates all Mermaid diagrams in the repository to
# ensure they can be rendered properly on GitHub.
#
# Features:
# - Validates Mermaid syntax using mermaid-cli
# - Checks for common syntax errors
# - Generates validation report
# - Returns exit code 1 if any errors found
#
# Usage: ./scripts/validate-mermaid.sh
#######################################################################

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directories
MERMAID_DIR="mermaid-diagrams"
TEMP_DIR=$(mktemp -d)
REPORT_FILE="mermaid-validation-report.md"
ERROR_LOG="mermaid-validation-errors.log"

# Counters
TOTAL_FILES=0
PASSED_FILES=0
FAILED_FILES=0
WARNINGS=0

# Clean up on exit
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

#######################################################################
# Helper Functions
#######################################################################

log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✅${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

log_error() {
    echo -e "${RED}❌${NC} $1"
}

#######################################################################
# Validation Functions
#######################################################################

# Check if a file contains mermaid code blocks
has_mermaid_block() {
    local file="$1"
    grep -q '```mermaid' "$file"
}

# Extract mermaid code blocks from markdown
extract_mermaid_blocks() {
    local file="$1"
    local output_dir="$2"
    local basename=$(basename "$file" .md)
    local block_num=0

    # Extract each mermaid block
    awk '
        /```mermaid/ {
            in_block=1;
            block_num++;
            output_file="'"$output_dir"'/'"$basename"'-" block_num ".mmd"
            next
        }
        /```/ && in_block {
            in_block=0;
            next
        }
        in_block {
            print > output_file
        }
    ' "$file"
}

# Validate mermaid syntax using mermaid-cli
validate_mermaid_syntax() {
    local mermaid_file="$1"
    local output_file="$TEMP_DIR/output.png"

    # Run mermaid-cli to validate and render
    if mmdc -i "$mermaid_file" -o "$output_file" -b transparent 2>&1 | tee -a "$ERROR_LOG"; then
        return 0
    else
        return 1
    fi
}

# Check for common syntax errors
check_common_errors() {
    local file="$1"
    local errors=()

    # Extract mermaid blocks for checking
    local mermaid_content=$(awk '/```mermaid/,/```/' "$file")

    # Check for <br/> in edge labels (between --> and |)
    if echo "$mermaid_content" | grep -qE -- '-->.*\|[^"]*<br/>.*\|'; then
        errors+=("Found <br/> tag in edge label (not supported by GitHub)")
    fi

    # Check for unquoted parentheses in edge labels
    if echo "$mermaid_content" | grep -qE -- '-->.*\|[^"]*\([^"]*\).*\|'; then
        errors+=("Found unquoted parentheses in edge label")
    fi

    # Check for unquoted special characters
    if echo "$mermaid_content" | grep -qE -- '-->.*\|[^"]*[:/].*\|' && \
       ! echo "$mermaid_content" | grep -qE -- '-->.*\|".*".*\|'; then
        errors+=("Found unquoted special characters in edge label (colons/slashes should be quoted)")
    fi

    # Return errors if any
    if [ ${#errors[@]} -gt 0 ]; then
        printf '%s\n' "${errors[@]}"
        return 1
    fi
    return 0
}

#######################################################################
# Main Validation Logic
#######################################################################

main() {
    log_info "Starting Mermaid diagram validation..."
    echo ""

    # Initialize report
    cat > "$REPORT_FILE" << EOF
# Mermaid Diagram Validation Report

**Date**: $(date -u +"%Y-%m-%d %H:%M:%S UTC")
**Repository**: $GITHUB_REPOSITORY
**Commit**: ${GITHUB_SHA:-local}
**Branch**: ${GITHUB_REF_NAME:-local}

## Summary

EOF

    # Clear error log
    > "$ERROR_LOG"

    # Check if mermaid directory exists
    if [ ! -d "$MERMAID_DIR" ]; then
        log_error "Mermaid diagrams directory not found: $MERMAID_DIR"
        exit 1
    fi

    # Find all markdown files in mermaid directory
    mapfile -t files < <(find "$MERMAID_DIR" -name "*.md" -not -name "README.md" -not -name "VALIDATION.md" | sort)

    if [ ${#files[@]} -eq 0 ]; then
        log_warning "No Mermaid diagram files found"
        exit 0
    fi

    log_info "Found ${#files[@]} markdown files to validate"
    echo ""

    # Validate each file
    for file in "${files[@]}"; do
        TOTAL_FILES=$((TOTAL_FILES + 1))
        filename=$(basename "$file")

        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        log_info "Validating: $filename"

        # Check if file has mermaid blocks
        if ! has_mermaid_block "$file"; then
            log_warning "$filename: No mermaid code blocks found"
            WARNINGS=$((WARNINGS + 1))
            echo "  ⚠️  **WARNING**: No mermaid blocks" >> "$REPORT_FILE"
            continue
        fi

        # Track if this file has errors
        file_has_errors=false

        # Check for common syntax errors first
        echo "  → Checking for common syntax errors..."
        if error_messages=$(check_common_errors "$file" 2>&1); then
            log_success "No common syntax errors found"
        else
            log_error "Common syntax errors detected:"
            echo "$error_messages" | while IFS= read -r error; do
                log_error "  • $error"
                echo "- ❌ $error" >> "$ERROR_LOG"
            done
            file_has_errors=true
        fi

        # Extract and validate mermaid blocks
        echo "  → Extracting Mermaid blocks..."
        block_dir="$TEMP_DIR/$filename-blocks"
        mkdir -p "$block_dir"
        extract_mermaid_blocks "$file" "$block_dir"

        # Count blocks
        block_count=$(find "$block_dir" -name "*.mmd" 2>/dev/null | wc -l)

        if [ "$block_count" -eq 0 ]; then
            log_warning "No Mermaid blocks extracted (possible parsing issue)"
            WARNINGS=$((WARNINGS + 1))
            continue
        fi

        echo "  → Found $block_count Mermaid block(s)"

        # Validate each block
        block_errors=0
        for block_file in "$block_dir"/*.mmd; do
            block_name=$(basename "$block_file")
            echo "  → Validating block: $block_name"

            if validate_mermaid_syntax "$block_file"; then
                log_success "Block validated successfully"
            else
                log_error "Block validation failed"
                echo "**$filename** - $block_name: FAILED" >> "$ERROR_LOG"
                block_errors=$((block_errors + 1))
                file_has_errors=true
            fi
        done

        # Update counters and report
        if [ "$file_has_errors" = true ]; then
            FAILED_FILES=$((FAILED_FILES + 1))
            log_error "$filename: FAILED ($block_errors error(s))"
            echo "- ❌ **$filename**: FAILED ($block_errors error(s))" >> "$REPORT_FILE"
        else
            PASSED_FILES=$((PASSED_FILES + 1))
            log_success "$filename: PASSED"
            echo "- ✅ **$filename**: PASSED" >> "$REPORT_FILE"
        fi

        echo ""
    done

    # Generate final report
    echo "" >> "$REPORT_FILE"
    cat >> "$REPORT_FILE" << EOF

## Results

| Metric | Count |
|--------|-------|
| Total Files | $TOTAL_FILES |
| ✅ Passed | $PASSED_FILES |
| ❌ Failed | $FAILED_FILES |
| ⚠️  Warnings | $WARNINGS |

EOF

    if [ $FAILED_FILES -gt 0 ]; then
        cat >> "$REPORT_FILE" << EOF

## ❌ Validation Failed

$FAILED_FILES file(s) failed validation. Please review the errors above and fix the Mermaid syntax.

### Common Issues and Solutions

1. **Unquoted parentheses in edge labels**
   - ❌ \`A -->|text (B)| C\`
   - ✅ \`A -->|"text (B)"| C\`

2. **\`<br/>\` tags in edge labels**
   - ❌ \`A -->|line1<br/>line2| B\`
   - ✅ \`A -->|"line1 line2"| B\`
   - ℹ️  Use \`<br/>\` only in node labels, not edge labels

3. **Unquoted special characters**
   - ❌ \`A -->|path/to/resource| B\`
   - ✅ \`A -->|"path/to/resource"| B\`

### Resources

- [Mermaid Documentation](https://mermaid.js.org/)
- [GitHub Mermaid Support](https://github.blog/2022-02-14-include-diagrams-markdown-files-mermaid/)
- [Mermaid Live Editor](https://mermaid.live/) - Test your diagrams

EOF
    else
        cat >> "$REPORT_FILE" << EOF

## ✅ All Validations Passed!

All Mermaid diagrams are valid and ready for GitHub rendering.

EOF
    fi

    # Print summary
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    log_info "Validation Summary"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Total Files:    $TOTAL_FILES"
    echo "  ✅ Passed:      $PASSED_FILES"
    echo "  ❌ Failed:      $FAILED_FILES"
    echo "  ⚠️  Warnings:   $WARNINGS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Display report location
    log_info "Validation report saved to: $REPORT_FILE"
    if [ -s "$ERROR_LOG" ]; then
        log_info "Error log saved to: $ERROR_LOG"
    fi
    echo ""

    # Exit with error if any files failed
    if [ $FAILED_FILES -gt 0 ]; then
        log_error "Validation failed! Please fix the errors and try again."
        exit 1
    else
        log_success "All Mermaid diagrams validated successfully!"
        exit 0
    fi
}

#######################################################################
# Script Entry Point
#######################################################################

# Check for required commands
if ! command -v mmdc &> /dev/null; then
    log_error "mermaid-cli (mmdc) is not installed"
    log_info "Install with: npm install -g @mermaid-js/mermaid-cli"
    exit 1
fi

# Run main function
main "$@"

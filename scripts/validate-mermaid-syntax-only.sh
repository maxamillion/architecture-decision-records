#!/bin/bash

#######################################################################
# Simplified Mermaid Syntax Checker (No CLI Required)
#
# This script checks for common Mermaid syntax errors without
# requiring mermaid-cli installation. Use for quick local checks.
#
# Usage: ./scripts/validate-mermaid-syntax-only.sh
#######################################################################

set -euo pipefail

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

MERMAID_DIR="mermaid-diagrams"
TOTAL_FILES=0
PASSED_FILES=0
FAILED_FILES=0

log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✅${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠️${NC} $1"; }
log_error() { echo -e "${RED}❌${NC} $1"; }

# Check for common syntax errors
check_syntax_errors() {
    local file="$1"
    local errors=()

    # Extract mermaid blocks
    local mermaid_content=$(sed -n '/```mermaid/,/```/p' "$file")

    # Check for <br/> in edge labels
    if echo "$mermaid_content" | grep -qE -- '-->.*\|[^"]*<br/>.*\|'; then
        errors+=("Found <br/> tag in edge label (line $(grep -n '<br/>' "$file" | head -1 | cut -d: -f1))")
    fi

    # Check for unquoted parentheses in edge labels
    while IFS= read -r line; do
        if echo "$line" | grep -qE -- '-->.*\|[^"]*\([^"]*\).*\|'; then
            if ! echo "$line" | grep -q '|"'; then
                line_num=$(grep -n "$line" "$file" | head -1 | cut -d: -f1)
                errors+=("Unquoted parentheses in edge label (line $line_num)")
            fi
        fi
    done <<< "$mermaid_content"

    # Return errors if any
    if [ ${#errors[@]} -gt 0 ]; then
        printf '%s\n' "${errors[@]}"
        return 1
    fi
    return 0
}

main() {
    log_info "Running simplified Mermaid syntax check..."
    echo ""

    # Find markdown files
    mapfile -t files < <(find "$MERMAID_DIR" -name "*.md" -not -name "README.md" -not -name "VALIDATION.md" -not -name "CONTRIBUTING.md" | sort)

    if [ ${#files[@]} -eq 0 ]; then
        log_warning "No Mermaid diagram files found"
        exit 0
    fi

    log_info "Found ${#files[@]} files to check"
    echo ""

    # Check each file
    for file in "${files[@]}"; do
        TOTAL_FILES=$((TOTAL_FILES + 1))
        filename=$(basename "$file")

        printf "Checking: %-50s " "$filename"

        if ! grep -q '```mermaid' "$file"; then
            echo -e "${YELLOW}⚠️  SKIP (no mermaid)${NC}"
            continue
        fi

        if error_msg=$(check_syntax_errors "$file" 2>&1); then
            echo -e "${GREEN}✅ PASS${NC}"
            PASSED_FILES=$((PASSED_FILES + 1))
        else
            echo -e "${RED}❌ FAIL${NC}"
            echo "$error_msg" | while IFS= read -r error; do
                echo "    ${RED}•${NC} $error"
            done
            FAILED_FILES=$((FAILED_FILES + 1))
        fi
    done

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Summary"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Total: $TOTAL_FILES | Passed: $PASSED_FILES | Failed: $FAILED_FILES"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    if [ $FAILED_FILES -gt 0 ]; then
        log_error "Syntax check failed!"
        exit 1
    else
        log_success "All syntax checks passed!"
        exit 0
    fi
}

main "$@"

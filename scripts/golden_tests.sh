#!/bin/bash

# Golden Tests Helper Script
# Facilitates running and updating golden tests

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

# Display usage
usage() {
    print_header "Golden Tests Helper"
    echo ""
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  run              Run all golden tests"
    echo "  run-screens      Run screen golden tests only"
    echo "  run-widgets      Run widget golden tests only"
    echo "  update           Update all golden images"
    echo "  update-screens   Update screen golden images only"
    echo "  update-widgets   Update widget golden images only"
    echo "  diff             Show git diff of golden images"
    echo "  clean            Clean test cache"
    echo "  help             Display this help message"
    echo ""
    echo "Examples:"
    echo "  $0 run                    # Run all golden tests"
    echo "  $0 update-widgets         # Update widget goldens only"
    echo "  $0 diff                   # View changes to golden files"
    echo ""
}

# Run golden tests
run_tests() {
    local path=$1
    local description=$2
    
    print_header "Running $description"
    
    if flutter test "$path"; then
        print_success "$description passed!"
        return 0
    else
        print_error "$description failed!"
        return 1
    fi
}

# Update golden files
update_goldens() {
    local path=$1
    local description=$2
    
    print_header "Updating $description"
    print_warning "This will overwrite existing golden images!"
    
    if flutter test --update-goldens "$path"; then
        print_success "$description updated!"
        print_info "Please review the changes with: $0 diff"
        return 0
    else
        print_error "Failed to update $description!"
        return 1
    fi
}

# Show diff
show_diff() {
    print_header "Golden Files Diff"
    
    if git diff --name-only | grep -q "test/goldens.*\.png"; then
        echo ""
        print_warning "The following golden files have changed:"
        echo ""
        git diff --name-only | grep "test/goldens.*\.png"
        echo ""
        print_info "To see visual diff, use: git diff test/goldens/"
        echo ""
        print_info "To review changes in detail:"
        echo "  - Stage changes: git add test/goldens/"
        echo "  - Discard changes: git checkout test/goldens/"
    else
        print_success "No changes to golden files"
    fi
}

# Clean test cache
clean_cache() {
    print_header "Cleaning Test Cache"
    
    if flutter clean && flutter pub get; then
        print_success "Test cache cleaned!"
    else
        print_error "Failed to clean cache!"
        return 1
    fi
}

# Main script
case "${1:-help}" in
    run)
        run_tests "test/goldens/all_golden_tests.dart" "All Golden Tests"
        ;;
    run-screens)
        run_tests "test/goldens/screens/" "Screen Golden Tests"
        ;;
    run-widgets)
        run_tests "test/goldens/widgets/" "Widget Golden Tests"
        ;;
    update)
        update_goldens "test/goldens/all_golden_tests.dart" "All Golden Images"
        ;;
    update-screens)
        update_goldens "test/goldens/screens/" "Screen Golden Images"
        ;;
    update-widgets)
        update_goldens "test/goldens/widgets/" "Widget Golden Images"
        ;;
    diff)
        show_diff
        ;;
    clean)
        clean_cache
        ;;
    help|--help|-h)
        usage
        ;;
    *)
        print_error "Unknown command: $1"
        echo ""
        usage
        exit 1
        ;;
esac

exit 0


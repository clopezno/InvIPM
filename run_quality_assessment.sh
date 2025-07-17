#!/bin/bash

# MATLAB Code Quality Assessment Runner
# Comprehensive script to analyze code quality and generate reports

set -e

# Configuration
DEFAULT_TARGET="appcode/code"
DEFAULT_CONFIG="quality_config.json"
REPORTS_DIR="quality_reports"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    echo "MATLAB Code Quality Assessment Runner"
    echo "======================================"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -t, --target DIR     Target directory to analyze (default: $DEFAULT_TARGET)"
    echo "  -c, --config FILE    Configuration file (default: $DEFAULT_CONFIG)"
    echo "  -o, --output PREFIX  Output file prefix (default: quality_report_$TIMESTAMP)"
    echo "  -f, --format FORMAT  Report format: json,txt,html,all (default: all)"
    echo "  -h, --help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Analyze default directory with all formats"
    echo "  $0 -t src -f html                    # Analyze 'src' directory, HTML report only"
    echo "  $0 -c custom_config.json -o report   # Use custom config and output prefix"
    echo ""
}

# Parse command line arguments
TARGET_DIR="$DEFAULT_TARGET"
CONFIG_FILE="$DEFAULT_CONFIG"
OUTPUT_PREFIX="quality_report_$TIMESTAMP"
FORMATS="all"

while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--target)
            TARGET_DIR="$2"
            shift 2
            ;;
        -c|--config)
            CONFIG_FILE="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_PREFIX="$2"
            shift 2
            ;;
        -f|--format)
            FORMATS="$2"
            shift 2
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Validate inputs
if [[ ! -d "$TARGET_DIR" ]]; then
    print_error "Target directory '$TARGET_DIR' does not exist"
    exit 1
fi

if [[ ! -f "code_quality_analyzer.py" ]]; then
    print_error "code_quality_analyzer.py not found in current directory"
    exit 1
fi

# Create reports directory
mkdir -p "$REPORTS_DIR"

print_status "MATLAB Code Quality Assessment"
print_status "==============================="
print_status "Target Directory: $TARGET_DIR"
print_status "Configuration: $CONFIG_FILE"
print_status "Output Prefix: $OUTPUT_PREFIX"
print_status "Formats: $FORMATS"
print_status ""

# Build analyzer command
ANALYZER_CMD="python code_quality_analyzer.py '$TARGET_DIR'"

if [[ -f "$CONFIG_FILE" ]]; then
    ANALYZER_CMD="$ANALYZER_CMD -c '$CONFIG_FILE'"
    print_status "Using configuration file: $CONFIG_FILE"
else
    print_warning "Configuration file '$CONFIG_FILE' not found, using defaults"
fi

# Generate reports based on requested formats
case $FORMATS in
    json)
        JSON_FILE="$REPORTS_DIR/${OUTPUT_PREFIX}.json"
        print_status "Generating JSON report..."
        eval "$ANALYZER_CMD -o '$JSON_FILE' -f json"
        print_success "JSON report saved: $JSON_FILE"
        ;;
    txt)
        TXT_FILE="$REPORTS_DIR/${OUTPUT_PREFIX}.txt"
        print_status "Generating text report..."
        eval "$ANALYZER_CMD -o '$TXT_FILE' -f txt"
        print_success "Text report saved: $TXT_FILE"
        ;;
    html)
        JSON_FILE="$REPORTS_DIR/${OUTPUT_PREFIX}.json"
        HTML_FILE="$REPORTS_DIR/${OUTPUT_PREFIX}.html"
        print_status "Generating HTML report..."
        eval "$ANALYZER_CMD -o '$JSON_FILE' -f json"
        python html_report_generator.py "$JSON_FILE" "$HTML_FILE"
        print_success "HTML report saved: $HTML_FILE"
        ;;
    all)
        JSON_FILE="$REPORTS_DIR/${OUTPUT_PREFIX}.json"
        TXT_FILE="$REPORTS_DIR/${OUTPUT_PREFIX}.txt"
        HTML_FILE="$REPORTS_DIR/${OUTPUT_PREFIX}.html"
        
        print_status "Generating JSON report..."
        eval "$ANALYZER_CMD -o '$JSON_FILE' -f json"
        print_success "JSON report saved: $JSON_FILE"
        
        print_status "Generating text report..."
        eval "$ANALYZER_CMD -o '$TXT_FILE' -f txt"
        print_success "Text report saved: $TXT_FILE"
        
        print_status "Generating HTML report..."
        python html_report_generator.py "$JSON_FILE" "$HTML_FILE"
        print_success "HTML report saved: $HTML_FILE"
        ;;
    *)
        print_error "Invalid format '$FORMATS'. Use: json, txt, html, or all"
        exit 1
        ;;
esac

# Display summary from the latest JSON report
if [[ -f "$JSON_FILE" ]]; then
    print_status ""
    print_status "Quality Assessment Summary:"
    print_status "=========================="
    
    # Extract key metrics using python
    python3 << EOF
import json
try:
    with open('$JSON_FILE', 'r') as f:
        report = json.load(f)
    
    summary = report['summary']
    smells = report['code_smells']
    
    print(f"Files Analyzed: {summary['total_files']}")
    print(f"Lines of Code: {summary['total_lines_of_code']:,}")
    print(f"Total Functions: {summary['total_functions']}")
    print(f"Quality Score: {summary['quality_score']}/100")
    print(f"Quality Issues: {smells['total']} (High: {smells['by_severity']['high']}, Medium: {smells['by_severity']['medium']}, Low: {smells['by_severity']['low']})")
    
    # Quality assessment
    score = summary['quality_score']
    if score >= 80:
        print("\\n🎉 Excellent code quality! Ready for production.")
    elif score >= 60:
        print("\\n✅ Good code quality with minor improvements needed.")
    elif score >= 40:
        print("\\n⚠️  Moderate code quality. Significant improvements recommended.")
    else:
        print("\\n🚨 Poor code quality. Major refactoring needed.")
        
except Exception as e:
    print(f"Error reading report: {e}")
EOF
fi

print_status ""
print_success "Quality assessment completed!"

# Offer to open HTML report
if [[ -f "$HTML_FILE" && "$FORMATS" =~ (html|all) ]]; then
    print_status ""
    print_status "To view the HTML report, open: $HTML_FILE"
    
    # Try to open automatically on supported systems
    if command -v xdg-open > /dev/null 2>&1; then
        read -p "Open HTML report now? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            xdg-open "$HTML_FILE"
        fi
    elif command -v open > /dev/null 2>&1; then
        read -p "Open HTML report now? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            open "$HTML_FILE"
        fi
    fi
fi

print_status ""
print_status "All reports saved in: $REPORTS_DIR/"
print_success "Quality assessment workflow completed successfully!"
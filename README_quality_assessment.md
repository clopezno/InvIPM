# MATLAB Code Quality Assessment System

This system provides comprehensive code quality analysis for MATLAB projects, specifically designed for the InvIPM image segmentation project. It analyzes MATLAB source code to identify code metrics, detect code smells, and provide actionable recommendations for improving code quality.

## Features

### 🔍 Code Metrics Analysis
- **Lines of Code (LOC)** - Count of executable code lines
- **Comment Ratio** - Percentage of comments vs total lines
- **Cyclomatic Complexity** - Measure of code complexity based on decision points
- **Function Metrics** - Function count, length, and parameter analysis
- **Nesting Depth** - Maximum depth of nested control structures
- **Magic Numbers Detection** - Identification of hardcoded numeric values

### 🚨 Code Smell Detection
- **Long Functions** - Functions exceeding recommended length
- **Too Many Parameters** - Functions with excessive parameter counts
- **Deep Nesting** - Code with excessive nesting levels
- **High Complexity** - Code with high cyclomatic complexity
- **Insufficient Comments** - Files with low comment ratios
- **Magic Numbers** - Hardcoded values that should be constants

### 📊 Reporting
- **JSON Reports** - Machine-readable detailed analysis results
- **Text Reports** - Human-readable summary reports
- **HTML Reports** - Interactive web-based quality dashboards
- **Quality Score** - Overall quality score (0-100) with recommendations

## Installation & Usage

### Prerequisites
- Python 3.6 or higher
- No additional dependencies required (uses only Python standard library)

### Basic Usage

```bash
# Analyze a directory of MATLAB files
python code_quality_analyzer.py <directory> -o report.json

# Generate different report formats
python code_quality_analyzer.py appcode/code -o quality_report.json -f json
python code_quality_analyzer.py appcode/code -o quality_report.txt -f txt

# Use custom configuration
python code_quality_analyzer.py appcode/code -c quality_config.json -o report.json

# Generate HTML report from JSON
python html_report_generator.py quality_report.json
```

### Configuration

Create a `quality_config.json` file to customize quality thresholds:

```json
{
  "max_function_length": 50,
  "max_parameters": 5,
  "max_nesting_depth": 4,
  "max_cyclomatic_complexity": 10,
  "min_comment_ratio": 0.1,
  "magic_number_threshold": 3,
  "naming_conventions": {
    "functions": "^[a-z][a-zA-Z0-9_]*$",
    "variables": "^[a-z][a-zA-Z0-9_]*$"
  }
}
```

## Quality Metrics Explained

### Cyclomatic Complexity
Measures the number of linearly independent paths through the code. Higher values indicate more complex, harder-to-test code.

- **1-10**: Simple, low risk
- **11-20**: Moderate complexity
- **21+**: High complexity, difficult to test

### Function Length
Long functions are harder to understand and maintain. Recommended maximum is 50 lines.

### Nesting Depth
Deep nesting makes code harder to read and understand. Recommended maximum depth is 4 levels.

### Comment Ratio
Good code should have adequate comments explaining complex logic. Recommended minimum is 10%.

## Code Smell Categories

### 🔴 High Severity
- **Deep Nesting**: Excessive nesting levels that hurt readability
- **High Complexity**: Code that's difficult to understand and test

### 🟡 Medium Severity
- **Long Functions**: Functions that should be broken down
- **Too Many Parameters**: Functions with parameter lists that are too long
- **Magic Numbers**: Hardcoded values that should be named constants

### 🟢 Low Severity
- **Insufficient Comments**: Missing documentation that would improve clarity

## Analysis Results for InvIPM Project

### Current Quality Assessment
- **Files Analyzed**: 34 MATLAB files
- **Total Lines of Code**: 620
- **Quality Score**: 6/100 (Needs Improvement)
- **Issues Found**: 28 quality issues

### Key Findings
1. **Comment Coverage**: 17 files need better documentation
2. **Magic Numbers**: 9 files contain hardcoded values
3. **Code Complexity**: Generally acceptable with room for improvement

### Recommendations
1. Add comprehensive comments to all functions explaining purpose and parameters
2. Replace magic numbers with named constants for better maintainability
3. Consider breaking down the largest functions into smaller, focused units
4. Implement consistent naming conventions across the codebase

## Integration with Development Workflow

### Continuous Quality Assessment
```bash
# Add to your development workflow
./run_quality_check.sh

# Example script content:
python code_quality_analyzer.py appcode/code -o reports/quality_$(date +%Y%m%d).json
python html_report_generator.py reports/quality_$(date +%Y%m%d).json
```

### Quality Gates
Use the quality score to establish quality gates:
- **80-100**: Excellent quality, ready for production
- **60-79**: Good quality, minor improvements needed
- **40-59**: Moderate quality, significant improvements recommended
- **0-39**: Poor quality, major refactoring needed

## File Structure

```
├── code_quality_analyzer.py      # Main analyzer script
├── html_report_generator.py      # HTML report generator
├── test_analyzer.py              # Test suite for the analyzer
├── quality_config.json           # Configuration file
├── matlab_quality_report.json    # Analysis results (JSON)
├── matlab_quality_report.txt     # Analysis results (text)
├── matlab_quality_report.html    # Analysis results (HTML)
└── README_quality_assessment.md  # This documentation
```

## Technical Details

### MATLAB Code Parsing
The analyzer uses regular expressions and text processing to parse MATLAB code:
- Function detection and parameter counting
- Control flow analysis for complexity calculation
- Comment and blank line identification
- Magic number detection with common exclusions

### Quality Score Calculation
The quality score is calculated based on:
- Number and severity of detected code smells
- Normalized by the total number of files
- Weighted by issue severity (High: -10, Medium: -5, Low: -2)

### Extensibility
The system is designed to be easily extensible:
- Add new code smell detectors in the `_detect_code_smells` method
- Implement additional metrics in the `_calculate_metrics` method
- Customize reporting formats by extending the report generators

## Limitations

1. **Static Analysis Only**: Does not execute code or analyze runtime behavior
2. **MATLAB-Specific**: Designed specifically for MATLAB syntax and conventions
3. **Text-Based Parsing**: May miss some subtle code patterns
4. **Configuration Dependent**: Quality thresholds may need adjustment for different projects

## Future Enhancements

1. **Advanced Metrics**: Add more sophisticated complexity metrics
2. **IDE Integration**: Develop plugins for MATLAB editor
3. **Trend Analysis**: Track quality improvements over time
4. **Team Metrics**: Multi-developer quality tracking
5. **Automated Fixes**: Suggest and apply automatic code improvements

## Contributing

To contribute improvements to the quality assessment system:

1. Add new metrics in the `MatlabCodeAnalyzer` class
2. Implement additional code smell detectors
3. Enhance reporting formats and visualizations
4. Improve MATLAB code parsing accuracy
5. Add comprehensive test cases

## License

This code quality assessment system is part of the InvIPM project and follows the same BSD 3-Clause License.
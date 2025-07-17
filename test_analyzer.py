#!/usr/bin/env python3
"""
Test script for the MATLAB Code Quality Analyzer
"""

import os
import sys
import json
import tempfile
from pathlib import Path

# Add the current directory to Python path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from code_quality_analyzer import MatlabCodeAnalyzer, CodeMetrics, CodeSmell


def create_test_matlab_file(content: str) -> str:
    """Create a temporary MATLAB file with the given content."""
    with tempfile.NamedTemporaryFile(mode='w', suffix='.m', delete=False) as f:
        f.write(content)
        return f.name


def test_basic_metrics():
    """Test basic metrics calculation."""
    print("Testing basic metrics calculation...")
    
    matlab_code = """
function result = test_function(param1, param2, param3)
    % This is a test function
    % It demonstrates various code patterns
    
    if param1 > 10
        for i = 1:100
            if param2 == 42
                result = param3 * 255;
            else
                result = param3 / 3.14159;
            end
        end
    else
        result = 0;
    end
end
"""
    
    analyzer = MatlabCodeAnalyzer()
    temp_file = create_test_matlab_file(matlab_code)
    
    try:
        analyzer._analyze_file(temp_file)
        
        if analyzer.metrics:
            metrics = analyzer.metrics[0]
            print(f"✓ Lines of code: {metrics.lines_of_code}")
            print(f"✓ Comment lines: {metrics.comment_lines}")
            print(f"✓ Functions: {metrics.function_count}")
            print(f"✓ Max parameters: {metrics.max_parameters}")
            print(f"✓ Cyclomatic complexity: {metrics.cyclomatic_complexity}")
            print(f"✓ Max nesting depth: {metrics.max_nesting_depth}")
            print(f"✓ Magic numbers: {metrics.magic_numbers}")
            
            # Verify some expected values
            assert metrics.function_count == 1, f"Expected 1 function, got {metrics.function_count}"
            assert metrics.max_parameters == 3, f"Expected 3 parameters, got {metrics.max_parameters}"
            assert metrics.comment_lines >= 2, f"Expected at least 2 comment lines, got {metrics.comment_lines}"
            
            print("✓ Basic metrics test passed!")
        else:
            print("✗ No metrics generated")
            
    finally:
        os.unlink(temp_file)


def test_code_smells():
    """Test code smell detection."""
    print("\nTesting code smell detection...")
    
    # Create code with intentional smells
    bad_matlab_code = """
function result = bad_function(a, b, c, d, e, f, g, h)
    if a > 0
        if b > 0
            if c > 0
                if d > 0
                    if e > 0
                        result = 12345 + 67890 + 11111;
                    end
                end
            end
        end
    end
    for i = 1:1000
        for j = 1:100
            for k = 1:50
                result = result + 999;
            end
        end
    end
end
"""
    
    analyzer = MatlabCodeAnalyzer()
    temp_file = create_test_matlab_file(bad_matlab_code)
    
    try:
        analyzer._analyze_file(temp_file)
        
        print(f"✓ Detected {len(analyzer.code_smells)} code smells:")
        for smell in analyzer.code_smells:
            print(f"  - {smell.type} ({smell.severity}): {smell.description}")
        
        # Should detect several smells
        smell_types = [smell.type for smell in analyzer.code_smells]
        expected_smells = ['too_many_parameters', 'deep_nesting', 'magic_numbers']
        
        for expected in expected_smells:
            if expected in smell_types:
                print(f"✓ Correctly detected {expected}")
            else:
                print(f"✗ Failed to detect {expected}")
                
        print("✓ Code smell detection test completed!")
        
    finally:
        os.unlink(temp_file)


def test_real_codebase():
    """Test the analyzer on the actual MATLAB codebase."""
    print("\nTesting on real codebase...")
    
    matlab_dir = "/home/runner/work/InvIPM/InvIPM/appcode/code/functions"
    
    if not os.path.exists(matlab_dir):
        print(f"✗ MATLAB directory not found: {matlab_dir}")
        return
    
    analyzer = MatlabCodeAnalyzer()
    report = analyzer.analyze_directory(matlab_dir)
    
    print(f"✓ Analyzed {report['summary']['total_files']} files")
    print(f"✓ Total lines of code: {report['summary']['total_lines_of_code']}")
    print(f"✓ Quality score: {report['summary']['quality_score']}/100")
    print(f"✓ Found {report['code_smells']['total']} code quality issues")
    
    # Save a test report
    with open('/home/runner/work/InvIPM/InvIPM/test_quality_report.json', 'w') as f:
        json.dump(report, f, indent=2)
    
    print("✓ Real codebase test completed!")
    print("✓ Test report saved as test_quality_report.json")


def main():
    """Run all tests."""
    print("MATLAB Code Quality Analyzer - Test Suite")
    print("=" * 50)
    
    try:
        test_basic_metrics()
        test_code_smells()
        test_real_codebase()
        
        print("\n" + "=" * 50)
        print("✓ All tests completed successfully!")
        
    except Exception as e:
        print(f"\n✗ Test failed with error: {e}")
        return 1
    
    return 0


if __name__ == '__main__':
    sys.exit(main())
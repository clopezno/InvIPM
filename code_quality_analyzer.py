#!/usr/bin/env python3
"""
MATLAB Code Quality Analyzer
============================

A comprehensive tool for analyzing MATLAB code quality, calculating metrics,
and detecting code smells to improve code maintainability and readability.

Author: Code Quality Assessment System
"""

import os
import re
import json
import argparse
from typing import Dict, List, Tuple, Optional, Any
from dataclasses import dataclass, asdict
from pathlib import Path
import datetime


@dataclass
class CodeMetrics:
    """Data class to store code metrics for a single file."""
    file_path: str
    lines_of_code: int
    comment_lines: int
    blank_lines: int
    cyclomatic_complexity: int
    function_count: int
    max_function_length: int
    max_parameters: int
    max_nesting_depth: int
    magic_numbers: List[int]
    
    
@dataclass
class CodeSmell:
    """Data class to represent a detected code smell."""
    type: str
    severity: str  # 'low', 'medium', 'high'
    file_path: str
    line_number: int
    function_name: str
    description: str
    suggestion: str


class MatlabCodeAnalyzer:
    """Main analyzer class for MATLAB code quality assessment."""
    
    def __init__(self, config: Optional[Dict] = None):
        """Initialize the analyzer with configuration."""
        self.config = config or self._default_config()
        self.metrics: List[CodeMetrics] = []
        self.code_smells: List[CodeSmell] = []
        
    def _default_config(self) -> Dict:
        """Return default configuration for code quality thresholds."""
        return {
            'max_function_length': 50,
            'max_parameters': 5,
            'max_nesting_depth': 4,
            'max_cyclomatic_complexity': 10,
            'min_comment_ratio': 0.1,
            'magic_number_threshold': 3,
            'naming_conventions': {
                'functions': r'^[a-z][a-zA-Z0-9_]*$',
                'variables': r'^[a-z][a-zA-Z0-9_]*$'
            }
        }
    
    def analyze_directory(self, directory_path: str) -> Dict[str, Any]:
        """Analyze all MATLAB files in a directory recursively."""
        matlab_files = []
        for root, _, files in os.walk(directory_path):
            for file in files:
                if file.endswith('.m'):
                    matlab_files.append(os.path.join(root, file))
        
        for file_path in matlab_files:
            self._analyze_file(file_path)
        
        return self._generate_report()
    
    def _analyze_file(self, file_path: str) -> None:
        """Analyze a single MATLAB file."""
        try:
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
            
            metrics = self._calculate_metrics(file_path, content)
            self.metrics.append(metrics)
            
            smells = self._detect_code_smells(file_path, content, metrics)
            self.code_smells.extend(smells)
            
        except Exception as e:
            print(f"Error analyzing {file_path}: {e}")
    
    def _calculate_metrics(self, file_path: str, content: str) -> CodeMetrics:
        """Calculate various code metrics for a file."""
        lines = content.split('\n')
        
        # Basic line counts
        lines_of_code = 0
        comment_lines = 0
        blank_lines = 0
        
        for line in lines:
            stripped = line.strip()
            if not stripped:
                blank_lines += 1
            elif stripped.startswith('%'):
                comment_lines += 1
            else:
                lines_of_code += 1
        
        # Function analysis
        functions = self._extract_functions(content)
        function_count = len(functions)
        max_function_length = max((f['length'] for f in functions), default=0)
        max_parameters = max((f['param_count'] for f in functions), default=0)
        
        # Complexity and nesting
        cyclomatic_complexity = self._calculate_cyclomatic_complexity(content)
        max_nesting_depth = self._calculate_max_nesting_depth(content)
        
        # Magic numbers
        magic_numbers = self._find_magic_numbers(content)
        
        return CodeMetrics(
            file_path=file_path,
            lines_of_code=lines_of_code,
            comment_lines=comment_lines,
            blank_lines=blank_lines,
            cyclomatic_complexity=cyclomatic_complexity,
            function_count=function_count,
            max_function_length=max_function_length,
            max_parameters=max_parameters,
            max_nesting_depth=max_nesting_depth,
            magic_numbers=magic_numbers
        )
    
    def _extract_functions(self, content: str) -> List[Dict]:
        """Extract function information from MATLAB code."""
        functions = []
        lines = content.split('\n')
        
        for i, line in enumerate(lines):
            # Match function declarations
            func_match = re.match(r'\s*function\s+(?:\[.*?\]\s*=\s*|\w+\s*=\s*)?(\w+)\s*\((.*?)\)', line)
            if func_match:
                func_name = func_match.group(1)
                params = func_match.group(2)
                param_count = len([p.strip() for p in params.split(',') if p.strip()]) if params.strip() else 0
                
                # Calculate function length
                func_length = self._calculate_function_length(lines, i)
                
                functions.append({
                    'name': func_name,
                    'line': i + 1,
                    'param_count': param_count,
                    'length': func_length
                })
        
        return functions
    
    def _calculate_function_length(self, lines: List[str], start_idx: int) -> int:
        """Calculate the length of a function starting at the given line."""
        length = 1
        nesting_level = 0
        
        for i in range(start_idx + 1, len(lines)):
            line = lines[i].strip()
            
            # Count control structures that increase nesting
            if re.match(r'\s*(if|for|while|switch|try|function)\b', line):
                nesting_level += 1
            elif re.match(r'\s*end\b', line):
                if nesting_level == 0:
                    break
                nesting_level -= 1
            
            length += 1
        
        return length
    
    def _calculate_cyclomatic_complexity(self, content: str) -> int:
        """Calculate cyclomatic complexity of the code."""
        # Start with 1 for the basic path
        complexity = 1
        
        # Count decision points
        decision_keywords = ['if', 'elseif', 'while', 'for', 'case', 'catch', '&&', '||']
        
        for keyword in decision_keywords:
            if keyword in ['&&', '||']:
                # Count logical operators
                complexity += content.count(keyword)
            else:
                # Count control flow keywords
                pattern = r'\b' + keyword + r'\b'
                complexity += len(re.findall(pattern, content, re.IGNORECASE))
        
        return complexity
    
    def _calculate_max_nesting_depth(self, content: str) -> int:
        """Calculate maximum nesting depth in the code."""
        lines = content.split('\n')
        max_depth = 0
        current_depth = 0
        
        for line in lines:
            stripped = line.strip()
            
            # Increase depth for control structures
            if re.match(r'\s*(if|for|while|switch|try|function)\b', stripped):
                current_depth += 1
                max_depth = max(max_depth, current_depth)
            elif stripped == 'end':
                current_depth = max(0, current_depth - 1)
        
        return max_depth
    
    def _find_magic_numbers(self, content: str) -> List[int]:
        """Find magic numbers in the code."""
        # Find all numeric literals
        number_pattern = r'\b(\d+(?:\.\d+)?)\b'
        numbers = re.findall(number_pattern, content)
        
        # Filter out common non-magic numbers
        magic_numbers = []
        excluded = {'0', '1', '2', '3', '10', '100', '255'}
        
        for num_str in numbers:
            if num_str not in excluded:
                try:
                    num = int(float(num_str))
                    if num not in magic_numbers:
                        magic_numbers.append(num)
                except ValueError:
                    pass
        
        return magic_numbers
    
    def _detect_code_smells(self, file_path: str, content: str, metrics: CodeMetrics) -> List[CodeSmell]:
        """Detect various code smells in the file."""
        smells = []
        
        # Long function smell
        if metrics.max_function_length > self.config['max_function_length']:
            smells.append(CodeSmell(
                type='long_function',
                severity='medium',
                file_path=file_path,
                line_number=1,
                function_name='',
                description=f'Function has {metrics.max_function_length} lines (max: {self.config["max_function_length"]})',
                suggestion='Consider breaking down large functions into smaller, more focused functions'
            ))
        
        # Too many parameters
        if metrics.max_parameters > self.config['max_parameters']:
            smells.append(CodeSmell(
                type='too_many_parameters',
                severity='medium',
                file_path=file_path,
                line_number=1,
                function_name='',
                description=f'Function has {metrics.max_parameters} parameters (max: {self.config["max_parameters"]})',
                suggestion='Consider using structures or objects to group related parameters'
            ))
        
        # Deep nesting
        if metrics.max_nesting_depth > self.config['max_nesting_depth']:
            smells.append(CodeSmell(
                type='deep_nesting',
                severity='high',
                file_path=file_path,
                line_number=1,
                function_name='',
                description=f'Code has nesting depth of {metrics.max_nesting_depth} (max: {self.config["max_nesting_depth"]})',
                suggestion='Reduce nesting by using early returns, guard clauses, or extracting nested logic'
            ))
        
        # High complexity
        if metrics.cyclomatic_complexity > self.config['max_cyclomatic_complexity']:
            smells.append(CodeSmell(
                type='high_complexity',
                severity='high',
                file_path=file_path,
                line_number=1,
                function_name='',
                description=f'Cyclomatic complexity is {metrics.cyclomatic_complexity} (max: {self.config["max_cyclomatic_complexity"]})',
                suggestion='Simplify conditional logic and reduce the number of decision points'
            ))
        
        # Low comment ratio
        total_lines = metrics.lines_of_code + metrics.comment_lines
        if total_lines > 0:
            comment_ratio = metrics.comment_lines / total_lines
            if comment_ratio < self.config['min_comment_ratio']:
                smells.append(CodeSmell(
                    type='insufficient_comments',
                    severity='low',
                    file_path=file_path,
                    line_number=1,
                    function_name='',
                    description=f'Comment ratio is {comment_ratio:.2%} (min: {self.config["min_comment_ratio"]:.0%})',
                    suggestion='Add more comments to explain complex logic and function purposes'
                ))
        
        # Magic numbers
        if len(metrics.magic_numbers) >= self.config['magic_number_threshold']:
            smells.append(CodeSmell(
                type='magic_numbers',
                severity='medium',
                file_path=file_path,
                line_number=1,
                function_name='',
                description=f'Found {len(metrics.magic_numbers)} magic numbers: {metrics.magic_numbers[:5]}',
                suggestion='Replace magic numbers with named constants for better readability'
            ))
        
        return smells
    
    def _generate_report(self) -> Dict[str, Any]:
        """Generate a comprehensive quality report."""
        total_files = len(self.metrics)
        total_loc = sum(m.lines_of_code for m in self.metrics)
        total_functions = sum(m.function_count for m in self.metrics)
        
        # Calculate averages
        avg_complexity = sum(m.cyclomatic_complexity for m in self.metrics) / total_files if total_files > 0 else 0
        avg_function_length = sum(m.max_function_length for m in self.metrics) / total_files if total_files > 0 else 0
        
        # Count smells by severity
        smell_counts = {'low': 0, 'medium': 0, 'high': 0}
        for smell in self.code_smells:
            smell_counts[smell.severity] += 1
        
        # Calculate quality score (0-100)
        quality_score = self._calculate_quality_score()
        
        return {
            'analysis_date': datetime.datetime.now().isoformat(),
            'summary': {
                'total_files': total_files,
                'total_lines_of_code': total_loc,
                'total_functions': total_functions,
                'quality_score': quality_score,
                'average_complexity': round(avg_complexity, 2),
                'average_function_length': round(avg_function_length, 2)
            },
            'code_smells': {
                'total': len(self.code_smells),
                'by_severity': smell_counts,
                'details': [asdict(smell) for smell in self.code_smells]
            },
            'metrics': [asdict(metric) for metric in self.metrics],
            'recommendations': self._generate_recommendations()
        }
    
    def _calculate_quality_score(self) -> int:
        """Calculate an overall quality score (0-100)."""
        if not self.metrics:
            return 100
        
        score = 100
        total_files = len(self.metrics)
        
        # Deduct points for code smells
        for smell in self.code_smells:
            if smell.severity == 'high':
                score -= 10
            elif smell.severity == 'medium':
                score -= 5
            else:  # low
                score -= 2
        
        # Normalize by number of files
        penalty = (100 - score) / total_files if total_files > 0 else 0
        final_score = max(0, 100 - penalty * total_files)
        
        return round(final_score)
    
    def _generate_recommendations(self) -> List[str]:
        """Generate actionable recommendations based on analysis."""
        recommendations = []
        
        if not self.code_smells:
            recommendations.append("Excellent! No significant code quality issues detected.")
            return recommendations
        
        # Group recommendations by smell type
        smell_types = {}
        for smell in self.code_smells:
            if smell.type not in smell_types:
                smell_types[smell.type] = 0
            smell_types[smell.type] += 1
        
        for smell_type, count in smell_types.items():
            if smell_type == 'long_function':
                recommendations.append(f"Break down {count} long function(s) into smaller, focused functions")
            elif smell_type == 'too_many_parameters':
                recommendations.append(f"Reduce parameter count in {count} function(s) by using structures")
            elif smell_type == 'deep_nesting':
                recommendations.append(f"Reduce nesting depth in {count} location(s) using early returns")
            elif smell_type == 'high_complexity':
                recommendations.append(f"Simplify complex logic in {count} location(s)")
            elif smell_type == 'insufficient_comments':
                recommendations.append(f"Add more documentation to {count} file(s)")
            elif smell_type == 'magic_numbers':
                recommendations.append(f"Replace magic numbers with named constants in {count} file(s)")
        
        return recommendations


def save_report(report: Dict[str, Any], output_file: str, format_type: str = 'json') -> None:
    """Save the analysis report in the specified format."""
    if format_type == 'json':
        with open(output_file, 'w') as f:
            json.dump(report, f, indent=2)
    elif format_type == 'txt':
        with open(output_file, 'w') as f:
            _write_text_report(report, f)
    else:
        raise ValueError(f"Unsupported format: {format_type}")


def _write_text_report(report: Dict[str, Any], file) -> None:
    """Write a human-readable text report."""
    file.write("MATLAB Code Quality Analysis Report\n")
    file.write("=" * 40 + "\n\n")
    
    summary = report['summary']
    file.write(f"Analysis Date: {report['analysis_date']}\n")
    file.write(f"Files Analyzed: {summary['total_files']}\n")
    file.write(f"Total Lines of Code: {summary['total_lines_of_code']}\n")
    file.write(f"Total Functions: {summary['total_functions']}\n")
    file.write(f"Quality Score: {summary['quality_score']}/100\n\n")
    
    file.write("Code Smells Summary:\n")
    file.write("-" * 20 + "\n")
    smells = report['code_smells']
    file.write(f"Total Issues: {smells['total']}\n")
    for severity, count in smells['by_severity'].items():
        file.write(f"  {severity.capitalize()}: {count}\n")
    file.write("\n")
    
    if report['recommendations']:
        file.write("Recommendations:\n")
        file.write("-" * 15 + "\n")
        for i, rec in enumerate(report['recommendations'], 1):
            file.write(f"{i}. {rec}\n")


def main():
    """Main entry point for the code quality analyzer."""
    parser = argparse.ArgumentParser(description='MATLAB Code Quality Analyzer')
    parser.add_argument('directory', help='Directory containing MATLAB files to analyze')
    parser.add_argument('-o', '--output', default='quality_report.json', 
                       help='Output file for the report (default: quality_report.json)')
    parser.add_argument('-f', '--format', choices=['json', 'txt'], default='json',
                       help='Output format (default: json)')
    parser.add_argument('-c', '--config', help='Configuration file (JSON)')
    
    args = parser.parse_args()
    
    # Load configuration if provided
    config = None
    if args.config and os.path.exists(args.config):
        with open(args.config, 'r') as f:
            config = json.load(f)
    
    # Run analysis
    analyzer = MatlabCodeAnalyzer(config)
    report = analyzer.analyze_directory(args.directory)
    
    # Save report
    save_report(report, args.output, args.format)
    
    # Print summary
    print(f"Analysis complete! Quality score: {report['summary']['quality_score']}/100")
    print(f"Found {report['code_smells']['total']} code quality issues")
    print(f"Report saved to: {args.output}")


if __name__ == '__main__':
    main()
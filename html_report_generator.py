#!/usr/bin/env python3
"""
HTML Report Generator for MATLAB Code Quality Analysis
"""

import json
import os
from datetime import datetime
from pathlib import Path


def generate_html_report(json_report_path: str, output_path: str = None, repo_url: str = "https://github.com/clopezno/InvIPM") -> str:
    """Generate an HTML report from the JSON analysis results."""
    
    if output_path is None:
        output_path = json_report_path.replace('.json', '.html')
    
    with open(json_report_path, 'r') as f:
        report = json.load(f)
    
    # Generate the components
    analysis_date = datetime.fromisoformat(report['analysis_date']).strftime('%B %d, %Y at %I:%M %p')
    score_class = get_score_class(report['summary']['quality_score'])
    smell_items = generate_smell_items(report['code_smells']['details'], repo_url)
    recommendations_section = generate_recommendations_section(report.get('recommendations', []))
    metrics_table = generate_metrics_table(report['metrics'], repo_url)
    
    html_content = f"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MATLAB Code Quality Analysis Report</title>
    <style>
        body {{
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            margin: 0;
            padding: 20px;
            padding-top: 80px; /* Space for fixed navigation */
            background-color: #f5f5f5;
            color: #333;
        }}
        
        /* Navigation Menu */
        .navigation {{
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background: #2c3e50;
            z-index: 1000;
            padding: 0 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }}
        
        .nav-container {{
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 60px;
        }}
        
        .nav-brand {{
            color: white;
            font-weight: bold;
            font-size: 1.2em;
        }}
        
        .nav-links {{
            display: flex;
            list-style: none;
            margin: 0;
            padding: 0;
            gap: 30px;
        }}
        
        .nav-links li {{
            margin: 0;
        }}
        
        .nav-links a {{
            color: white;
            text-decoration: none;
            padding: 10px 15px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }}
        
        .nav-links a:hover,
        .nav-links a.active {{
            background-color: #34495e;
        }}
        
        /* Mobile Navigation */
        .nav-toggle {{
            display: none;
            background: none;
            border: none;
            color: white;
            font-size: 1.5em;
            cursor: pointer;
        }}
        
        /* GitHub Link Styling */
        .github-link {{
            color: #2980b9;
            text-decoration: none;
            font-weight: bold;
            margin-left: 10px;
        }}
        
        .github-link:hover {{
            color: #3498db;
            text-decoration: underline;
        }}
        
        .github-icon {{
            margin-right: 5px;
        }}
        .container {{
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }}
        .header {{
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }}
        .header h1 {{
            margin: 0 0 10px 0;
            font-size: 2.2em;
        }}
        .header .subtitle {{
            opacity: 0.9;
            font-size: 1.1em;
        }}
        .content {{
            padding: 30px;
        }}
        .summary-grid {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }}
        .metric-card {{
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            border-left: 4px solid #667eea;
        }}
        .metric-value {{
            font-size: 2em;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 5px;
        }}
        .metric-label {{
            color: #666;
            font-size: 0.9em;
        }}
        .quality-score {{
            text-align: center;
            margin: 30px 0;
        }}
        .quality-circle {{
            width: 120px;
            height: 120px;
            border-radius: 50%;
            margin: 0 auto 15px auto;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2em;
            font-weight: bold;
            color: white;
        }}
        .score-excellent {{ background: #27ae60; }}
        .score-good {{ background: #f39c12; }}
        .score-poor {{ background: #e74c3c; }}
        .section {{
            margin-bottom: 40px;
        }}
        .section h2 {{
            color: #2c3e50;
            border-bottom: 2px solid #ecf0f1;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }}
        .code-smells {{
            display: grid;
            gap: 15px;
        }}
        .smell-item {{
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 15px;
            border-left: 4px solid #95a5a6;
        }}
        .smell-item.high {{ border-left-color: #e74c3c; }}
        .smell-item.medium {{ border-left-color: #f39c12; }}
        .smell-item.low {{ border-left-color: #27ae60; }}
        .smell-header {{
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }}
        .smell-type {{
            font-weight: bold;
            color: #2c3e50;
        }}
        .severity-badge {{
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: bold;
            text-transform: uppercase;
        }}
        .severity-high {{ background: #e74c3c; color: white; }}
        .severity-medium {{ background: #f39c12; color: white; }}
        .severity-low {{ background: #27ae60; color: white; }}
        .smell-description {{
            color: #666;
            margin-bottom: 8px;
        }}
        .smell-suggestion {{
            color: #2980b9;
            font-style: italic;
        }}
        .file-path {{
            font-family: monospace;
            background: #f8f9fa;
            padding: 2px 6px;
            border-radius: 3px;
            font-size: 0.9em;
        }}
        .recommendations {{
            background: #e8f5e8;
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
        }}
        .recommendations h3 {{
            margin-top: 0;
            color: #27ae60;
        }}
        .recommendations ul {{
            margin: 0;
            padding-left: 20px;
        }}
        .recommendations li {{
            margin-bottom: 8px;
        }}
        .metrics-table {{
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }}
        .metrics-table th,
        .metrics-table td {{
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }}
        .metrics-table th {{
            background: #f8f9fa;
            font-weight: bold;
            color: #2c3e50;
        }}
        .metrics-table tr:hover {{
            background: #f8f9fa;
        }}
        .footer {{
            background: #34495e;
            color: white;
            text-align: center;
            padding: 20px;
            margin-top: 40px;
        }}
        @media (max-width: 768px) {{
            .summary-grid {{
                grid-template-columns: 1fr;
            }}
            .smell-header {{
                flex-direction: column;
                align-items: flex-start;
            }}
            .severity-badge {{
                margin-top: 5px;
            }}
            
            /* Mobile Navigation */
            .nav-links {{
                display: none;
                position: absolute;
                top: 100%;
                left: 0;
                right: 0;
                background: #2c3e50;
                flex-direction: column;
                gap: 0;
                padding: 20px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }}
            
            .nav-links.active {{
                display: flex;
            }}
            
            .nav-links li {{
                margin: 0;
            }}
            
            .nav-links a {{
                display: block;
                padding: 15px;
                border-radius: 0;
                border-bottom: 1px solid #34495e;
            }}
            
            .nav-links a:last-child {{
                border-bottom: none;
            }}
            
            .nav-toggle {{
                display: block;
            }}
        }}
    </style>
</head>
<body>
    <!-- Navigation Menu -->
    <nav class="navigation">
        <div class="nav-container">
            <div class="nav-brand">InvIPM Quality Report</div>
            <ul class="nav-links">
                <li><a href="#quality-score">Quality Score</a></li>
                <li><a href="#summary">Summary</a></li>
                <li><a href="#code-issues">Code Issues</a></li>
                <li><a href="#recommendations">Recommendations</a></li>
                <li><a href="#metrics">File Metrics</a></li>
            </ul>
            <button class="nav-toggle" onclick="toggleNav()">☰</button>
        </div>
    </nav>

    <div class="container">
        <div class="header">
            <h1>MATLAB Code Quality Analysis</h1>
            <div class="subtitle">InvIPM Project Quality Assessment Report</div>
            <div style="margin-top: 15px; opacity: 0.8;">
                Generated on {analysis_date}
            </div>
        </div>

        <div class="content">
            <!-- Quality Score -->
            <div id="quality-score" class="quality-score">
                <div class="quality-circle {score_class}">
                    {report['summary']['quality_score']}/100
                </div>
                <h3>Overall Quality Score</h3>
            </div>

            <!-- Summary Metrics -->
            <div id="summary" class="summary-grid">
                <div class="metric-card">
                    <div class="metric-value">{report['summary']['total_files']}</div>
                    <div class="metric-label">Files Analyzed</div>
                </div>
                <div class="metric-card">
                    <div class="metric-value">{report['summary']['total_lines_of_code']:,}</div>
                    <div class="metric-label">Lines of Code</div>
                </div>
                <div class="metric-card">
                    <div class="metric-value">{report['summary']['total_functions']}</div>
                    <div class="metric-label">Functions</div>
                </div>
                <div class="metric-card">
                    <div class="metric-value">{report['code_smells']['total']}</div>
                    <div class="metric-label">Quality Issues</div>
                </div>
                <div class="metric-card">
                    <div class="metric-value">{report['summary']['average_complexity']}</div>
                    <div class="metric-label">Avg Complexity</div>
                </div>
                <div class="metric-card">
                    <div class="metric-value">{report['summary']['average_function_length']}</div>
                    <div class="metric-label">Avg Function Length</div>
                </div>
            </div>

            <!-- Code Smells Section -->
            <div id="code-issues" class="section">
                <h2>Code Quality Issues ({report['code_smells']['total']} found)</h2>
                
                <div style="margin-bottom: 20px;">
                    <strong>Issues by Severity:</strong>
                    <span class="severity-badge severity-high">{report['code_smells']['by_severity']['high']} High</span>
                    <span class="severity-badge severity-medium">{report['code_smells']['by_severity']['medium']} Medium</span>
                    <span class="severity-badge severity-low">{report['code_smells']['by_severity']['low']} Low</span>
                </div>

                <div class="code-smells">
                    {smell_items}
                </div>
            </div>

            <!-- Recommendations -->
            <div id="recommendations">
            {recommendations_section}
            </div>

            <!-- Detailed Metrics -->
            <div id="metrics" class="section">
                <h2>File Metrics Details</h2>
                <table class="metrics-table">
                    <thead>
                        <tr>
                            <th>File</th>
                            <th>LOC</th>
                            <th>Functions</th>
                            <th>Max Complexity</th>
                            <th>Max Nesting</th>
                            <th>Magic Numbers</th>
                        </tr>
                    </thead>
                    <tbody>
                        {metrics_table}
                    </tbody>
                </table>
            </div>
        </div>

        <div class="footer">
            <p>Generated by MATLAB Code Quality Analyzer | InvIPM Project Quality Assessment</p>
        </div>
    </div>

    <script>
        // Navigation toggle for mobile
        function toggleNav() {{
            const navLinks = document.querySelector('.nav-links');
            navLinks.classList.toggle('active');
        }}

        // Smooth scrolling for navigation links
        document.querySelectorAll('.nav-links a').forEach(anchor => {{
            anchor.addEventListener('click', function (e) {{
                e.preventDefault();
                const targetId = this.getAttribute('href').substring(1);
                const targetElement = document.getElementById(targetId);
                
                if (targetElement) {{
                    const offsetTop = targetElement.offsetTop - 80; // Account for fixed nav
                    window.scrollTo({{
                        top: offsetTop,
                        behavior: 'smooth'
                    }});
                }}
                
                // Close mobile menu if open
                const navLinks = document.querySelector('.nav-links');
                navLinks.classList.remove('active');
            }});
        }});

        // Highlight active navigation item on scroll
        window.addEventListener('scroll', function() {{
            const sections = ['quality-score', 'summary', 'code-issues', 'recommendations', 'metrics'];
            const scrollPosition = window.scrollY + 100;
            
            sections.forEach(sectionId => {{
                const section = document.getElementById(sectionId);
                const navLink = document.querySelector(`a[href="#${{sectionId}}"]`);
                
                if (section && navLink) {{
                    const sectionTop = section.offsetTop;
                    const sectionHeight = section.offsetHeight;
                    
                    if (scrollPosition >= sectionTop && scrollPosition < sectionTop + sectionHeight) {{
                        document.querySelectorAll('.nav-links a').forEach(link => {{
                            link.classList.remove('active');
                        }});
                        navLink.classList.add('active');
                    }}
                }}
            }});
        }});
    </script>
</body>
</html>
"""

    with open(output_path, 'w') as f:
        f.write(html_content)
    
    return output_path


def get_score_class(score: int) -> str:
    """Get CSS class based on quality score."""
    if score >= 80:
        return 'score-excellent'
    elif score >= 50:
        return 'score-good'
    else:
        return 'score-poor'


def generate_smell_items(smells: list, repo_url: str) -> str:
    """Generate HTML for code smell items with GitHub links."""
    if not smells:
        return '<div class="smell-item">🎉 No code quality issues detected! Excellent work!</div>'
    
    html = ""
    for smell in smells:
        file_name = os.path.basename(smell['file_path'])
        github_link = f"{repo_url}/blob/main/{smell['file_path']}"
        if smell.get('line_number', 0) > 0:
            github_link += f"#L{smell['line_number']}"
            
        html += f"""
        <div class="smell-item {smell['severity']}">
            <div class="smell-header">
                <div class="smell-type">{smell['type'].replace('_', ' ').title()}</div>
                <div class="severity-badge severity-{smell['severity']}">{smell['severity']}</div>
            </div>
            <div class="smell-description">{smell['description']}</div>
            <div class="smell-suggestion">💡 {smell['suggestion']}</div>
            <div style="margin-top: 8px;">
                <span class="file-path">{file_name}</span>
                <a href="{github_link}" target="_blank" class="github-link">
                    <span class="github-icon">🔗</span>View Source
                </a>
            </div>
        </div>
        """
    return html


def generate_recommendations_section(recommendations: list) -> str:
    """Generate HTML for recommendations section."""
    if not recommendations:
        return ""
    
    recs_html = "\n".join(f"<li>{rec}</li>" for rec in recommendations)
    
    return f"""
    <div class="recommendations">
        <h3>🎯 Recommendations for Improvement</h3>
        <ul>
            {recs_html}
        </ul>
    </div>
    """


def generate_metrics_table(metrics: list, repo_url: str) -> str:
    """Generate HTML table rows for file metrics with GitHub links."""
    html = ""
    for metric in metrics:
        file_name = os.path.basename(metric['file_path'])
        github_link = f"{repo_url}/blob/main/{metric['file_path']}"
        magic_count = len(metric['magic_numbers'])
        
        html += f"""
        <tr>
            <td>
                <span class="file-path">{file_name}</span>
                <a href="{github_link}" target="_blank" class="github-link">
                    <span class="github-icon">🔗</span>View
                </a>
            </td>
            <td>{metric['lines_of_code']}</td>
            <td>{metric['function_count']}</td>
            <td>{metric['cyclomatic_complexity']}</td>
            <td>{metric['max_nesting_depth']}</td>
            <td>{magic_count}</td>
        </tr>
        """
    
    return html


def main():
    """Generate HTML report from JSON."""
    import sys
    
    if len(sys.argv) < 2:
        print("Usage: python html_report_generator.py <json_report_file> [output_file] [repo_url]")
        sys.exit(1)
    
    json_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else None
    repo_url = sys.argv[3] if len(sys.argv) > 3 else "https://github.com/clopezno/InvIPM"
    
    if not os.path.exists(json_file):
        print(f"Error: File {json_file} not found")
        sys.exit(1)
    
    result_file = generate_html_report(json_file, output_file, repo_url)
    print(f"HTML report generated: {result_file}")


if __name__ == '__main__':
    main()
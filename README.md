# Stata Log to HTML Package

A collection of Stata commands for automating workflows that convert Stata outputs (logs, graphs, tables) into HTML and Markdown formats, facilitating integration with Markdown-based reporting and documentation.

## Installation

### Option 1: Install from GitHub (Recommended)

To install this package directly from GitHub, run the following command in Stata:

```stata
net install stata_log2html, from("https://raw.githubusercontent.com/kerrydu/Stata_log2html/main/")
```

This will download and install all the necessary files.

### Option 2: Manual Installation

1. Download the repository as a ZIP file from [GitHub](https://github.com/kerrydu/Stata_log2html).
2. Extract the contents to your Stata ado directory (usually `c:\ado\personal\` on Windows).
3. Restart Stata or run `adopath` to update the ado path.

## Package Functions

This package includes several commands to streamline Stata workflows:

### Core Commands

- **`graph2md`**: Exports the current graph and inserts a Markdown image link into the log output. Supports options like zoom, alt text, and auto-numbering.
  - Syntax: `graph2md, save(filename) [options]`

- **`logout3`**: Handles log output processing for HTML conversion.
  - Syntax: `logout3 [options]`

- **`markdown2`**: Processes Markdown files and converts them to HTML or other formats for integration with Stata outputs. **Key features include path conversion options: `rpath()` converts absolute paths to relative paths ("./") for portability when sharing reports, and `wpath()` replaces local paths with web URLs for online publishing, ensuring links work correctly in web environments. Note: When using `wpath()`, you must upload the generated HTML table files and figure images to the specified web URL location for the links to function properly.**
  - Syntax: `markdown2 [options]`

- **`outreg3`**: Outputs regression results in various formats, including HTML.
  - Syntax: `outreg3 [options]`

- **`statacell`**: Processes and formats Stata output cells for HTML display.
  - Syntax: `statacell [options]`

- **`tabhtml`**: Executes a Stata command that generates HTML output and embeds it as an iframe in Markdown.
  - Syntax: `tabhtml [, width(#) height(#) src(filename)] : command`
  - Automatically detects HTML files from commands like `esttab`.

### Utility Files

- **`minido.do`** and **`minido-copy.do`**: Do-files for batch processing and automation.

- **`stata_workflow_description.md`**: Detailed description of the workflow.

## Workflow

This package enhances Stata's built-in logging capabilities by enabling Markdown-based reporting with embedded HTML elements. Instead of plain text logs, you can generate rich, interactive reports that include formatted tables, graphs, and iframes directly in the log output.

### How It Enhances Stata Built-in Logs

Stata's standard `log` command produces plain text output. This package extends it by:

- **Markdown Formatting**: Logs are saved in Markdown format (`.md`), allowing for headers, lists, and code blocks.
- **Embedded Graphics**: Use `graph2md` to automatically insert image links into the log.
- **HTML Tables**: Use `tabhtml` to embed HTML tables (e.g., from `esttab`) as iframes in the Markdown log.
- **Automated Processing**: Commands like `logout3` convert Stata output to HTML/TeX formats.
- **Final Report Generation**: Use `markdown2` to convert the Markdown log into a complete HTML report.

### Typical Workflow (Based on minido-copy.do)

1. **Setup Project Structure**:
   - Define global paths for results, figures, and logs.
   - Create output directories automatically.

2. **Data Preparation**:
   - Load and clean data (e.g., `sysuse auto, clear`).
   - Generate new variables and labels.

3. **Descriptive Statistics**:
   - Run summaries and use `logout3` to export formatted tables in HTML and TeX.

4. **Visualization**:
   - Create graphs (e.g., histograms, scatter plots).
   - Use `graph2md` to export graphs and insert Markdown image links into the log.

5. **Modeling**:
   - Run regressions and store estimates.
   - Use `tabhtml` with `esttab` to generate HTML tables embedded as iframes in the Markdown log.
   - Optionally use `outreg3` for additional table formats.

6. **Additional Analysis**:
   - Generate predictions and more graphs as needed.

7. **Report Generation**:
   - Close the log.
   - Use `markdown2` to convert the Markdown log to HTML.
   - Automatically open the HTML report in the browser.

### Example Workflow Code

```stata
// Setup
global project "path/to/project"
global results "$project/results"
global figures "$results/figures"
global logs "$results/logs"

// Create directories
foreach dir in "$results" "$figures" "$logs" {
    capture mkdir `dir'
}

// Start Markdown log
log using "$logs/report.md", replace text
statacell
// Data and analysis (as in minido-copy.do)
sysuse auto, clear
// ... data cleaning ...

// Descriptive stats with logout3
logout3, save("$results/descriptives") replace tex html : tabstat price weight mpg, statistics(n mean sd)

// Graphs with graph2md
histogram price
graph2md, save("$figures/price_hist.png") zoom(30)

// Regressions and tables with tabhtml
qui regress price mpg weight
estimates store model1
tabhtml : esttab model1 using "$results/model.html", replace

// Close log
capture log close

// Generate HTML report
markdown2 "$logs/report.md", saving("$results/report.html") replace
```

This workflow transforms Stata's simple text logs into comprehensive, publication-ready reports with embedded multimedia elements.

## Examples

### Complete Workflow Example

For a full demonstration of the enhanced logging workflow, refer to `minido-copy.do`. This do-file provides a complete example using the auto dataset, including:

- Project setup with global paths and directory creation.
- Data loading, cleaning, and variable generation.
- Descriptive statistics with `logout3` for HTML/TeX output.
- Graph creation and export with `graph2md`.
- Multiple regression models with `estimates store`.
- Table generation using `tabhtml` with `esttab` for embedded HTML iframes.
- Final report generation with `markdown2`.

#### How to Run the Example

1. **Adjust Paths**: Edit the global paths in `minido-copy.do` to point to your desired output directories.
   
   ```stata
   global project "C:/path/to/your/project"
   global results "$project/results"
   global figures "$results/figures"
   global logs "$results/logs"
   ```

2. **Execute the Do-File**: Run the script in Stata.

   ```stata
   do minido-copy.do
   ```

3. **View Results**: The script will generate:
   - Markdown log: `$logs/auto-mini.md`
   - HTML report: `$results/auto-mini.html` (automatically opened in browser)
   - Figures: PNG files in `$figures/`
   - Tables: HTML files in `$results/`

This example showcases how the package transforms standard Stata output into a rich, interactive report.

## Requirements

- Stata 14 or later
- Internet connection for installation (if using `net install`)

## Contributing

Contributions are welcome! Please fork the repository and submit pull requests.

## License

This package is provided as-is. Please check individual file headers for licensing information.

## Contact

For issues or questions, please open an issue on [GitHub](https://github.com/kerrydu/Stata_log2html) or contact the author.
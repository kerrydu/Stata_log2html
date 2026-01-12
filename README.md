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

- **`markdown2`**: Processes Markdown files and converts them to HTML or other formats for integration with Stata outputs.
  - Syntax: `markdown2 [options]`

- **`outreg3`**: Outputs regression results in various formats, including HTML.
  - Syntax: `outreg3 [options]`

- **`statacell`**: Processes and formats Stata output cells for HTML display.
  - Syntax: `statacell [options]`

- **`tabhtml`**: Executes a Stata command that generates HTML output and embeds it as an iframe in Markdown.
  - Syntax: `tabhtml [, width(#) height(#) src(filename)] : command`
  - Automatically detects HTML files from commands like `outreg2`.

### Utility Files

- **`minido.do`** and **`minido-copy.do`**: Do-files for batch processing and automation.

- **`stata_workflow_description.md`**: Detailed description of the workflow.

## Workflow

This package is designed for Markdown-based Stata reporting workflows. A typical workflow might look like this:

1. **Set up your analysis**: Use standard Stata commands to run regressions, create graphs, etc.

2. **Generate outputs**:
   - Use `graph2md` to export graphs and get Markdown links.
   - Use `tabhtml` with commands like `outreg2` to generate HTML tables embedded in Markdown.

3. **Process logs**: Use `logout3` to convert Stata logs to HTML format.

4. **Automate with do-files**: Use `minido.do` for batch processing multiple analyses.

5. **Integrate into reports**: The outputs are formatted for easy inclusion in Markdown documents, which can then be converted to HTML or PDF.

### Example Workflow

```stata
// Load data
sysuse auto, clear

// Run analysis
regress price weight mpg

// Export graph
graph2md, save(mygraph.png)

// Export table as HTML iframe in Markdown
tabhtml : outreg2 using mytable.html, replace

// Process log
logout3
```

The resulting Markdown can be processed by tools like `markdown2` or Pandoc to create final reports.

## Requirements

- Stata 14 or later
- Internet connection for installation (if using `net install`)

## Contributing

Contributions are welcome! Please fork the repository and submit pull requests.

## License

This package is provided as-is. Please check individual file headers for licensing information.

## Contact

For issues or questions, please open an issue on [GitHub](https://github.com/kerrydu/Stata_log2html) or contact the author.
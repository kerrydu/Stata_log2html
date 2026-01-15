{smcl}
{* *! version 1.0.0  15jan2026}{...}
{vieweralsosee "markdown2" "help markdown2"}{...}
{vieweralsosee "_textcell" "help _textcell"}{...}
{viewerjumpto "Syntax" "cmdcell##syntax"}{...}
{viewerjumpto "Description" "cmdcell##description"}{...}
{viewerjumpto "Options" "cmdcell##options"}{...}
{viewerjumpto "Remarks" "cmdcell##remarks"}{...}
{viewerjumpto "Examples" "cmdcell##examples"}{...}
{title:Title}

{phang}
{bf:cmdcell} {hline 2} Insert Markdown code fences or headers into Stata log

{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:cmdcell} {it:argument}

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt 1} | {opt begin}}Insert a code fence {bf:```}. Used to start a code block.{p_end}
{synopt:{opt 0} | {opt end}}Insert a code fence {bf:```}. Used to end a code block.{p_end}
{synopt:{opt out}} specify inserting generating table or figure.{p_end}
{synopt:{it:empty}}Insert a code fence {bf:```}.{p_end}
{synopt:{bf:#} {it:text}}Insert a Markdown header (e.g., {bf:# Header}).{p_end}
{synoptline}
{p2colreset}{...}

{marker description}{...}
{title:Description}

{pstd}
{cmd:cmdcell} is a helper command used in conjunction with {help markdown2:markdown2} to structure Stata logs for conversion to Markdown.
It allows you to manually insert Markdown code fences ({bf:```}) or headers into the Stata output log.

{pstd}
When {cmd:markdown2} processes the log file, it typically treats the Stata output as a code block.
However, you may want to break the code block to insert headers, text, or figures.
{cmd:cmdcell} helps you manually terminate or start these blocks, although {cmd:markdown2} also has automatic detection logic.

{pstd}
The command itself ({cmd:. cmdcell ...}) will be removed from the final Markdown output by {cmd:markdown2},
but its output (the backticks or header) will remain.

{marker remarks}{...}
{title:Remarks}

{pstd}
This command is useful when you need precise control over where code blocks start and end,
or when you want to insert a Markdown header that is recognized by the parser.

{pstd}
Note that {cmd:markdown2} commonly handles standard cases (like automatic fencing around headers) automatically.
{cmd:cmdcell} provides manual override capability.

{marker examples}{...}
{title:Examples}

{pstd}
{bf:1. Start/End explicit code blocks}

{phang2}{cmd:. cmdcell 0}{p_end}
{phang2} (Ends the previous code block in the log) {p_end}

{phang2}{cmd:. cmdcell 1}{p_end}
{phang2} (Starts a new code block in the log) {p_end}

{pstd}
{bf:2. Insert a Level 3 Header}

{phang2}{cmd:. cmdcell ### Data Cleaning}{p_end}
{phang2} (Inserts "### Data Cleaning" into the output, breaking usually requires a preceding fence) {p_end}

{title:Author}

{pstd}
Developed for Stata Markdown conversion workflows.
{p_end}

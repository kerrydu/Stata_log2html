capture program drop markdown2
program define markdown2
    // Clean markdown log: remove 'statacell' lines, strip leading '>'
    syntax anything , SAVing(string) [ REPlace HTML(string) ]
    local using `anything'
    
    // Resolve paths
    local infile `"`using'"'
    local outfile `"`saving'"'

    // If outfile exists and no replace, stop
    capture confirm file `outfile'
    if _rc == 0 & "`replace'" == "" {
        di as error "output file exists; use replace"
        exit 602
    }

    tempname fin fout
    file open `fin' using `infile', read text
    file open `fout' using `outfile', write text replace

    quietly {
        file read `fin' line
        while r(eof)==0 {
            // 1. Skip lines containing "statacell"
            cap local ss = ustrpos(`"`line'"', "statacell")
            if _rc  local ss = ustrpos("`line'", "statacell")
            if `ss' > 0 {
                file read `fin' line
                continue
            }

            cap local ss = ustrpos(`"`line'"', "log close")
            if _rc  local ss = ustrpos("`line'", "log close")

            cap local ss = `ss' * (ustrpos(`"`line'"', ".")==1)
            if _rc  local ss = `ss' * (ustrpos("`line'", ".")==1)

            if `ss' > 0 {
                file read `fin' line
                continue
            }

            cap local ss = (ustrpos(`"`line'"', "{com}")==1)
            if _rc  local ss = (ustrpos("`line'", "{com}")==1)

            cap local ss = `ss' + (ustrpos(`"`line'"', "{txt}")==1)
            if _rc  local ss = `ss' + (ustrpos("`line'", "{txt}")==1)
            cap local ss = `ss' + (ustrpos(`"`line'"', "{res}")==1)
            if _rc  local ss = `ss' + (ustrpos("`line'", "{res}")==1)
            cap local ss = `ss' + (ustrpos(`"`line'"', "{smcl}")==1)
            if _rc  local ss = `ss' + (ustrpos("`line'", "{smcl}")==1)

            if `ss' > 0 {
                file read `fin' line
                continue
            }

            cap local ss = (`"`line'"'==".")
            if _rc  local ss = ("`line'"==".")

            if `ss' > 0 {
                file read `fin' line
                continue
            }            

            // 2. Remove leading ">" from continuation lines
            // Check if line starts with optional spaces followed by >
            cap local ss = regexm(`"`line'"', "^[ ]*>")
            if _rc  local ss = regexm("`line'", "^[ ]*>")            
            if `ss' {
                 cap local line = subinstr(`"`line'"', ">", "", 1)
                 if _rc  local line = subinstr("`line'", ">", "", 1)
            }

           cap  file write `fout' `"`line'"' _n
           if _rc  file write `fout' "`line'" _n
            file read `fin' line
        }
    }

    file close `fin'
    file close `fout'

    di as text "% cleaned markdown written to `outfile'"

    // Optional: regenerate HTML from cleaned markdown
    if "`html'" != "" {
        markdown `outfile', saving(`"`html'"') replace
        di as text "% html regenerated to `html'"
    }
end

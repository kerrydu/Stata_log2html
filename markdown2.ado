capture program drop markdown2
program define markdown2
    // Clean markdown log: remove 'statacell' lines, strip leading '>'
    syntax anything ,  [ SAVing(string) REPlace HTML(string) RPath(string) WPath(string) CLEAN]

    if "`clean'" != "" {
        mclean `0'
        exit
    }
    if `"`saving'"' == "" {
        //在anything扩展名之前加clean，思路找到最后一个.的位置，然后把扩展名之前的部分替换成clean.md
        local saving = usubstr(`"`anything'"', 1, ustrpos(`"`anything'"', ".")-1) + ".clean.md"
    }
    local using `anything'
    local llp ./
    if "`wpath'" != "" {
        // check if wpath is a url
        mata: st_numscalar("wflag",isurl("`wpath'"))
        if wflag==0 {
            di as error "`wpath' is not a valid url"
            exit 601
        }
        local llp `wpath'
      
    }

    if "`rpath'"!=""{
        // check if the directory path exist
        mata: st_numscalar("rflag",direxists("`rpath'")) 
        if rflag==0 {
            di as error "directory `rpath' does not exist"
            exit 601
        }
        // convert \ in rpath to /
        local rpath = usubinstr(`"`rpath'"', "\", "/", .)
        // if the last character is not /, add it
        if ustrpos(`"`rpath'"', "/") != ustrlen(`"`rpath'"') {
            local rpath = `"`rpath'/"' 
        }
    }
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
            if `"`rpath'"' != "" {

                cap local ss = (ustrpos(`"`line'"', "<iframe")==1)
                if _rc  local ss = (ustrpos("`line'", "<iframe")==1)

                cap local ss = `ss' + (ustrpos(`"`line'"', "<img")==1)
                if _rc  local ss = `ss' + (ustrpos("`line'", "<img")==1)

                if `ss' > 0 {
                    // replace \ in line with /
                    cap local line = usubinstr(`"`line'"', "\", "/", .)
                    if _rc  local line = usubinstr("`line'", "\", "/", .)
                }


                cap local line = usubinstr(`"`line'"', "`rpath'", "`llp'", .)
                if _rc  local line = usubinstr("`line'", "`rpath'", "`llp'", .)
            }

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


program define mclean
    syntax anything , [SAVing(string)  REPlace HTML(string) RPath(string) WPath(string) CLEAN]
    // only keep lines that start with #, <iframe, <img
    if `"`saving'"' == "" {
        //在anything扩展名之前加clean，思路找到最后一个.的位置，然后把扩展名之前的部分替换成clean.md
        local saving = usubstr(`"`anything'"', 1, ustrpos(`"`anything'"', ".")-1) + ".clean.md"
    }
    local using `anything'
    local llp ./
    if "`wpath'" != "" {
        // check if wpath is a url
        mata: st_numscalar("wflag",isurl("`wpath'"))
        if wflag==0 {
            di as error "`wpath' is not a valid url"
            exit 601
        }
        local llp `wpath'
    }

    if "`rpath'"!=""{
        // check if the directory path exist
        mata: st_numscalar("rflag",direxists("`rpath'")) 
        if rflag==0 {
            di as error "directory `rpath' does not exist"
            exit 601
        }
        // convert \ in rpath to /
        local rpath = usubinstr(`"`rpath'"', "\", "/", .)
        // if the last character is not /, add it
        if ustrpos(`"`rpath'"', "/") != ustrlen(`"`rpath'"') {
            local rpath = `"`rpath'/"' 
        }
    }

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
            local keep = 0
            
            // Check for #
            cap local ss = (ustrpos(`"`line'"', "#")==1)
            if _rc local ss = (ustrpos("`line'", "#")==1)
            if `ss' local keep = 1
            
            // Check for <iframe
            if `keep' == 0 {
                cap local ss = (ustrpos(`"`line'"', "<iframe")==1)
                if _rc local ss = (ustrpos("`line'", "<iframe")==1)
                if `ss' local keep = 1
            }

            // Check for <img
            if `keep' == 0 {
                cap local ss = (ustrpos(`"`line'"', "<img")==1)
                if _rc local ss = (ustrpos("`line'", "<img")==1)
                if `ss' local keep = 1
            }

            if `keep' {
                if `"`rpath'"' != "" {
                     cap local ss = (ustrpos(`"`line'"', "<iframe")==1)
                     if _rc local ss = (ustrpos("`line'", "<iframe")==1)
                     cap local ss2 = (ustrpos(`"`line'"', "<img")==1)
                     if _rc local ss2 = (ustrpos("`line'", "<img")==1)
                     
                     if `ss' | `ss2' {
                        cap local line = usubinstr(`"`line'"', "\", "/", .)
                        if _rc  local line = usubinstr("`line'", "\", "/", .)
                     }
                     
                     cap local line = usubinstr(`"`line'"', "`rpath'", "`llp'", .)
                     if _rc  local line = usubinstr("`line'", "`rpath'", "`llp'", .)
                }
                cap file write `fout' `"`line'"' _n
                if _rc file write `fout' "`line'" _n
            }
            
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

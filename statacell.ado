
program define statacell 
version 8.0
syntax [anything]
local x `anything'
if `"`x'"' == "0" {
    disp "``` stata"
}
if `"`x'"' == "1" {
    disp "```"
}
if strpos(`"`x'"',"#")>0 {
    cap disp `"`x'"'
    if _rc disp "`x'"
}
if `"`x'"' == ""{
    disp "```"
}
end

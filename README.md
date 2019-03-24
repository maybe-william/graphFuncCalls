The idea behind this program is to take a project location with some form of code and to graph the calling structure of the all the functions found at said location. Right now, the function declarations of the form this program reads are to be entered manually in any comments in the code or in any file outside of the code (still commented). (currently recognized comment forms are # full line, // full line, -- full line, or /*  */ multiline.) The eventual plan is to be able to parse calling info from several different languages, but it's still manual entry for now. The data entry structure is as follows:

#name: tempName = package.package2.function
#calls: tempName,tempName2

#name: tempName2 = package.function3

#name: package.package2.fullyQualified
#calls: tempName, package.function3


The # can be any comment symbol, or none if the text is inside a multiline comment. The 'tempName ='  part is optional, but recommended (to avoid having to always type the fully qualified name.)  Also, the 'calls:' line must come immediately after the 'name:' line that it applies to.

For now, it works fine on Linux. Simply call the graphFuncCalls file in bin passing in the directory you wish to graph (with a -r flag if you want it to be recursive) (requires ruby). The graph should appear in the folder that bin/graphFuncCalls was called from if all goes well.

This project is currently set up with function and call info, and the top-level folder has the resulting graph by default. (Crazy meta.)

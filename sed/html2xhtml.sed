## just a demo, just convert unstandard html tags into lower letters
## usage:
## /bin/sed -i -f [this file] [target files]
## if add '#!/bin/sed -f' at first of this file, exec like this: ./html2xhtml.sed -i [target files] 
s/<H1>/<h1>/g
s/<H2>/<h2>/g
s/<H3>/<h3>/g
s/<H4>/<h4>/g
s/<H5>/<h5>/g
s/<H6>/<h6>/g
s:</H1>:</h1>/g
s:</H2>:</h2>/g
s:</H3>:</h3>/g
s:</H4>:</h4>/g
s:</H5>:</h5>/g
s:</H6>:</h6>/g
s:<[Hm][Tt][Mm][Ll]>:<html>:g
s:</[Hm][Tt][Mm][Ll]>:</html>:g
s:<[Hh][Ee][Aa][Dd]>:<head>:g
s:</[Hh][Ee][Aa][Dd]>:</head>:g
s:<[Tt][Ii][Tt][Ll][Ee]>:<title>:g
s:</[Tt][Ii][Tt][Ll][Ee]>:</title>:g
s:<[Bb][Rr]>:</br>:g

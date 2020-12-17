set args = WScript.Arguments

set http = CreateObject("Msxml2.ServerXMLHTTP")
http.open "POST","https://www.ipaddress.com/search/", false
http.send "host=www.baidu.com"

msgBox http.Status
'msgbox http.responsetext

'响应结果无法直接返回 数据量太大会有限制？
'WSH.echo http.responsetext

set fs = createobject("scripting.filesystemobject")
set f = fs.CreateTextFile(args(0),8)
f.writeblanklines(1)
f.writeline http.responsetext
f.close
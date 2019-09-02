## just a demo
## usage: awk -f [this] /var/log/nginx/access.log
BEGIN{
	print "start count where visit times gt 100."
	print "ip times"
}
{
	a[$1]++;
	if(a[$1]>100){
		b[$1]++
	}	
}
END{
	if(length(b)>0){
		for(i in b){
                	print i,a[i]
        	}
	}else{
		print "NULL 0"
	}
	
	print"-----------------------"
	print "total visit count: ", NR
}

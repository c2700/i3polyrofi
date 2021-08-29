import os, re
from fontTools import unicodedata

with open("unicode.txt.bak", "r") as codes:
	strings=list(codes.readlines()) 
	for i in strings: 
		string0='python3 -c "from fontTools import unicodedata;print(\'{} - {} - {}\'.format('
		string1="unicodedata.tostr('"+str.lower(i)+"'), "
		string2=""
		try:
			unicodedata.name('"+str.lower(i)+"')
			string2="unicodedata.name('"+str.lower(i)+"'), "
		except:	
			string2="'No_Name', "

		string3="unicodedata.block('"+str.lower(i)+"')))\""
		args=string0+string1+string2
		args=string0+string1+string2+string3
		args=re.sub("\n","",args) 
		os.system(args) 


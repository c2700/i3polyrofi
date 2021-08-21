import bs4
import urllib
import re
from os import mkdir

# make a request to "nerdfonts.com" using request.urlopen() an store the result in an object 
nerd_fonts_url=urllib.request.urlopen("https://www.nerdfonts.com/font-downloads").read()

# return webpage content using read() and store the result in an object
nerd_fonts_url_obj=nerd_fonts_url.read()

# parsing the returned content by passing it to BeautifulSoup as arg1 and passing "lxml" as parser in arg2
nerd_fonts_links_obj=bs4.BeautifulSoup(nerd_fonts_url_obj,"lxml")

# making a directory to store the nerdfonts files
mkdir("NerdFonts")

# open a file to store all nerdfonts links
nf_21_links=open("NerdFonts/nerd_fonts_v2.1.0.txt","w+")

# writing all nerdfonts links to file
# find_all anchor tags
for links in nerd_fonts_links_obj.find_all("a"):
	link = links.get("href") # get anchor tags with the href attribute
	if re.search("\.zip$",link) is not None: # if result of href ending with ".zip" is not None
		nf_21_links.write(link+"\n") # write links ending with .zip into the file

# close the nerdfonts file
nf_21_links.close()

print("extracted all available nerdfonts links")


import bs4
import urllib
import re
from os import mkdir

nerd_fonts_url="https://www.nerdfonts.com/font-downloads"
nerd_fonts_url_obj=urllib.request.urlopen(nerd_fonts_url).read()
nerd_fonts_links_obj=bs4.BeautifulSoup(nerd_fonts_url_obj,"lxml")

mkdir("NerdFonts")
with open("NerdFonts/nerd_fonts_v2.1.0.txt","w+") as nf_21_links:
	for links in nerd_fonts_links_obj.find_all("a"):
		link = links.get("href")
		if re.search("\.zip$",link) is not None:
			print(link)
			nf_21_links.write(link+"\n")


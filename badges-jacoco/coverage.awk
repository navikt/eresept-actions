function colorize(p)
{
   color = "lightgrey"
   if (p == 100) {
      color = "brightgreen"
   } else if (p >= 90) {
      color = "green"
   } else if (p >= 80) {
      color = "yellowgreen"
   } else if (p >= 70) {
      color = "yellow"
   } else if (p >= 60) {
      color = "orange"
   } else {
      color = "red"
   }
   return color
}

BEGIN { FS = ","; }
NR != 1 {
	gsub(/report\//,"");
	m += $4;
	c += $5;
	mm[$1] += $4
	cc[$1] += $5
}
END {
	s = sprintf("%.2f", c /(m + c) * 100);
	print "curl -s 'https://img.shields.io/badge/coverage-"s"%25-"colorize(s)""logo"' > badges/jacoco.svg";
	for (i in mm) {
	    ss[i] = sprintf("%.2f", cc[i] / (mm[i] + cc[i]) * 100);
		print "curl -s 'https://img.shields.io/badge/coverage-"ss[i]"%25-"colorize(ss[i])""logo' > badges/jacoco-"i".svg"
	}
}

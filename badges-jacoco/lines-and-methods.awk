BEGIN { FS = ","; }
NR != 1 {
	gsub(/report\//,"");
	lm += $8;
	lc += $9;
	mm += $12;
	mc += $13;
	lin[$1] += ($8 + $9)
	met[$1] += ($12 + $13)
}
END {
	l = lm + lc;
	m = mm + mc;
	print "curl -s 'https://img.shields.io/badge/lines-"l"-lightgrey"logo"' > badges/lines.svg";
	print "curl -s 'https://img.shields.io/badge/methods-"m"-lightgrey"logo"' > badges/methods.svg";
	for (i in lin) {
		print "curl -s 'https://img.shields.io/badge/lines-"lin[i]"-lightgrey"logo"' > badges/lines-"i".svg"
		print "curl -s 'https://img.shields.io/badge/methods-"met[i]"-lightgrey"logo"' > badges/methods-"i".svg"
	}
}

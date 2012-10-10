/* Intial data foray for inertia in household asset holdings */
/* October 2012 */
/* James Partridge */
/* jamesgpartridge.com */
/* For dataset creation, see Basic_SCF.do */

#delim;
clear;

global datadir z:\research\RA\SCF\OUTPUT;
global OutDir z:\research\Inertia;

capture log close _all;
log using $OutDir\demos_by_year, replace t name(Demos);

/* Note: D2I is debt 2 income ratio */

local years "1995 1998 2001 2004";
local demos "AGE HHSIZE EDUC INCOME D2I";

/* summarize income */
foreach yr of local years {;
	use $datadir\\`yr'SCF.dta;
	preserve;
	di `yr';
	su INCOME [iw=WGT0];
	restore;
	clear;
};

/* have KG by income quartiles */
foreach yr of local years {;
	use $datadir\\`yr'SCF.dta;
	preserve;
	di `yr';
	xtile INCby4=INCOME, n(4);
	sort INCby4;
	by INCby4: tab HKGTOTAL [iw=WGT0];
	restore;
	clear;
};

/* have KG in stocks or mutual funds by income quartiles */
foreach yr of local years {;
	use $datadir\\`yr'SCF.dta;
	preserve;
	di `yr';
	xtile INCby4=INCOME, n(4);
	sort INCby4;
	by INCby4: tab HKGSTMF [iw=WGT0];
	restore;
	clear;
};

/* saved? by income quartiles */
foreach yr of local years {;
	use $datadir\\`yr'SCF.dta;
	preserve;
	di `yr';
	xtile INCby4=INCOME, n(4);
	sort INCby4;
	by INCby4: tab SAVED [iw=WGT0];
	restore;
	clear;
};

/* D2I by income quartiles */
foreach yr of local years {;
	use $datadir\\`yr'SCF.dta;
	preserve;
	di `yr';
	xtile INCby4=INCOME, n(4);
	sort INCby4;
	by INCby4: su D2I [iw=WGT0];
	restore;
	clear;
};

/* how does risky fraction change over time by income */
foreach yr of local years {;
	use $datadir\\`yr'SCF.dta;
	preserve;
	di `yr';
	gen RISKY=STOCKS+NMMF;
	gen RISKSHARE=RISKY/ASSET;
	xtile INCby4=INCOME, n(4);
	sort INCby4;
	by INCby4: su RISKSHARE [iw=WGT0];
	restore;
	clear;
};

capture log close Demos;
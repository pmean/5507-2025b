* Documentation header

    todd-5507-06-demo.sas
    author: Reagan Todd, Steve Simon
    date created: 2025-09-09
    purpose: to understand how to manipulate data widths.
    license: public domain;


* File locations;


%let path=q:/5507-2025b/06;

ods pdf 
    file= "&path/results/todd-5507-06-demo.pdf";

libname storage 
    "&path/data/";

filename balance1
    "&path/data/balance-measures-long.txt";
  
filename balance2
    "&path/data/balance-measures-wide.txt";


* Comments on the code: I would have preferred to use longer names
	than balance1 and balance2, but the filename statement has an
	odd holdover from IBM maingrame days. The name that you associate
	in a filename statement has to be eight characters or less. Back
	in the days of mainframes, almost everything you did in SAS had to
	be eight characters or less. Most have been updated (thank 
	goodness) but the filename statement has one of the rare exceptions
	that has not been updated.;


* Read long format;


data storage.balance_long;
    infile balance1 delimiter= "09"X firstobs=2;
    input
        Subject
        Sex $
        Age
        Height
        Weight
        Surface $
        Vision $
        CTSIB;
run;


* Print data and metadata;


proc print
    data=storage.balance_long (obs=12);
    title1 "First twelve rows of the long format balance data";
    footnote "Reagan Todd, 2025-09-09, SAS version 9.4";
run;

proc contents data=storage.balance_long;
    title1 "Contents of the long balance data";
run;


* Read wide format;


data storage.balance_wide;
    infile balance2 delimiter= "09"X firstobs=2;
    input
        Subject
        Sex $
        Age
        Height
        Weight
        NO1
        NO2
        NC1
        NC2
        ND1
        ND2
        FO1
        FO2
        FC1
        FC2
        FD1
        FD2;
run;


* Comments on the code: I (Steve) made a subtle mistake in an
    earlierversion of this code. I used a zero when I should 
    have used a capital O. The O stands for open. That 
    shouldn't hurt anything but later in the program, I 
    switched back to the correct variable names (NO1, NO2, 
    FO1, FO2) and SAS got confused. Always be careful with 
    the number 0 and the upper case letter O. Also be careful
    with the number 1 and the lower case letter l.;


* Print data and metadata;


proc print
    data=storage.balance_wide (obs=10);
    title1 "first ten rows of the wide balance data";
run;

proc contents data=storage.balance_wide;
    title1 "Contents of the wide balance data";
run;


* Create time constant data from long format;


data storage.time_constant_long;
    set storage.balance_long;
    keep Subject Sex Age Height Weight;
run;

proc sort
    data=storage.time_constant_long nodup;
	by _all_;
run;

proc print
   data=storage.time_constant_long (obs=10);
   title "First ten rows of time constant data";
run;


* Comments on the code: The nodup option removes
    duplicate observations. There is now only one
    row per patient. It is very important to keep
    the subject number in this and any other data
    subsets from either the long format or the
    wide format.;


* Create time varying data from long format;


data storage.time_varying_long;
    set storage.balance_long;
	keep Subject Surface Vision CTSIB;
run;

proc print
   data=storage.time_varying_long (obs=10);
   title "First ten rows of time constant data";
run;


* Comments on the code: Getting the time-varying
    data from the long format requires no special
    effort. You must always include the subject
    number, even though it is not time varying.


* Creating time constant data from wide format;


data storage.time_constant_wide;
    set storage.balance_wide;
    keep Subject Sex Age Height Weight;
run;

proc print
   data=storage.time_constant_wide (obs=10);
   title "First ten rows of time-constant data";
run;


* Comments on the code: There is no need to remove
    duplicates here because the wide format
    already has just one row per patient.;


* Creating time varying data from wide format;


data storage.time_varying_wide;
    set storage.balance_wide;
    keep Subject NO1 NO2 NC1 NC2 ND1 ND2 FO1 FO2 FC1 FC2 FD1 FD2;
run;

proc print
   data=storage.time_varying_wide (obs=10);
   title "First ten rows of time-varying data";
run;


* Comments on the code: Notice that the time 
    varying data looks different from the 
    previous example. You will need to use proc
    transpose to convert one format to the 
    other.;


* Transposing long to wide, part 1;


proc sort
    data=storage.time_varying_long;
	by Surface Vision Subject;
run;

data storage.time_varying_long;
    set storage.time_varying_long;
	by Surface Vision Subject;
	if first.Subject 
        then rep=1;
        else rep=2;
run;


* Comments on the code: Each treatment condition 
    in this repeated measures is repeated twice, but
    the long format version of the data does not make
    directly designate the first and second repliclation.
    With sorted data, first.Subject is a logical variable
    evaluating to true if the record represents the first
    observation within your by groups. This allows you to
    designate replications 1 versus 2.;


* Transposing long to wide, part 2;


proc sort
    data=storage.time_varying_long;
	by Subject Surface Vision Rep;
run;

proc transpose
    data=storage.time_varying_long
	out=wide_conversion;
	id Surface Vision rep;
	by Subject;
	var CTSIB;
run;

proc print
    data=wide_conversion (obs=10);
	title1 "Listing of long converted to wide format";
run;


* Comments on the code: You specify the orginal
    dataset with data keyword and the new 
    transposed dataset with out keyword. You 
    specify the time variable in a longitudinal 
    design or the treatment conditions in a 
    repeated measures design using the id 
    statement. You specify the variable that 
    identifies the values associated with each 
    subject using the by statement. You should
    make sure that the data is sorted properly 
    before using the by statement. You specify 
    the single column that represents the 
    outcomes in a longitudinal or repeated 
    measures data with the var statement.;


* Transposing wide to long;


proc sort
    data=storage.time_varying_wide;
	by Subject;
run;

proc transpose
    data=storage.time_varying_wide
	out=long_conversion;
	by Subject;
    var NO1--FD2;
run;

proc print
    data=long_conversion (obs=10);
	title1 "Listing of wide converted to long format";
run;


* Comments on the code: Like in the earlier example, 
    you specify the original dataset and the new
    transposed dataset with data and out keywords.
    Also like the earlier example, you specify the
    variable which tells you which row is associated
    with which subject using the by statement. You 
    should make sure the data is sorted properly 
    before using the by statement. In this example, 
    the data was already sorted properly, but it 
    never hurts to be safe. You do not need an id
    statement when converting from wide to long. 
    You specify multiple columns in the var 
    statement rather than a single column when 
    converting from a wide format.; 


* Always remember to close your pdf file;


ods pdf close;

* 5507-02-simon-continuous-variables.sas
  author: Steve Simon
  date: created 2021-05-30
  purpose: to work with continuous variables
  license: public domain;

* datasets created in this program
    body, original data
    body1, row with ht=29.5 removed
    body2, ht=29.5 converted to missing
    body3, ht_cm calculated;


* Comments on the code: Documenting your program.

The demo programs in class will provide a short
explanation of pretty much every new piece of
SAS code. You can strip these comments out in
your program. 

Do not use so many comments in YOUR code. It is 
still a good idea, however, to include comments
on the code for anything unusual or  difficult 
in SAS to remind yourself and others what is 
going on.

If you borrowed and adapted any code you found
on the Internet, you should also document where 
you found it.

If you used a large language model to generate
SAS code, you should acknowledge this and 
include the prompt(s) that you used.;


filename rawdata
  "../data/fat.txt";

libname module02
  "../data";

ods pdf file=
  "../results/5507-02-simon-demo.pdf";


* Comments on the code: Specifying file locations

You should already be familiar with this.

The filename statement tells you where the raw data
is stored.

The libname statement tells you where SAS will 
store any permanent datsets.

The ods statement tells you that SAS is going to
store the results with a particular filename and
use pdf format.;


data module02.body;
  infile rawdata;
  input 
    case
    fat_brozek
    fat_siri
    dens
    age
    wt
    ht
    bmi
    ffw
    neck
    chest
    abdomen
    hip
    thigh
    knee
    ankle
    biceps
    forearm
    wrist;


* Comments on the code: Reading in the data

This is the code to input all the variables in
this data set. The infile statement refers to 
a location defined with the earlier filename
statement.;


label
    case="Case number"
    fat_brozek="Fat (Brozek's equation)"
    fat_siri="Fat (Siri's equation)"
    dens="Density"
    age="Age (yrs)"
    wt="Weight (lbs)"
    ht="Height (inches)"
    bmi="Body mass index (kg/m^2)"
    ffw="Fat Free Weight (lbs)"
    neck="Neck circumference (cm)"
    chest="Chest circumference (cm)"
    abdomen="Abdomen circumference (cm)"
    hip="Hip circumference (cm)"
    thigh="Thigh circumference (cm)"
    knee="Knee circumference (cm)"
    ankle="Ankle circumference (cm)"
    biceps="Biceps circumference (cm)"
    forearm="Forearm circumference (cm)"
    wrist="Wrist circumference (cm)";
run;


* Comments on the code: Adding labels

The label subcommand is part of the data step. 
Specify the variable name and follow the
equal sign with a longer description in
quotes. You can use space, punctuation, and
special symbols.;


* Some additional details about this data:

  Brozek's equation is 457/Density - 414.2

  Siri's equation is 495/Density - 450

  Abdomen circumference is measured at the
  umbilicus and level with the iliac crest

  Wrist circumference is distal to the 
  styloid processes;
    
    
* Comments on the code: Adding extra information

I am including some additional details that would
not fit easily into the variable labels. How much
documentation you include is a judgment call. I 
am including this extra documentation just to 
remind you that such documentation is possible.;


proc print
    data=module02.body(obs=10);
  var case fat_brozek fat_siri dens age;
  title1 "Ten rows and five columns";
  title2 "of the body data set";
  footnote1 "Created by Steve Simon on &sysdate using SAS &sysver";
run;


* Comments on the code: The footnote subcommand

The footnote statement is part of any SAS proc.
It places information at the bottom of the page
of any output produced by that proc. It is a 
conventient place to note who wrote the program, 
when it was run (using the sysdata macro variable),
and what version of SAS was used (using the &sysver
macro variable).;


proc contents
    data=module02.body;
  title1 "Internal description of body dataset";
run;


* Comments on the code: Displaying metadata

The contents procedure produces information about
any dataset produced by SAS, including both 
temporary datasets (one part names) and permanent
datasets (two part names).

For a dataset that you just created and one that
is not all that complicated, using proc contents
is overkill. I am showing it so you will know how
to use proc contents for very complex datasets,
especially ones that were created by someone other 
than yourself.

SAS produces a lot of information
and much of it is only relevant for advanced
applications. You have to wade through the details
to get the important information. The important 
information is

-   date created,
-   date modified,
-   observations,
-   variables, and
-   filename.;

*---------------- End of part 1 ----------------;


proc means
    n mean std min max
    data=module02.body;
  var ht;
  title1 "Descriptive statistics for ht";
  title2 "The mean is normal for adults";
  title3 "The standard deviation shows tightly packed data";
  title4 "The maximum value is reasonable";
  title2 "The minimum is very low";
run;


* Comments on the code: Computing simple statistics

The means procedure will produce descriptive 
statistics for your data. By default, it will
produce the count of non-missing values, the 
mean, the standard deviation, and the minimum 
and maximum values, but I am listing them 
explicitly here, just for show.

The data option tells SAS which data set you want 
descriptive statistics on, and the var statement 
tells SAS which variable(s) you want descriptive 
statistics on.;

*---------------- End of part 2 ----------------;


proc sort
    data=module02.body;
  by ht;
run;

proc print
    data=module02.body(obs=1);
  title1 "The row with the smallest ht";
  title2 "Note the inconsistency with wt";
run;


* Comments on the code: Printing row with smallest value

The sort procedure will take a dataset specified
by data= and arrange the data in order from
smallest to largest using the variable specified
in the by subcommand.

If you want to store the sorted data in a different
location, use the out= option;


proc sort
    data=module02.body;
  by descending ht;
run;

proc print
    data=module02.body(obs=1);
  title1 "The row with the largest ht";
  title2 "This seems quite normal to me";
run;


* Comments on the code: Printing row with largest value

The descending option sorts the data in reverse 
order.;

*---------------- End of part 3 ----------------;


data module02.body1;
  set module02.body;
  if ht = 29.5 then delete;
run;


* Comments on the code: Removing a row of data

The if ... then subcommand inside a data step will
evaluate a logical comparison betweeh if and then
and execute the subcommand following then only if
the logical comparison evaluates to true.

The delete subcommand remove a row from the dataset;


data module02.body2;
  set module02.body;
  if ht=29.5 then ht=.;
run;


* Comments on the code: Converting outlier to missing

This code converts the height to a missing value,
but keeps the rest of the variables for that
particular subject.;


proc print
    data=module02.body2;
  where ht < 0;
  title1 "Printing negative values for ht (wrong way)";
  title2 "Use where ht ^= . & ht < 0 instead";

run;


* Comments on the code: Printing negative values (wrong way)

The where subcommand processes the data in a SAS
procedure and only includs that data in the 
procedure if the logical comparison evaluates to 
true. 

This code is actually an example of what you should
NOT do, because missing values will produce a true
result for less than comparisons and false results
for a greater than comparison. You should always
include a check for missingness as part of any
logical comparison.;


proc means
    n nmiss mean std min max
    data=module02.body2;
  var ht;
  title1 "There is one missing value";
run;


* Comments on the code: Counting missing values

If you are concerned at all about missing values
(and you should be), ask for the number of missing
values in proc means using nmiss.;

*---------------- End of part 4 ----------------;


data module02.body3;
  set module02.body;
  check_bmi = (wt / 2.2) / (ht / 39.37)**2;
  check_ht = sqrt((wt / 2.2) / bmi) * 39.37;
  check_wt = (bmi * (ht / 39.37)**2) * 2.2;
run;

proc print 
    data=module02.body3;
  var ht check_ht wt check_wt bmi check_bmi;
  where ht=29.5;
  title1 "Recalculating ht, wt, and bmi";
  title2 "Assuming two out of three are correct.";
run;


* Comments on the code: Transforming values

Transform variables inside of a data step using
standard computer formulas. SAS uses a double
astersk (**) instead of a caret (^) to denote
raising to a power.;

*---------------- End of part 5 ----------------;


proc sgplot
    data=module02.body2;
  histogram ht;
  title1 "Histogram with default bins";
run;


* Comments on the code: Drawing a histogram (default)

The sgplot procedure produces a wide range of
visualizations. The histogram subcommand will
produce a histogram.;


proc sgplot
    data=module02.body2;
  histogram ht / binstart=60 binwidth=1;
  title "Histogram with narrow bins";
run;


* Comments on the code: Drawing a histogram (more bars)

The binstart option tells SAS that one of the bins
(not necessarily the first one) starts at 60. The 
bindwidth option tells SAS that each bin has a 
width of 1 unit (or plus or minus 0.5 units);


proc sgplot
    data=module02.body2;
  histogram ht / binstart=60 binwidth=5;
  title "Histogram with wide bins";
run;


* Comments on the code: Drawing a histogram (fewer bars)

This code produce wider bins, 5 units (or plus
or minus 2.5 inches).;


*---------------- End of part 6 ----------------;


proc corr
    data=module02.body2
    noprint
    outp=correlations;
  var fat_brozek fat_siri;
  with neck -- wrist;
run;


* Comments on the code: Computing correlations (default)

The corr procedure produces correlations. The noprint
keytword tells SAS to not print anything. The noprint
option is commonly used when a SAS proc is used to
produce a new dataset rather than output. 

The outp option tells the procedure which dataset
to create that will contain the correlations.

The var subcommand tells SAS what variables to
correlate.

If there is no with subcommand, the variables 
identified in var are correlated with each other
in a square correlation matrix.

If there is a with subcommand, the corr procedure
will produce a rectangular matrix correlating 
each varialbe in var with each variable in with.

The double dash (--) tells SAS to use neck, wrist
and every variable in between them.;


data correlations;
  set correlations;
  if _type_ NE "CORR" then delete;
  drop _type_;
  fat_brozek=round(fat_brozek, 0.01);
  fat_siri=round(fat_siri, 0.01);
run;


* Comments on the code: Processing correlations

The output dataset in SAS includes a lot of 
descriptive statistics other than just the 
correlations. The if ... then statement will
delete anything other than a correlation.

The drop subcommand will remove the _type_
variable, as it is no longer needed.

The round function will round to the nearest
multiple of 0.01.;


proc sort
    data=correlations;
  by descending fat_brozek;
run;

proc print 
    data=correlations;
  title1 "Abdomen, hip, and chest show the strongest correlations";
run;


* Comments on the code: Sorting the correlations

While not required, sorting the correlations can
sometimes help interpretability.;

*---------------- End of part 7 ----------------;


proc sgplot
    data=module02.body2;
  scatter x=abdomen y=fat_brozek;
  pbspline x=abdomen y=fat_brozek;
  title1 "Simple scatterplot shows a strong positive trend";
  title2 "It levels off for high values.";
  title3 "This may be due solely to a single outlier on the high end";
run;


* Comments on the code: Drawing a scatterplot

The scatter subcommand in the sgplot procedure
produces a scatterplot. 

The pbspline subcommand adds a smoothing to help
you visualize whether the trend is linear or not.;


ods pdf close;


* Comments on the code: Closing the pdf file

I always seem to forget this last statement and 
then I get upset with SAS for not providing the 
PDF output. But SAS can't produce the PDF output
until you tell it you are done. So don't yell at
your computer when it's your own darn fault 
(just like Jimmy Buffet in the Margaritaville
song).

If you don't get any pdf file when you are done,
or your pdf file is the one left over from a
previous analysis, it's probably because you
forgot this last very important statement.;

*---------------- End of part 8 ----------------;

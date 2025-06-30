* 5507-05-simon-working-with-a-mix-of-variables.sas
  author: Steve Simon
  date created: 2018-11-27
  purpose: to illustrate how to work with
    data that has a mix of categorical and
    continuous variables.
  license: public domain;


* Comments on the code: Documentation header;


%let path=q:/5507-2025b/05;

ods pdf
  file="&path/results/5507-05-simon-working-with-mix-of-variables.pdf";

filename raw_data
  "&path/data/fev.txt";

libname perm
  "&path/data";


* Comments on the code: File locations;


data perm.fev;
  infile raw_data delimiter=",";
  input 
    age 2-3
    fev 5-11
    ht 12-16
    sex 19
    smoke 25;
  label
    age=Age in years
    fev=Forced Expiratory Volume (liters)
    ht=Height in inches
    sex=Sex
    smoke=Smoking status
  ;
run;


* Comments on the code: Reading the data using a data step

The data file is comma delimited and the first 
row includes variable names.

Normally, this means that you can save a bit of
time by using proc import, but I chose to read
in the data using a data step. The number of 
variables was so small that this didn't matter
that much. It also allowed me to define 
variable labels in the initial data step rather
than later.;


proc format;
  value fsex
    0 = "Female"
    1 = "Male"
  ;
  value fsmoke
    0 = "Nonsmoker"
    1 = "Smoker"
  ;
run;


* Comments on the code: Label your categorical variables;


proc print
    data=perm.fev(obs=10);
  format 
      sex fsex. 
      smoke fsmoke.;
  title1 "Pulmonary function study";
  title2 "There are no obvious problems with this dataset";
run;


* Comments on the code: Print the first ten rows of data

It's always a good idea to peek at the first few
rows of data.

*---------------- End of part 1 ----------------;


proc freq
    data=perm.fev;
  tables sex smoke / missing;
  format 
      sex fsex. 
      smoke fsmoke.;
  title2 "Frequency counts";
run;


* Comments on the code: Get statistics for categorical variables;


proc means
    n nmiss mean std min max
    data=perm.fev;
  var age fev ht;
  title2 "Descriptive statistics";
run;


* Comments on the code: Get statistics for continuous variables;

*---------------- End of part 2 ----------------;


proc corr
    data=perm.fev
    noprint
    outp=correlations;
  var age fev ht;
run;


* Comments on the code: Compute a correlation matrix;


data correlations;
  set correlations;
  if _type_ NE "CORR" then delete;
  drop _type_;
  age=round(age, 0.01);
  fev=round(fev, 0.01);
  ht=round(ht, 0.01);
run;


* Comments on the code: Round the correlations;


proc print 
    data=correlations;
  title2 "All variables show a positive correlations";
run;


* Comments on the code: Print the correlations

With a small number of variables, there 
is no need to sort the correlations when
there are just a few of them.;


proc sgplot
    data=perm.fev;
  scatter x=age y=fev /
      markerattrs=(size=10 symbol=circle);
  pbspline x=abdomen y=fat_brozek /
      lineattrs=(pattern=dash color=red)
      nomarkers;
  title2 "There is a positive association, close to linear";
run;


* Comments on the code: Draw scatterplots;

*---------------- End of part 3 ----------------;

ods graphics / height=1.5 in width=6 in;

proc sgplot
    data=perm.fev;
  hbox fev / category=smoke;
  format smoke fsmoke.;
  title2 "Smokers tend to have higher fev values";
  title3 "This is a surprising and counter-intutive finding";
run;


* Comments on the code: Draw a boxplot;


proc sort
    data=perm.fev;
  by smoke;
run;

proc means
    data=perm.fev;
  var fev;
  by smoke;
  title2 "Descriptive statistics by group";
run;


* Comments on the code: Compute statistics with a by statement;

*---------------- End of part 4 ----------------;


proc sgplot
    data=perm.fev;
  hbox age / category=smoke;
  format smoke fsmoke.;
  title2 "Boxplots";
run;


* Comments on the code: Investigate unusual trend with boxplots;


proc sort
    data=perm.fev;
  by smoke;
run;

proc means
    data=perm.fev;
  var age;
  by smoke;
  format smoke fsmoke.;
  title2 "Descriptive statistics by group";
run;

ods pdf close;


* Comments on the code: Investigate unusual trend with descriptive statistics;

*---------------- End of part 5 ----------------;

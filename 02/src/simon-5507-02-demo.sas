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

In general, the comments you see on the code are
intended to help explain what SAS is doing. You can
and should remove these if you re-use this code in one
of your programming assignments. You should, however,
get in the habit of documenting any unusual bits of SAS 
code in all of your future programs. Only the unusual
code. This is partly for the benefit of anyone who
ends up working with your code. It's also for the 
benefit of you. Six months from now, you will dust
this code off and you'll wonder: what was I thinking
when I wrote this unusual code.;


filename rawdata
  "../data/fat.txt";

libname module02
  "../data";

ods pdf file=
  "../results/5507-02-simon-continuous-variables.pdf";


* Comments on the code: Specifying file locations

You should already be familiar
with this. The filename statement tells you where
the raw data is stored. The libname statement
tells you where SAS will store any permanent 
datsets. The ods statement tells you that SAS is 
going to store the results with a particular 
filename and in pdf format.;


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

SAS offers an opportunity for you to add 
documentation to your program about individual
variables. These are called variable labels. 
They have almost no restrictions. You can use 
blanks, or special symbols like a dollar sign 
or a dash. The documentation that variable labels 
provide is mostly internal, but these labels are 
substituted in a few places like some graphs.

I strongly recommend use of variable labels and 
will require them for any homework you submit in 
this class. See the grading rubric for details.

What makes a good variable label? First take 
advantage of a mixture of upper and lower case 
to make your labels more readable. Spell out any 
abbreviations, even obvious abbreviations. If 
your variable has a measurement unit, specify 
that unit in your variable label. If there are 
other important details, put these in the 
variable label as well.

Every variable in a SAS program should have a 
label. This label will make some (but not all) 
of the SAS output more readable. it is also part 
of the internal documentation of your program. 
Note that some of these labels do not fit well 
in this Powerpoint slide, but that's okay.;


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


* Comments on the code: Printing a small piece of data

It's always a good idea to print out a small 
piece of your data to make sure everything is
okay.
  
The data option tells SAS what data set you want 
to print. If you omit this, SAS will print the 
most recently created data set.
  
The obs=10 option limits the number of rows 
printed to the first 10. For large data sets, you 
should always take advantage of this option.
  
The var statement limits the variables that you 
print to those that you specify. Again, this is 
important for large data sets. 

Please do not ever print more than ten rows or 
more than five variables, if you can help it. 
Excessively lengthy outputs will lose you a few 
points (see the grading rubric).
  
The title statement tells SAS to provide a 
descriptive title at the top of the page of 
output.
  
The run statement says you're done with the 
procedure.;


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

First, let's look at this value in the context of
the other values in this row of data.

You do this by sorting the data so that the 
shortest subject becomes the first row of the 
data and the tallest subject becomes the last. 
Then print just the very first row of your data.

Warning! Be careful about sorting your data if 
you can't get the data easily back to the 
original order. It might be okay, but there are 
times when you'd like your data all the way back 
and that means data in the original order. This 
data set has a case variable that you can resort 
by in order to get back ot the original order.

If you don't have a case variable, store the 
sorted data in a separate location: something 
along the lines of proc sort data=x out=y.

With this outlier on the low end, you might 
consider doing nothing other than noting the 
unusual value.

Alternately, you could delete the entire row 
associated with this value. Finally, you might 
consider converting the small ht value to a 
missing value code.

There is no one method that is preferred in this 
setting. If you encounter an unusual value, you 
should discuss it with your research team, 
investigate the original data sources, if 
possible, and review any procedures for handling 
unusual data values that might be specified in 
your research protocol.

Your data set may arrive with missing values in 
it already. Data might be designated as missing 
for a variety of reasons (lab result lost, value 
below the limit of detection, patient refused to 
answer this question) and how you handle missing 
values is way beyond the scope of this class. 
Just remember to tread cautiously around missing 
values as they are a minefield.

Notice that I store the revised data sets with 
the row removed and with the 29.5 replaced by a 
missing value in different data frames. This is 
good programming practice. If you ever have to 
make a destructive change to your data set (a 
change that wipes out one or more values or a 
change that is difficult to undo), it is good 
form to store the new results in a fresh spot. 
That way, if you get cold feet, you can easily 
backtrack.

We'll use the data set with the 29.5 changed to a 
missing value for all of the remaining analyses 
of this data set.

Logic statements involving missing value codes 
are tricky. SAS stores missing value codes as the 
most extreme legal negative number. So if you 
want, for example, to exclude negative values, 
make sure that you account for missing values as 
well.

   (ht < 0) & (ht ~= .);


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

Just for the sake of completeness, let's look at
the row of data with the largest height value. 
Add the keyword desc to sort the data in reverse
order.;

*---------------- End of part 3 ----------------;

data module02.body1;
  set module02.body;
  if ht > 29.5;
run;


* Comments on the code: Removing a row of data

This code removes the entire row of data. Notice
that I store the modified data under a new name. 
That way, if I regret tossing the entire row out, 
I can easily revert to the original data.;


data module02.body2;
  set module02.body;
  if ht=29.5 then ht=.;
run;


* Comments on the code: Converting outlier to missing

This code converts the height to a missing value,
but keeps the original data.

There is no one method that is preferred in 
this setting. If you encounter an unusual value, 
you should discuss it with your research team, 
investigate the original data sources, if 
possible, and review any procedures for handling 
unusual data values that might be specified in 
your research protocol.

Your data set may arrive with missing values in 
it already. Data might be designated as missing 
for a variety of reasons (lab result lost, value 
below the limit of detection, patient refused to 
answer this question) and how you handle missing 
values is way beyond the scope of this class. 
Just remember to tread cautiously around missing 
values as they are a minefield.

Notice that I store the revised data sets with 
the row removed and with the 29.5 replaced by a 
missing value in different data frames. This is 
good programming practice. If you ever have to 
make a destructive change to your data set (a 
change that wipes out one or more values or a 
change that is difficult to undo), it is good 
form to store the new results in a fresh spot. 
That way, if you get cold feet, you can easily 
backtrack.

We'll use the data set with the 29.5 changed to a 
missing value for all of the remaining analyses 
of this data set.;


proc print
    data=module02.body2;
  where ht < 0;
  title1 "Printing negative values for ht (wrong way)";
  title2 "Use where ht ^= . & ht < 0 instead";

run;


* Comments on the code: Printing negative values (wrong way)

Here's an important thing to remember about 
missing values. SAS stores missing value codes as
the most extreme legal negative number. This can 
sometimes lead to surprising and misleading 
results.

Every procedure in SAS has its own default 
approach to missing values and often provides you 
with one or more alternatives. You have to review 
this carefully for each and every statistical 
procedure that you run. If you do data 
manipulations involving missing values, you have 
to make sure that the result correctly reflects 
what you want.

In order to prevent this from happening, you need 
to check for missingness before applying any 
other logic statement.

You may hate having to do this and wish that SAS 
would have handled things differently. Different 
packages, like R, have a three valued logic 
system where every logic statement (well, almost
every logic statement) involving missing values 
codes to MISSING rather than to TRUE or FALSE. 
This sometimes works better, but sometimes the 
SAS approach works better.;


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
  set module02.body2;
  ht_m = ht / 39.37;
  wt_kg = wt / 2.2;
  check_bmi = wt_kg / ht_m**2;
run;

proc print 
    data=module02.body3(obs=10);
  var ht ht_m wt wt_kg bmi check_bmi;
  title1 "Original and converted units";
run;


* Comments on the code: Transforming values

You can do simple transformations like unit 
conversions in SAS. Create a new dataset with the
data statement. Use the set command to tell SAS
that you plan to use and modify an existing 
dataset.

The conversion done here will turn weight into kilograms.;

*---------------- End of part 5 ----------------;

proc sgplot
    data=module02.body3;
  histogram ht;
  title1 "Histogram with default bins";
run;


* Comments on the code: Drawing a histogram (default)

Here is the code to create a histogram with the
default option. Generally, it is wise to modify 
the defaults for any graphic image.;


proc sgplot
    data=module02.body3;
  histogram ht / binstart=60 binwidth=1;
  title "Histogram with narrow bins";
run;


* Comments on the code: Drawing a histogram (more bars)

Here's the code to create a histogram with many
bars. The first bar is centered at 60, and each
bin has a width of 1 inch (plus or minus 0.5
inches);


proc sgplot
    data=module02.body3;
  histogram ht / binstart=60 binwidth=5;
  title "Histogram with wide bins";
run;


* Comments on the code: Drawing a histogram (fewer bars)

Here's the code to create a 
histogram with few bars. The first bar is again
centered at 60, but now each bin has a width of
5 inches (plus or minus 2.5 inches).

There is no "correct" version of the histogram. 
Try several widths and see which one gives the 
clearest picture of your data.;

*---------------- End of part 6 ----------------;

proc corr
    data=module02.body3
    noprint
    outp=correlations;
  var fat_brozek fat_siri;
  with neck -- wrist;
run;


* Comments on the code: Computing correlations (default)

Here's the code to compute correlations. 

The output here really annoys me. The excessive number
of decimals makes this table hard to read. So I include 
the noprint option and store the correlations in as data
so I can round and reorder the data.;


data correlations;
  set correlations;
  if _type_="CORR";
  drop _type_;
  fat_brozek=round(fat_brozek, 0.01);
  fat_siri=round(fat_siri, 0.01);
run;


* Comments on the code: Processing correlations

The output dataset in SAS includes a lot of 
descriptive statistics other than just the 
correlations. Select only those rows of data
where _type_ equals "CORR". Once this is done,
you no longer need the _type_ variable.

The round function will round the data to the
nearest hundredths.;


proc sort
    data=correlations;
  by descending fat_brozek;
run;

proc print 
    data=correlations;
  title1 "Abdomen, hip, and chest show the strongest correlations";
run;


* Comments on the code: Sorting the correlations

It also helps to sort the correlations from high to low before printing.

*---------------- End of part 7 ----------------;

proc sgplot
    data=module02.body3;
  scatter x=abdomen y=fat_brozek;
  pbspline x=abdomen y=fat_brozek;
  title1 "Simple scatterplot shows a strong positive trend";
  title2 "It levels off for high values.";
  title3 "This may be due solely to a single outlier on the high end";
run;


* Comments on the code: Drawing a scatterplot

A scatterplot is also useful for examining the
relationship among variables. You can produce 
scatterplots several different ways, but the 
scatterplots produced by the sgplot procedure 
have the most flexibility.

The pbspline subcmmand produces a smoothing 
spline. It helps you visualize whether the 
trend is linear or not.;


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

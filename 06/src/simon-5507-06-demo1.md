

## Documentation header


```{}
    simon-5507-06-demo1.sas
    author: Steve Simon
    date created: 2026-06-25
    purpose: to illustrate managing multiple datasets
    license: public domain;

```




## File locations


```{}
%let path=q:/5507-2025b/06;

ods pdf 
    file= "&path/results/simon-5507-06-demo1.pdf";

libname storage 
    "&path/data/";

```




## More file locations


```{}
filename d70yr
    "&path/data/draft70yr.dat.txt";

filename d71yr
    "&path/data/draft71yr.dat.txt";
  
filename d70mn
    "&path/data/draft70mn.dat.txt";

```




## Read tab delimited files


```{}
data storage.draft70yr;
    infile d70yr;
    input
        day_of_year
        draft_order
        month;
run;

data storage.draft71yr;
    infile d71yr;
    input
        day_of_year
        draft_order
        month;
run;

```




## Print the first few rows


```{}
proc print
    data=storage.draft70yr (obs=10);
    title1 "First ten rows of the 1970 draft lottery data";
    title2 "Using a year long format";
    footnote "Steve Simon, 2026-06-25, SAS version 9.4";
run;

proc print
    data=storage.draft71yr (obs=10);
    title1 "First ten rows of the 1971 draft lottery data";
    title2 "Using a year long format";
run;

```




## Create small subsets of the data


```{}
data dec_1970a;
    set storage.draft70yr;
	if month=12;
	year=1970;
run;

data dec_1971a;
    set storage.draft71yr;
	if month=12;
	year=1971;
run;

```




::: {.notes}

The if statement without a condition tells
    SAS to include rows only if the logical condition evaluates to
    true. You need to add a year variable before combining the data to
    avoid ambiguities.

:::




## Stack the two datasets one beneath the other


```{}
data dec_stack1;
    set dec_1970a dec_1971a;
run;

proc print
    data=dec_stack1 (obs=10);
	title1 "First ten rows of stacked data";
run;

```




::: {.notes}

If you place more than one dataset in the set
    statement, SAS will combine the datasets one beneath the other.

:::




## Boxplot for comparing 1970 and 1971 draft orders


```{}
ods graphics / 
    height=2.5 in width=6 in;

proc sgplot
    data=dec_stack1;
  hbox draft_order / category=year nofill;
  yaxis label=" ";
  title1 "The draft orders are much smaller in 1970";
  title3 "and the median, which should be around half of 366";
  title4 "is closer to 100";
run;

ods graphics on / reset=all;

```




## Create small subsets of the data


```{}
data dec_1970b (rename=(draft_order=draft_order_1970));
    set storage.draft70yr;
	if month=12;
run;

data dec_1971b (rename=(draft_order=draft_order_1971));
    set storage.draft71yr;
	if month=12;
run;

```




::: {.notes}

When you stack the data side by side, it is the
    common variable name (draft_order) that can create an ambiguity.
    You can avoid this by renaming the variables to distinct names 
    before combining them.

:::




## Stack the two datasets side by side and print the results


```{}
data dec_stack2;
   merge dec_1970b dec_1971b;
run;

proc print
    data=dec_stack2(obs=10);
	title1 "Partial listing of side by side stacked data";
run;

```




## Read a fixed width file


```{}
data storage.draft70mn;
    infile d70mn;
    input
        jan_order 3-5
        feb_order 7-9
        mar_order 11-13
        apr_order 15-17
        may_order 19-21
        jun_order 23-25
        jul_order 27-29
        aug_order 31-33
        sep_order 35-37
        oct_order 39-41
        nov_order 43-45
        dec_order 47-49;
	day_of_month=_n_;
run;

```




## Print a small piece of the data.


```{}
proc print
    data=storage.draft70mn;
	var jan_order -- may_order;
    title1 "First five columns of the 1970 draft lottery data";
    title2 "Using a month long format";
run;

```




::: {.notes}

Notice that the months with less than 31 days
    have missing values.

:::




## Convert monthly data to yearly data


```{}
proc transpose 
    data=storage.draft70mn
    out=stack3 (rename=(col1=draft_order));
	var jan_order -- dec_order;
	by day_of_month;
run;

proc print
   data=stack3;
   title1 "Listing of transposed draft70mn";
run;

```




## Add day_of_month column


```{}
data day_of_month;
  infile "&path/data/day_of_month.txt";
  input day_of_month;
run;

data storage.draft70yr;
    set storage.draft70yr;
	merge day_of_month;
run;

```




## Convert yearly data to monthly data


```{}
proc sort
    data=storage.draft70yr;
	by day_of_month month;
run;

proc transpose
    data=storage.draft70yr
    out=stack4
    prefix=Month;
	id Month;
	by day_of_month;
	* var draft_order;
run;

proc print
    data=stack4;
run;

```




## Don't forget to close your PDF file


```{}
ods pdf close;

```





## Documentation header

    todd-5507-06-demo.sas
    author: Reagan Todd
    date created: 2025-09-09
    purpose: to understand how to manipulate data widths.
    license: public domain




## File locations


```{}
%let path=q:/5507-2025b/06;

ods pdf 
    file= "&path/results/todd-5507-06-demo.pdf";

libname storage 
    "&path/data/";

filename bmTall
    "&path/data/balance-measures-tall.txt";
  
filename bmWide
    "&path/data/balance-measures-wide.txt";

```




## Read tall format


```{}
data storage.bmTall;
    infile bmTall delimiter= "09"X firstobs=2;
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

```




## Print data and metadata


```{}
proc print
    data=storage.bmTall (obs=12);
    title1 "first ten rows of the tall balance data";
    footnote "Reagan Todd, 2025-09-09, SAS version 9.4";
run;

proc contents data=storage.bmTall;
    title1 "Contents of the tall balance data";
run;

```




## Read wide format


```{}
data storage.bmWide;
    infile bmWide delimiter= "09"X firstobs=2;
    input
        Subject
        Sex $
        Age
        Height
        Weight
        N01
        N02
        NC1
        NC2
        ND1
        ND2
        F01
        F02
        FC1
        FC2
        FD1
        FD2;
run;

```




## Print data and metadata


```{}
proc print
    data=storage.bmWide (obs=10);
    title1 "first ten rows of the wide balance data";
run;

proc contents data=storage.bmWide;
    title1 "Contents of the wide balance data";
run;

```




## Create time constant data from tall format


```{}
data storage.time_constant_tall;
    set storage.bmTall;
    keep Subject Sex Age Height Weight;
run;

proc sort
    data=storage.time_constant_tall nodup;
	by _all_;
run;

proc print
   data=storage.time_constant_tall (obs=10);
   title "First ten rows of time constant data";
run;

```




::: {.notes}

The nodup option removes
    duplicate observations. There is now only one
    row per patient. It is very important to keep
    the subject number in this and any other data
    subsets from either the tall format or the
    wide format.

:::




## Create time varying data from tall format


```{}
data storage.time_varying_tall;
    set storage.bmTall;
	keep Subject Surface Vision CTSIB;
run;

proc print
   data=storage.time_varying_tall (obs=10);
   title "First ten rows of time constant data";
run;

```




::: {.notes}

Getting the time-varying
    data from the tall format requires no special
    effort. You must always include the subject
    number, even though it is not time varying.

:::




## Creating time constant data from wide format


```{}
data storage.time_constant_wide;
    set storage.BMWide;
    keep Subject Sex Age Height Weight;
run;

proc print
   data=storage.time_constant_wide (obs=10);
   title "First ten rows of time constant data";
run;

```




::: {.notes}

There is no need to remove
    duplicates here because the wide format
    alraady has just one row per patient.

:::




## Creating time varying data from wide format


```{}
data storage.time_varying_wide;
    set storage.BMWide;
    keep Subject NO1 NO2 NC1 NC2 ND1 ND2 FO1 FO2 FC1 FC2 FD1	FD2;
run;

proc print
   data=storage.time_varying_wide (obs=10);
   title "First ten rows of time constant data";
run;

```




::: {.notes}

Notice that the time 
    varying data looks different from the 
    previous example. You will need to use proc
    transpose to convert one format to the 
    other.

:::




## Always remember to close your pdf file


```{}
ods pdf close;

```



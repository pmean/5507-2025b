## Documentation header

```{}
    simon-5507-08-demo3.sas
    author: Steve Simon
    date created: 2026-07-24
    purpose: to illustrate datetime manipulations
    license: public domain;
```

## File locations

```{}
%let path=q:/5507-2025b/08;

ods pdf 
    file= "&path/results/simon-5507-08-demo3.pdf";

 
* Comments on the code: In this program, there is
    no libname statement or filename statement. The
	program creates a few small datasets from scratch.
```

## Time the calculation of pi

```{}
data pi_approximations;
  t1 = time();
  pix=0;
  do i=0 to 1e9;
    pix=pix+4*(-1)**i/(2*i+1);
  end;
  t2 = time();
  compute_time=t2-t1;
  output;
run;

proc print
    data=pi_approximations;
  format pix 15.10;
  var pix t1 t2 compute_time;
  title1 "Approximations to pi";
  title2 "David H. Bailey, 2021-12-10";
  title3 "A catalogue of mathematical formulas involving p, with analysis";
run;
```


::: {.notes}
The formula used here to
    approximate pi is not the best choice as it
    converges slowly. The loop do i=0 to 1e9 runs
    through one billion iterations. The times
    before and after the do loop are tracked
    using the time function and the difference
    between the two values is a measure of how
    much time has elapsed. In SAS, this is not
    really needed here as the time for each 
    data step and proc is noted in the log.
:::

## Calculate current date and time

```{}
data current_date_and_time;
  dt = datetime();
  output;
run;

proc print
    data=current_date_and_time;
  title1 "Current date and time";
run;

proc print
    data=current_date_and_time;
  format dt datetime20.2;
  title1 "Current date and time";
run;
```


::: {.notes}
The datetime function
    produces a datetime value representing the
    current date and time. If you do not use a
    format statement, SAS will display this as
    the number of seconds since midnight.
:::

## Separate date and time and display both in a title

```{}
data separate_time_and_date;
  set current_date_and_time;
  d = put(datepart(dt), yymmdd10.);
  t = put(timepart(dt), hhmm5.);
  call symput("current_date",d);
  call symput("current_time",t);
run;

proc print
    data=separate_time_and_date;
  title1 "This program was run on &current_date at &current_time";
run;
```


::: {.notes}
The datepart and
    timepart functions split the datetime
    value into the date and the time. The
    put statement reformats these values as
    strings and the symput function converts
    the values into macro variables. You can
    then place the macro variables in a 
    title statement.
:::

## Don't forget to close your PDF file

```{}
ods pdf close;
```


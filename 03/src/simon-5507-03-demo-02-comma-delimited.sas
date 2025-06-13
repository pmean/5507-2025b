* 5507-03-simon-import-comma-delimited.sas
* author: Steve Simon
* creation date: 2019-07-01
* purpose: to import comma delimited files
* license: public domain;


%let path=q:/introduction-to-sas;

ods pdf file=
    "&path/results/5507-03-simon-import-comma-delimited.pdf";

libname perm
    "&path/data";

filename raw_data
    "&path/data/comma-delimited.csv";


* Comments on the code: Using a macro variable to specify the location of your files

The %let command defines a macro variable. In this case, 
the macro variable path is set equal to the string
q:/introduction-to-sas. Then that value is inserted
in the ods, libname, and filename commands.;


data perm.comma_delimited;
  infile raw_data delimiter=",";
  input x y z;
run;


* Comments on the code: Specifying a comma delimiter

Adding the delimiter keyword to the infile
statement informs SAS that individual data
values in a row of text are separated or
delimited by a specific character. In this
code, the delimiter is a comma.


proc print
    data=perm.comma_delimited(obs=2);
  title1 "First two rows of data";
run;

ods pdf close;

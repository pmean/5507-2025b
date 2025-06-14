* 5507-03-simon-demo-07-first-line-names.sas
* author: Steve Simon
* creation date: 2019-07-02
* purpose: to import data with variable names on the first line
* license: public domain;


* Comments on the code: Documentation header

This is my standard for the documentation
header. It specifies the filename, author,
creation date, purpose, and license.;


%let path=q:/5507-2025b/03;

ods pdf file=
    "&path/results/5507-03-simon-demo-07-first-line-names.pdf";

libname perm
    "&path/data";

filename raw_data
    "&path/data/text-first-line-names.csv";


* Comments on the code: File locations

This code shows where to print output,
where to store data, and where to find
data.;


proc import
    datafile=raw_data 
    dbms=dlm
    out=perm.first_line_names 
    replace;
  delimiter=",";
  getnames=yes;
run;

proc print
    data=perm.first_line_names(obs=2);
  title1 "First two rows of data";
run;

ods pdf close;


* Comments on the code: The import procedure

The import procedure works with both 
text files and binary files. The 
data=option tells SAS the location of
the text or binary data

The dbms=delim option tells SAS that 
this is a delimited text file.

The replace option tells SAS that it 
is okay to write this data set on top
of another dataset with the same name,
if it exists.

The delimiter subcommand tells SAS to
use a comma (,) as a delimiter.

The getnames=yes subcommand tells SAS
to use the first line of the file as 
the variable names.;

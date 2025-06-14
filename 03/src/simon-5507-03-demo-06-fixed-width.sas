* 5507-03-simon-import-fixed-width.sas
* author: Steve Simon
* creation date: 2019-07-01
* purpose: to import data in a fixed width format
* license: public domain;


* Comments on the code: Documentation header

This is my standard for the documentation
header. It specifies the filename, author,
creation date, purpose, and license.;


%let path=q:/introduction-to-sas;

ods pdf file=
    "&path/results/5507-03-simon-import-fixed-width.pdf";

libname perm
    "&path/data";

filename raw_data
    "&path/data/fixed-width.txt";


* Comments on the code: File locations

This code shows where to print output,
where to store data, and where to find
data.;


data perm.fixed_width;
  infile raw_data delimiter=",";
  input 
    x 1-2
    y 3-4
    z 5-7;
run;

proc print
    data=perm.fixed_width(obs=2);
  title1 "First two rows of data";
run;

ods pdf close;


* Comments on the code: Reading fixed width data

There are several options for reading 
fixed width data. This code shows how to
use a start and end location for each 
variable. The variable X is located in 
columns 1 and 2. The variable y is 
located in columns 3 and 4. The variable
z uses three columns: 5, 6, and 7.;


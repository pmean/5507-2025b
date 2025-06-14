* 5507-03-simon-demo-05-string-data.sas
* author: Steve Simon
* creation date: 2019-07-02
* purpose: to import data that includes a string
* license: public domain;


* Comments on the code: Documentation header

This is my standard for the documentation
header. It specifies the filename, author,
creation date, purpose, and license.;


%let path=q:/introduction-to-sas;

ods pdf file=
    "&path/results/5507-03-simon-import-string-data.pdf";

libname perm
    "&path/data";

filename raw_data
    "&path/data/string-data.txt";


* Comments on the code: File locations

This code shows where to print output,
where to store data, and where to find
data.;


data perm.string_data;
  infile raw_data delimiter=",";
  input 
    name $
    x
    y;
run;

proc print
    data=perm.string_data(obs=2);
  title1 "First two rows of data";
run;

ods pdf close;


* Comments on the code: Reading string data

use the dollar sign ($) to designate a 
particular variable as being string 
rather than numeric.;

*todd-5507-09-string-manipulation.sas
	author: Reagan Todd
	date created: 2025-10-22
	purpose: to understand how to manipulate strings in SAS.
	license: public domain;

ods pdf file= "/home/u63903237/5507/results/todd-5507-09-string-manipulation.pdf";

libname storage "/home/u63903237/5507/data";

filename amazon
	"/home/u63903237/5507/data/amazon.csv";
proc import datafile=amazon
	out=storage.amazon
	dbms=csv;
	getnames=yes;
run;

data storage.amazon;
    set storage.amazon(keep= rating review_content);
run; 

proc print 
	data=storage.amazon (obs=15);
	title1 "first 15 rows of Amazon data";
	footnote "Reagan Todd, 2025-10-22, SAS version 9.4";
run;


data words_only;
    set storage.amazon;

    *letters + spaces only;
    review_clean = prxchange('s/[^A-Za-z ]//', -1, review_content);

    *insert space in camelCase;
    review_clean = prxchange('s/([a-z])([A-Z])/$1 $2/', -1, review_clean);

    * normalize spaces;
    review_clean = compbl(review_clean);
run;

proc print 
	data=words_only (obs=15);
	title1 "first 15 rows of words from the clean Amazon data";
	footnote "Reagan Todd, 2025-10-22, SAS version 9.4";
run;

*seperate sentences into a rows of single words;
data tokens;
    set words_only; 
    length word $50;
    review_id = _N_;

    i = 1;
    do while(scan(review_clean, i, ' ') ne "");
        word = scan(review_clean, i, ' ');
        output;
        i+1;
    end;

    keep rating review_id word;
run;

data tokens;
    set tokens;
    rename review_clean = word;
run;

proc print data=tokens (obs=15);
title1 "First 15 tokens in the amazon reviews";
run;


*importing positive words and negative words data files;
proc import datafile="/home/u63903237/5507/data/positive-words.txt"
    out=pos_words
    dbms=dlm
    replace;
    delimiter='09'x;
    getnames=no;
run;

data pos_words;
    set pos_words;
    rename var1 = word;
run;

proc print data=pos_words (obs=10);
title1 "First 10 rows of positive words";
run; 

proc import datafile="/home/u63903237/5507/data/negative-words.txt"
    out=neg_words
    dbms=dlm
    replace;
    delimiter='09'x;
    getnames=no;
run;

data neg_words;
    set neg_words;
    rename var1 = word;
run;

proc print data=neg_words (obs=10);
title1 "First 10 rows of negative words";
run;

*concatnation of pos and neg words;
data pos2;
    set pos_words;
    sentiment = +1;
run;

data neg2;
	set neg_words;
	sentiment = -1;
run;

data lexicon;
    set pos2 neg2;
run;

proc print data=lexicon (obs=10);
title1 "Stacked words for analysis and their sentiment";
run;

*inner join of lexicon and words_only;
proc sort data=tokens;
    by word;
run;

proc sort data=lexicon;
    by word;
run;

data joined;
    merge tokens(in=inWords)
          lexicon(in=inLex);
    by word;
    if inWords and inLex;
run;

proc print data=joined (obs=10);
title1 "Joined word list";
run;

*Word frequency of reviews;
proc freq data=joined noprint;
	tables word / out=word_freq;
run;

data count_words;
    set word_freq;
    where COUNT > 5;
run;

proc sort data=count_words;
	by descending count;
run; 

proc print data=count_words;
title1 "Most frequent words in the Amazon reviews";
run;





*Sentiment analysis;
proc sort data=joined; 
    by review_id; 
run;

*have to create a single row for average sentiment per review;
data review_sentiment;
    set joined;
    by review_id;

    retain sum_sent count_sent rating_val;

    *marking each review;
    if first.review_id then do;
        sum_sent = 0;
        count_sent = 0;
        rating_val = rating;
    end;

    *sentiment;
    sum_sent + sentiment;
    count_sent + 1;

    *calculate avg sent. based upon review;
    if last.review_id then do;
        avg_sentiment = sum_sent / count_sent;
        output;
    end;

    keep review_id rating_val avg_sentiment;
run;

proc print data=review_sentiment(obs=15);
title1 "Avgerage sentiment with a single row per review";
run;

*Creating a scatterplot of average sentiment and rating;
proc sgplot data=review_sentiment;
    scatter x=rating_val y=avg_sentiment / jitter transparency=0.4
    markerattrs=(symbol=circlefilled color=blue size=8);
    xaxis label="Rating (Stars)";
    yaxis label="Average Sentiment";
    title "Average Sentiment vs Rating per Review";
    footnote "Reagan Todd, 2025-10-22, SAS Version 9.4";
run;

ods pdf close;




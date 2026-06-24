---
title: "Analyze the Albuquerque housing dataset"
---

## General directions

-   Download the [Albuquerque housing dataset][ref-simon-data]. 
-   Refer to the [data dictionary][ref-simon-dictionary] if needed. 
-   Write a program to read this file and answer the questions listed below.
-   List your name, the date, and the version of SAS as a footnote for all programs.

Your homework assignment will use a data set of housing prices and factors that influence the price. I originally found this data set on the DASL web site, but it has disappeared on me. A nice description of this file is on my own website. Add variable labels for all the variables. You do not need to use proc format  and for the categorical variables, because they are strings.

## Question 1. 

Do any of the variables have missing values? How many?

## Question 2. 

Calculate the mean and standard deviation of price for the two levels of custom_build. How much more do custom built houses cost on average?

## Question 3.

Evaluate the relationship between custom_build and sqft using a boxplot. Do custom built houses tend to be bigger?

Note that this raises the question whether the large difference in average price can be explained by the difference in sizes. The answer is beyond the scope of this class, but would involve analysis of covariance. You are welcome to explore this on your own, but do not submit any of those analyses as part of your official assignment.

## Question 4. 

Are custom built houses more likely to appear on corner lots? Calculate the percentages. Hint: use corner_lot as the rows, custom_build as the columns, and display row percentages.

## Error messages

-   If you get an error message, try to fix things.
    -   See [suggestions if you encounter an error][ref-simon-error]
-   If you can't fix your errors,
    -   Submit your code and a copy of the log window.
    -   Don't be afraid to ask for help.

## Grading

-   This assignment will use [this grading rubric][ref-simon-rubric].

## Your submission format

-   Submit your assignment as a single PDF file. 
    -   Include 
        -   the program code,
        -   the log window, and
        -   the output.
    -   Submitting as separate PDF files is also acceptable.
    -   Please do not submit formats other than PDF.
-   Ask if you need help creating or combining PDF files.

## File details

This assignment was written by Steve Simon on 2025-06-27 and is placed in the public domain.

[ref-simon-data]: https://github.com/pmean/data/blob/main/files/albuquerque-housing.csv
[ref-simon-dictionary]: https://github.com/pmean/data/blob/main/files/albuquerque-housing.yaml
[ref-simon-error]: https://github.com/pmean/classes/blob/master/general/src/suggestions-if-you-encounter-an-error.md
[ref-simon-rubric]: https://github.com/pmean/classes/blob/master/general/src/general-grading-rubric.md

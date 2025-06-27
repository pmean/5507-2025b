---
title: "Analyze the Garadail dataset"
---

## General directions

-   Download the [Gardasil dataset][ref-simon-data]. 
-   Refer to the [data dictionary][ref-simon-dictionary] if needed. 
-   Write a program to read this file and answer the questions listed below.
-   List your name, the date, and the version of SAS as a footnote for all programs.

## Question 1

Display frequency counts for AgeGroup, Race, Completed, Location. Be sure to use proc format to display your frequencies using short text descriptors rather than number codes. Which category occurs most frequently for each variable?

## Question 2

Which variables have missing data and how many of these values are missing.

## Question 3

Draw a bar chart showing the percentage of patients at each of the four locations. Which location has the fewest patients?

## Question 4

Use a crosstabulation to compare Age to AgeGroup. Hint: use Age as the rows and do not display row, column, or cell percents. Are the recodings into AgeGroup done consistently?

## Question 5

Create a new variable that combines the race categories into white, and non-white. Calculate the proportion of white patients at each of the four locations. What location had the greatest proportion of non-white patients? Hint: use the new white/non-white variable as the columns and compute row percents.

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

[ref-simon-data]: https://github.com/pmean/data/blob/main/files/gardasil.tsv
[ref-simon-dictionary]: https://github.com/pmean/data/blob/main/files/gardasil.yaml
[ref-simon-error]: https://github.com/pmean/classes/blob/master/general/src/suggestions-if-you-encounter-an-error.md
[ref-simon-rubric]: https://github.com/pmean/classes/blob/master/general/src/general-grading-rubric.md

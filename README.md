
<!-- README.md is generated from README.Rmd. Please edit that file -->

# LinkedDataTable

<!-- badges: start -->
<!-- badges: end -->

The goal of ‘LinkedDataTable’ is to provide a custom class that defines
operations on collections of ‘data.table’ objects related by a common
column.

## Installation

You can install the development version of ‘LinkedDataTable’ from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("brownag/LinkedDataTable")
```

## Example

This is a basic example demonstrating usage of the ‘LinkedDataTable’
class:

``` r
library(LinkedDataTable)

d <- data.frame(i = 1:26, a = letters, b = LETTERS)
d2 <- expand.grid(d, stringsAsFactors = FALSE)
d2$j <- seq(nrow(d2))

ldt <- LinkedDataTable(list(x = d, y = d2))

ldt
#> LinkedDataTable (ID: i) with 2 tables:
#>   x<26>, y<17576>

ldt[[1]]
#>         i      a      b
#>     <int> <char> <char>
#>  1:     1      a      A
#>  2:     2      b      B
#>  3:     3      c      C
#>  4:     4      d      D
#>  5:     5      e      E
#>  6:     6      f      F
#>  7:     7      g      G
#>  8:     8      h      H
#>  9:     9      i      I
#> 10:    10      j      J
#> 11:    11      k      K
#> 12:    12      l      L
#> 13:    13      m      M
#> 14:    14      n      N
#> 15:    15      o      O
#> 16:    16      p      P
#> 17:    17      q      Q
#> 18:    18      r      R
#> 19:    19      s      S
#> 20:    20      t      T
#> 21:    21      u      U
#> 22:    22      v      V
#> 23:    23      w      W
#> 24:    24      x      X
#> 25:    25      y      Y
#> 26:    26      z      Z
#>         i      a      b

ldt[["y"]]
#>            i      a      b     j
#>        <int> <char> <char> <int>
#>     1:     1      a      A     1
#>     2:     2      a      A     2
#>     3:     3      a      A     3
#>     4:     4      a      A     4
#>     5:     5      a      A     5
#>    ---                          
#> 17572:    22      z      Z 17572
#> 17573:    23      z      Z 17573
#> 17574:    24      z      Z 17574
#> 17575:    25      z      Z 17575
#> 17576:    26      z      Z 17576

ldt1 <- ldt[1, ]
ldt1
#> LinkedDataTable (ID: i) with 2 tables:
#>   x<1>, y<676>

ldt2 <- ldt[2, ]
ldt2
#> LinkedDataTable (ID: i) with 2 tables:
#>   x<1>, y<676>

ldt12 <- ldt1 + ldt2
ldt12
#> LinkedDataTable (ID: i) with 2 tables:
#>   x<2>, y<1352>
```

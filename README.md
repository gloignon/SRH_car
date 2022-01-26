A remix of the Scheirer–Ray–Hare test from the rcompanion package. Uses car::Anova's type II sum of square approach.

Compared to it's current rcompanion counterpart:

* It will return the same results when you invert the order of the independent variables
* It's faster
* It will return car::Anova's warning for aliased coefficients
* It should be less affected by unbalanced designs, although that remains to be thoroughly tested.

This slight but effective change was [first suggested](https://www.researchgate.net/post/Can-Scheirer-Ray-Hare-test-be-used-in-unbalanced-data-and-sample-size-5) by rcompanion's author.

*Let's try it!*

```
> rcompanion::scheirerRayHare(data = iris, Species ~ Sepal.Width * Petal.Length)
DV:  Species 
Observations:  150 
D:  0.8889284 
MS total:  1887.5 

                         Df Sum Sq      H p.value
Sepal.Width              22  80335 47.879 0.00113
Petal.Length             42 158562 94.503 0.00001
Sepal.Width:Petal.Length 57   8187  4.879 1.00000
Residuals                28   2917  

> rcompanion::scheirerRayHare(data = iris, Species ~  Petal.Length * Sepal.Width)
DV:  Species 
Observations:  150 
D:  0.8889284 
MS total:  1887.5 

                         Df Sum Sq       H p.value
Petal.Length             42 238250 141.997       0
Sepal.Width              22    646   0.385       1
Petal.Length:Sepal.Width 57   8187   4.879       1
Residuals                28   2917    
```

In short, after changing the variable order, the H statistics and p-values were not exactly the same. Now the remixed function.

```
> SRH_test(data = iris, Species ~ Sepal.Width * Petal.Length)
Note: model has aliased coefficients
      sums of squares computed by model comparison

DV:  Species 
Observations:  150 
D:  0.8889284 
MS total:  1887.5 

                         Sum Sq Df      H p.value
Sepal.Width                 646 22  0.385   1e+00
Petal.Length             158562 42 94.503   1e-05
Sepal.Width:Petal.Length   8187 57  4.879   1e+00
Residuals                  2917 28     

> SRH_test(data = iris, Species ~ Petal.Length * Sepal.Width)
Note: model has aliased coefficients
      sums of squares computed by model comparison

DV:  Species 
Observations:  150 

D:  0.8889284 
MS total:  1887.5 

                         Sum Sq Df      H p.value
Petal.Length             158562 42 94.503   1e-05
Sepal.Width                 646 22  0.385   1e+00
Petal.Length:Sepal.Width   8187 57  4.879   1e+00
Residuals                  2917 28    
```
Same H stats and p-values, plus bonus warnings for aliased coefficients.

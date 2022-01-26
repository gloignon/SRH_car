# SRH function from the rcompanion package, but uses type II ANOVA from car::Anova
# This way, it should not return different results when the order of the variables
# is changed. It should also be more robust to unequal sample sizes.

SRH_test <- function (formula = NULL, data = NULL, y = NULL, x1 = NULL, x2 = NULL, 
          tie.correct = TRUE, ss = TRUE, verbose = TRUE) 
{
  if (is.null(formula)) {
    yname = tail(as.character(substitute(y)), n = 1)
    x1name = tail(as.character(substitute(x1)), n = 1)
    x2name = tail(as.character(substitute(x2)), n = 1)
  }
  if (!is.null(formula)) {
    yname = all.vars(formula[[2]])[1]
    x1name = all.vars(formula[[3]])[1]
    x2name = all.vars(formula[[3]])[2]
    y = eval(parse(text = paste0("data", "$", 
                                 yname)))
    x1 = eval(parse(text = paste0("data", "$", 
                                  x1name)))
    x2 = eval(parse(text = paste0("data", "$", 
                                  x2name)))
  }
  Complete = complete.cases(y, x1, x2)
  y = y[Complete]
  x1 = x1[Complete]
  x2 = x2[Complete]
  if (!is.factor(x1)) {
    x1 = factor(x1)
  }
  if (!is.factor(x2)) {
    x2 = factor(x2)
  }
  Ranks = rank(y)
  Ties = table(Ranks)
  Model = lm(Ranks ~ x1 + x2 + x1:x2)
  #Anva_old = anova(Model)
  Anva = car::Anova(Model, type = 2)
  #MS_old = Anva_old[1:4, 1:3]
  MS = Anva[1:4, 1:3]
  n = length(Ranks)
  D = 1
  if (tie.correct) {
    D = (1 - sum(Ties^3 - Ties)/(n^3 - n))
  }
  MStotalSokal = n * (n + 1)/12
  SS = MS[1:3, "Sum Sq"]
  H = SS/MStotalSokal
  Hadj = H/D
  MS[1:3, "H"] = Hadj
  MS[1:3, "p.value"] = (1 - pchisq(MS[1:3, "H"], MS[1:3, "Df"]))
  if (verbose) {
    cat("\n")
    cat("DV: ", yname, "\n")
    cat("Observations: ", n, "\n")
    cat("D: ", D, "\n")
    cat("MS total: ", MStotalSokal, "\n")
    cat("\n")
  }
  #colnames(MS)[4:5] = c("H", "p.value")
  rownames(MS) = c(x1name, x2name, paste0(x1name, ":", 
                                          x2name), "Residuals")
  if (!ss) {
    Z = MS[, c(1, 4, 5)]
  }
  if (ss) {
    Z = MS[, c(1, 2, 4, 5)]
  }
  return(Z)
}


d <- data.frame(i = 1:26, a = letters, b = LETTERS)
d2 <- expand.grid(d, stringsAsFactors = FALSE)
d2$j <- seq(nrow(d2))
ldt <- NULL

test_that("LinkedDataTable works", {
	x <- LinkedDataTable()
	expect_true(inherits(x, 'LinkedDataTable'))
	ldt <<- LinkedDataTable(list(x = d, y = d2))
	expect_output(print(ldt))
	expect_true(inherits(ldt, 'LinkedDataTable'))
})

test_that("LinkedDataTable operators", {
	ldt1 <- ldt[1, ]
	ldt2 <- ldt[2, ]
	expect_true(inherits(ldt1, "LinkedDataTable"))
	ldt12 <- ldt1 + ldt2
	expect_true(inherits(ldt12, "LinkedDataTable"))
})

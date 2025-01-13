#' @export
#' @exportClass LinkedDataTable
LinkedDataTable <- function(x = list(),
														idcol = NULL,
														primary_table = 1,
														dfclass = getOption("LinkedDataTable_data.frame_class", default = "data.frame"),
														...) {

	if (is.data.frame(x) || !is.list(x)) {
		x <- list(x = x)
	}

	if (length(x) >= 1 && (missing(idcol) || is.null(idcol))) {
		idcol <- colnames(x[[1]])[1]
	} else if (is.null(idcol)) {
		idcol <- NA_character_
	}

	structure(lapply(x, .to.data.table, dfclass = dfclass),
						idcol = idcol,
						primary_table = primary_table,
						dfclass = dfclass,
						class = "LinkedDataTable")
}

.to.data.table <- function(x, dfclass = "data.frame") {
	if (!inherits(x, dfclass)) {
		if (dfclass == "data.frame") {
			return(data.frame(res))
		} else {
			return(data.table::data.table(x))
		}
	}
	x
}

#' @export
print.LinkedDataTable <- function(x, ...) {
	cn <- names(x)
	idc <- attr(x, "idcol")

	if (is.null(cn)) {
		cn <- "<null>"
	} else {
	  nr <- sapply(x, nrow)
		cn <- paste0(cn, "<", nr, ">")
	}

	cat("LinkedDataTable", paste0("(ID: ", idc, ")"), "with", length(x), "tables:\n  ")
	cat(cn, sep = ", ")
}

#' @export
`[.LinkedDataTable` <- function(x, i, j, ...) {

	if (is.logical(i)) {
		i <- which(i)
	}

	pt <- attr(x, "primary_table")
	idc <- attr(x, "idcol")

	if (is.integer(as.integer(i))) {
		id <- x[[pt]][i, ][[idc]]
		x <- lapply(x, function(xx) xx[xx[[idc]] == id, ])
	}

	LinkedDataTable(x[j], idcol = idc)
}

#' @export
`+.LinkedDataTable` <- function(x, y) {
	stopifnot(attr(x, "idcol") == attr(y, "idcol"))

	yn <- names(y)
	xn <- names(x)

	x[yn] <- lapply(yn, function(n) {
		res <- data.table::rbindlist(list(x[[n]], y[[n]]), fill = TRUE)
		.to.data.table(res, dfclass = attr(x, 'dfclass'))
	})

	LinkedDataTable(x, attr(x, "idcol"))
}

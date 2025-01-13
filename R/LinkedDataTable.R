#' @export
#' @exportClass LinkedDataTable
LinkedDataTable <- function(x = list(), idcol = NULL, primary_table = 1, ...) {
	if (is.data.frame(x) || !is.list(x)) {
		x <- list(x = x)
	}
	if (length(x) >= 1 && (missing(idcol) || is.null(idcol))) {
		idcol <- colnames(x[[1]])[1]
	} else if (is.null(idcol)) {
		idcol <- NA_character_
	}
	structure(lapply(x, .to.data.table),
						idcol = idcol,
						primary_table = primary_table,
						class = "LinkedDataTable")
}

.to.data.table <- function(x) {
	if (!inherits(x, "data.table")) {
		x <- data.table::data.table(x)
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
		data.table::rbindlist(list(x[[n]], y[[n]]), fill = TRUE)
	})
	LinkedDataTable(x, attr(x, "idcol"))
}

/*
 * measure-holes.c -- measure the amount potentially saved by holes in files
 *
 * The files are given on the command line.  Outputs a list with the total
 * size, the amount in holes, and the filename to the standard output.
 *
 * Note that since it next to impossible to figure out where and whether
 * there are holes (it would require reading the filesystem directly),
 * we just read through the files and check whether there are runs of zeroes
 * that cross block boundaries.
 *
 * We'll assume that the st_blksize is the block size we're interested
 * in.  That's not necessarily true, however.  (st_blksize is not necessarily
 * the unit of allocation for filesystems.)
 *
 * Lars Wirzenius
 */

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <publib.h>

#include <getopt.h>


char *progname = NULL;		/* name of this program; set in main */
#define PROGNAME "measure-holes"	/* default name of this program */


#define OPTIONS	"hb"	/* string of option letters for getopt */

struct option lopts[] = {	/* long options for GNU getopt */
/*	name		has_arg			flag		val	*/
	{ "help",	no_argument,		NULL,		'h',	},
	{ "block",	required_argument,	NULL,		'b',	},
	{ NULL,		no_argument,		NULL,		0	},

};


/*
 * The block size.
 */
static long block_size = 1024;


int process(FILE *f, char *filename);
int open_and_process(char *filename);
void usage(void);


/* Do the usual main() stuff: interpret options, process all input files. */
int main(int argc, char **argv) {
	int opt, lind, i, errors;

	progname = argc > 0 && argv[0] != NULL ? argv[0] : PROGNAME;

	while ((opt = getopt_long(argc, argv, OPTIONS, lopts, &lind)) != EOF) {
		switch (opt) {
		case 'h':
		case '?':
			usage();
			exit(1);
		}
	}

	errors = 0;
	if (optind >= argc) {
		if (process(stdin, "-") == -1)
			errors = 1;
	} else {
		for (i = optind; i < argc; ++i)
			errors = open_and_process(argv[i]) == -1 || errors;
	}

	exit(errors ? 1 : 0);
}


/*
 * Print the version of the program.  This relies on the exact format
 * of the version string that RCS provides.  The assumption is that
 * the string "#Version#" (except that this example uses `#' instead
 * of `$' to prevent it from being expanded) is expanded by RCS into
 * "#Version: 1.1#"; the code strips away all but "1.1" and prints
 * that.
 * 
 * The same is done for the date string.
 */
void version(void) {
	const char *p, *vers, *date;

	p = strstr("$Version$", ": ");
	vers = (p == NULL) ? "unknown" : p+2;

	p = strstr("1995/02/04 12:24:46", ": ");
	date = (p == NULL) ? "unknown" : p+2;

	fprintf(stderr, "%s: version %s, dated %s\n", progname, vers, date);
}


/* Print a short usage description to stderr.  DO NOT exit. */
void usage(void) {
	static char *lines[] = {
		"No usage available",
	};
	int i;

	for (i = 0; i < sizeof(lines) / sizeof(lines[0]); ++i)
		fprintf(stderr, "%s\n", lines[i]);
}



/* Open a named file and call process for it.  Recognizes "-" as stdin.
   Return 0 for success and -1 for failure (same as process).  Print error
   message to stderr if opening or closing of file fails.  */
int open_and_process(char *filename) {
	FILE *f;
	int ret;

	if (strcmp(filename, "-") == 0)
		return process(stdin, "-");

	errno = 0;
	f = fopen(filename, "r");
	if (f == NULL) {
		errormsg(0, errno, "%s: fopen failed for `%s'\n",
			progname, filename); 
		return -1;
	}

	ret = process(f, filename);

	errno = 0;
	if (fclose(f) != 0) {
		errormsg(0, errno, "%s: error while closing file `%s'\n",
			progname, filename);
		return -1;
	}

	return ret;
}


/* Process one file that has already been opened for input.  This is the
   function that does all the real work, and which needs to be written for
   each program separately. */
int process(FILE *f, char *filename) {
	static char *buf = NULL;
	static long prev_block_size = -1;
	long zeroes;
	char *p;

	if (buf == NULL || prev_block_size != block_size) {
		free(buf);
		buf = xmalloc(block_size + 1);
		buf[block_size] = 1;
		prev_block_size = block_size;
	}

	zeroes = 0;
	while (fread(buf, block_size, 1, f) == 1) {
		for (p = buf; *p == '\0'; )
			++p;
		if (p == buf+block_size)
			zeroes += block_size;
	}

	if (zeroes > 0)
		printf("%ld %s\n", zeroes, filename);

	if (ferror(f)) {
		errormsg(0, -1, "read failed for `%s'", filename);
		return -1;
	}

	return 0;
}

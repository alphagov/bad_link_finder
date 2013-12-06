# Bad link finder

Crawls a mirrored site and checks that all links either return a successful response or redirect to somewhere that does.

## Usage

Set environment variables:

- `MIRROR_DIR`, to the location of your mirrored site.  Local files will be read in alphabetical order.
- `REPORT_OUTPUT_FILE`, to the location you'd like the CSV saved to.
- `SITE_HOST`, to the full host of the live site you'd like to test against, including protocol.  For example, `https://www.example.com`
- `START_FROM`, optional, specify a file on disk from which to start, e.g. `example-folder/example.html`.
  Will check this file and all following files.  Useful for restarting aborted runs.

Then execute `bad_link_finder`.

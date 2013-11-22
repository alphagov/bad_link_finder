# Bad link finder

Crawls a mirrored site and checks that all links either return a successful response or redirect to somewhere that does.

## Usage

Set environment variables:

- `MIRROR_DIR`, to the location of your mirrored site.
- `REPORT_OUTPUT_FILE`, to the location you'd like the CSV saved to.
- `SITE_HOST`, to the full host of the live site you'd like to test against, including protocol.  For example, `https://www.example.com`

Then execute `bad_link_finder`.

#!/usr/bin/env python

"""
trim.py

A commmand-line utility to trim repeated blank lines in a text file.

There are three modes of operationIt can operate in three modes:

1. If "-" argument is provided, read from stdin and write the trimmed text to stdout.
2. If only one filename is provided, edit the file in place (using a temporary file).
3. If both an input file and an output file are provided, write to the output file.


Example usage:
1. Trim text as a stream from stdin:

    $ cat file_with_blank_lines.txt | python trim.py -

2. Trim a file in place:

    $ python trim.py file_with_blank_lines.txt


3. Trim a file and write to a new file:

    $ python trim.py file_with_blank_lines.txt trimmed_file.txt

"""

from __future__ import annotations

import shutil
import sys
import tempfile
from pathlib import Path


def print_usage():
	print("Usage:")
	print("trim.py <text_file> [output_file]")


def is_probably_text(path: Path, sample_size: int = 4096) -> bool:
	try:
		with path.open("rb") as f:
			sample = f.read(sample_size)
	except OSError:
		return False
	if b"\x00" in sample:
		return False
	# try to decode a sample as utf-8
	try:
		sample.decode("utf-8")
		return True
	except Exception:
		return False


def content_split(line: str) -> tuple[str, str]:
	"""Split a line into content and line ending."""
	if line.endswith("\r\n"):
		return line[:-2], "\r\n"
	elif line.endswith("\n"):
		return line[:-1], "\n"
	elif line.endswith("\r"):
		return line[:-1], "\r"
	else:
		return line, ""


def trim_stream(input_stream, output_stream, max_white_lines: int = 1) -> None:
	white_line_counter = 0
	for line in input_stream:
		# Determine the line ending and the content without the ending
		content, ending = content_split(line)

		if len(content.strip()) == 0:
			white_line_counter += 1
		else:
			white_line_counter = 0

		if white_line_counter <= max_white_lines:
			output_stream.write(line)


def main(args: list[str] | None = None) -> int:
	arg_count = len(args) if args is not None else 0
	if arg_count < 1 or arg_count > 2:
		print_usage()
		return 0

	if args[0] == "-":
		# Mode 1: Only "-" is provided, read from stdin and write to stdout.
		if arg_count > 1:
			print_usage()
			return 1
		trim_stream(sys.stdin, sys.stdout)
		return 0

	# Convert the first two arguments to Path objects.
	path1 = Path(args[0])
	path2 = Path(args[1]) if len(args) > 1 else None

	# Validate that the input file exists and is a readable text file.
	if not path1.exists():
		print(f"Error: File '{path1}' does not exist.", file=sys.stderr)
		return 2
	if not is_probably_text(path1):
		print(f"Error: File '{path1}' is not a readable text file.", file=sys.stderr)
		return 3

	if path2 is None:
		# Mode 2: Only one file is provided, edit in place.
		# Copy the original file to a temporary file that will be used as input.
		with tempfile.NamedTemporaryFile(delete=False) as tmp:
			tmp_path = Path(tmp.name)  
			shutil.copyfile(path1, tmp_path)
		# Select the temp file as the source and the original file as the destination.
		src = tmp_path
		dst = path1
	else:
		# Mode 3: Both input and output files are provided, write to the output file.
		src = path1
		dst = path2

	# Open the source and destination files and process as a stream.
	with src.open("r", encoding="utf-8", errors="strict", newline="") as instream, \
		dst.open("w", encoding="utf-8", newline="") as outstream:
		trim_stream(instream, outstream)
		return 0


if __name__ == "__main__":
	#raise SystemExit(main())
	main(sys.argv[1:])

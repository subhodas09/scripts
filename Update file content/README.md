### Bash Script: `file_content_replacer.sh`

```bash
#!/bin/bash

# Default values
FILE_PATTERN="*"
SEARCH_PATTERN=""
REPLACE_PATTERN=""

# Display help
function display_help {
    echo "Usage: $0 [OPTIONS]"
    echo "Replace content in files."
    echo
    echo "  -f, --file-pattern       File pattern to search for (default: *)"
    echo "  -s, --search-pattern     Search pattern to find"
    echo "  -r, --replace-pattern    Replace value for the search pattern"
    echo "  -h, --help               Display this help and exit"
}

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -f|--file-pattern) FILE_PATTERN="$2"; shift ;;
        -s|--search-pattern) SEARCH_PATTERN="$2"; shift ;;
        -r|--replace-pattern) REPLACE_PATTERN="$2"; shift ;;
        -h|--help) display_help; exit 0 ;;
        *) echo "Unknown parameter passed: $1"; display_help; exit 1 ;;
    esac
    shift
done

# Check for mandatory arguments
if [[ -z $SEARCH_PATTERN || -z $REPLACE_PATTERN ]]; then
    echo "Error: Search and Replace patterns are mandatory."
    display_help
    exit 1
fi

# Replace content in files
for file in ${FILE_PATTERN}; do
    if [[ -f $file ]]; then
        sed -i'' -E "s/${SEARCH_PATTERN}/${REPLACE_PATTERN}/g" "$file"
    fi
done

echo "Content replaced in files matching pattern '${FILE_PATTERN}'!"
```

### README.md

```markdown
# File Content Replacer

A utility script to find and replace content in files.

## Requirements

- `bash`
- `sed`

## Usage

```
./file_content_replacer.sh [OPTIONS]
```

### Options:

- `-f, --file-pattern`  
  File pattern to search for (e.g., `*.txt`). Default is `*`, which means all files.

- `-s, --search-pattern`  
  The pattern to search for in the file. This is mandatory.

- `-r, --replace-pattern`  
  The pattern to replace the search pattern with. This is mandatory.

- `-h, --help`  
  Display help information and exit.

## Example:

To replace the string "hello" with "world" in all `.txt` files:

```
./file_content_replacer.sh -f "*.txt" -s "hello" -r "world"
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

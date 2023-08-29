# File Content Replacer

A versatile utility script to find and replace content in files. Whether you're managing simple text documents or complex configuration files such as Kubernetes Deployment manifests, this tool can assist in making bulk content adjustments.

## Table of Contents
1. [Requirements](#requirements)
2. [Installation](#installation)
3. [Usage](#usage)
4. [Examples](#examples)
    * [Replacing Content in Text Files](#1-replacing-content-in-text-files)
    * [Using Regular Expressions](#2-replacing-content-using-regular-expressions)
    * [Adjusting Kubernetes Deployments](#3-replacing-replicas-in-kubernetes-deployment-files)
5. [Contributing](#contributing)
6. [License](#license)

## Requirements

- `bash`
- `sed`

## Installation

1. Clone the GitHub repository:
    ```
    git clone [Your-Repository-URL]
    cd [Repository-Directory]
    ```

2. Make the script executable:
    ```
    chmod +x file_content_replacer.sh
    ```

## Usage

Execute the script with the required options:

./file_content_replacer.sh [OPTIONS]


### Options:

- `-f, --file-pattern`  
  File pattern to search for (e.g., `*.txt`). Default is `*`, which means all files.

- `-s, --search-pattern`  
  The pattern to search for within files. This is mandatory.

- `-r, --replace-pattern`  
  The pattern to replace the search pattern with. This is mandatory.

- `-h, --help`  
  Display help information and exit.

## Examples:

### 1. Replacing Content in Text Files:

If you have multiple `.txt` files in a directory and you wish to replace the string "hello" with "world" across these files:

./file_content_replacer.sh -f "*.txt" -s "hello" -r "world"


### 2. Replacing Content using Regular Expressions:

For a directory of `.log` files where you aim to replace dates in the format YYYY-MM-DD with just YYYY:

./file_content_replacer.sh -f "*.log" -s "[0-9]{4}-[0-9]{2}-[0-9]{2}" -r "[0-9]{4}"


### 3. Replacing `replicas` in Kubernetes Deployment files:

For Kubernetes Deployment YAML files where you'd like to adjust the replica count to a specific value, such as `3`:

./file_content_replacer.sh -f "Deployment*.yml" -s "replicas: [0-9]+" -r "replicas: 3"


> **Note:** Always back up your files or use a version control system before performing bulk replacements, especially when working with regular expressions.

## Contributing

Pull requests are welcome. For significant changes, please open an issue first to discuss the desired alterations.

## License

[MIT](https://choosealicense.com/licenses/mit/)

# Demo: Research Analysis Code Repository

A template repository for managing analysis code for projects where data lives on a secure shared drive and cannot be version controlled.

## Purpose

This repository contains all code for data import, cleaning, analysis, and report generation for `project_name`. The actual data remains on a secure shared drive and is **never** committed to version control. Be sure to check out the global [`.gitignore`](.gitignore) file here before reading on.

## The Problem This Solves

### The Challenge

You have a distributed research team working with sensitive data that:
- Lives on a secure shared drive that cannot be moved
- Is organized in nested folders, for example, by state and year (e.g., `Lab/StateA/2023/`, `Lab/StateB/2024/`, etc.)
- Requires collaborative code development across Windows, Mac, and Linux machines
- Needs version control for reproducibility and collaboration

### The Conflict

Traditional approaches create impossible trade-offs:

**Option 1: One code repository without proper path management**
- ❌ Forces hardcoded paths: `setwd("Z:/Lab/StateA/2024")`
- ❌ Breaks on different operating systems (Z:/ vs /Volumes/)
- ❌ Breaks when different team members have different drive mappings
- ❌ Violates[ project-oriented workflow](https://tidyverse.org/blog/2017/12/workflow-vs-script/) principles
- ❌ Code is not reproducible

**Option 2: Code repositories inside each data folder**
- ❌ Creates dozens of scattered git repositories
- ❌ Makes code reuse nearly impossible
- ❌ Version control nightmare (which repo has the latest cleaning function?)
- ❌ Multiple people doing git operations in the same shared folder causes conflicts
- ❌ Accidental data commits to version control

**Option 3: Move data into code repository**
- ❌ Violates data security requirements
- ❌ Data cannot leave the secure shared drive
- ❌ Makes git repository enormous and slow
- ❌ Not feasible

### This Solution

This repository implements a **single centralized code repository with configurable paths**:

- ✅ **One repository** for all analysis code (easy to find, maintain, collaborate)  
- ✅ **Reproducible** across team members with different operating systems  
- ✅ **Secure** - data never leaves the shared drive or enters version control  
- ✅ **Flexible** - works with nested folder structures  
- ✅ **Collaborative** - proper git workflow without conflicts  
- ✅ **Project-oriented** - no `setwd()`, paths are configurable not hardcoded

**How it works:**
- Code lives in a git repository on each person's **local machine**
- Each team member has a personal `config.yml` file (not version controlled) with their specific paths
- Code uses helper functions to construct paths dynamically
- Data stays on the shared drive (read-only for most operations)
- Outputs go to each person's local directories
- Everyone commits code changes, never data

## Repository Structure

```
.
├── config/
│   ├── config.template.yml    # Template for path configuration (COPY THIS)
│   └── README.md              # Configuration instructions
├── src/
│   ├── data_import/           # Scripts for reading raw data
│   ├── cleaning/              # Data cleaning and validation
│   ├── analysis/              # Statistical analysis scripts
│   ├── visualization/         # Plotting and graphics
│   └── utils/                 # Helper functions (including path management)
│       └── paths.R            # CRITICAL: Path configuration utilities
├── reports/
│   ├── templates/             # Quarto/R Markdown templates
│   └── archived/              # Completed reports (PDFs, HTML)
├── docs/
│   ├── DATA_STRUCTURE.md      # Documentation of data organization
│   └── WORKFLOW.md            # Standard analysis workflows
├── .gitignore                 # Prevents committing sensitive files
├── README.md                  # This file
└── project.Rproj              # RStudio project file (optional)
```

## Getting Started

Install R, Positron, and a few packages.

```r
install.packages(c("here", "yaml"))
```

Clone this repository to your **LOCAL** machine. Change the name to whatever you want for your organization.

```bash
git clone https://github.com/stephenturner/demo-project-path-config
cd demo-project-path-config
```

Configure your data paths. Copy the template to `config/config.yml`, which is never committed to version control.

```bash
cp config/config.template.yml config/config.yml
```

Edit this with your actual paths.

*Windows example:*
```yaml
data_root: "Z:/lab/data"
output_root: "Z:/lab/reports"
```

Mac example:
```yaml
data_root: "/Volumes/research/data"
output_root: "/Volumes/research/reports"
```

Linux example:
```yaml
data_root: "/mnt/research/data"
output_root: "/mnt/research/data"
```

Verify your setup

```r
source(here::here("src/utils/paths.R"))
paths <- get_paths()
print(paths)
```

## 📁 Data Organization

The data lives on a shared drive with the following structure (example):

```
Lab/
├── StateA/
│   ├── 2023/
│   │   ├── raw_data.csv
│   │   └── metadata.json
│   └── 2024/
│       ├── raw_data.csv
│       └── metadata.json
├── StateB/
│   ├── 2023/
│   └── 2024/
└── documentation/
    └── data_dictionary.xlsx
```

See [docs/DATA_STRUCTURE.md](docs/DATA_STRUCTURE.md) for complete documentation.

## Writing Reproducible Code

### DO ✅

Use path helper functions:

```r
library(here)
source(here("src", "utils", "paths.R"))

# Good: Reproducible across all team members
data_file <- get_data_path("StateA", "2024", "raw_data.csv")
df <- read.csv(data_file)
```

Use relative paths within the repository:

```r
# Good: Load analysis functions
source(here("src", "analysis", "regression_models.R"))
```

Parameterize your analysis:

```r
# Good: State and year are parameters
analyze_state <- function(state, year) {
  data <- get_data_path(state, year, "raw_data.csv")
  # ... analysis code
}
```

### DON'T ❌

Never hardcode absolute paths:

```r
# Bad: Won't work for anyone else
df <- read.csv("Z:/Lab/StateA/2024/raw_data.csv")
df <- read.csv("/Volumes/Lab/StateA/2024/raw_data.csv")
```

Never use `setwd()`:

```r
# Bad: Breaks project-oriented workflow
setwd("C:/Users/YourName/Documents/project")
```

Never commit data or outputs. See what's in the global [`.gitignore`](.gitignore).

## Key Utilities

### Path Management ([`src/utils/paths.R`](src/utils/paths.R))

```r
# Load the path utilities
source(here::here("src", "utils", "paths.R"))

# Get all configured paths
paths <- get_paths()

# Construct path to data file
data_file <- get_data_path("StateA", "2024", "raw_data.csv")

# Construct path to output file
output_file <- get_output_path("analysis_results.rds")
```
### Quarto/R Markdown Setup

In your setup chunk:

```r
library(here)
library(tidyverse)
source(here("src", "utils", "paths.R"))

# Now you can access data
knitr::opts_knit$set(root.dir = here())
```

Rendering reports:

```r
# Render a report
quarto::quarto_render(
  input = here("reports", "templates", "state_report.qmd"),
  output_file = here("reports", "archived", "StateA_2024_report.html")
)
```

## 🔒 Security & Data Protection

### Critical Rules

1. **NEVER commit data files** - Data stays on the secure shared drive
2. **NEVER commit `config/config.yml`** - Contains your local paths
3. **NEVER commit outputs with PHI/PII** - Check before committing
4. **NEVER push API keys or credentials** - Use environment variables

### What Gets Committed

- ✅ Code (`.R`, `.qmd`, `.Rmd`)  
- ✅ Documentation (`.md`)  
- ✅ Configuration templates (`.template.yml`)  
- ✅ Non-sensitive report templates  

### What NEVER Gets Committed

Make sure stuff here makes it into the project-level [`.gitignore`](.gitignore).

- ❌ Data files (`.csv`, `.xlsx`, `.rds`)  
- ❌ Your personal config (`config.yml`)  
- ❌ Outputs with results (`outputs/`)  
- ❌ Cache files (`.RData`, `.Rhistory`)  

## 🤝 Collaboration Workflow

### Daily Workflow

Pull latest code: 

```bash
git pull origin main
```

Create a feature branch (for new analyses)

```bash
git checkout -b analysis/state-a-trends
```

Write your code using path helpers. Commit your changes.

```bash
git add src/analysis/my_new_analysis.R
git commit -m "Add trend analysis for State A"
```

Push and create pull request

```bash
git push origin analysis/state-a-trends
```

### Avoiding Conflicts

- **Code conflicts**: Resolved through Git's normal merge process
- **Data conflicts**: Not an issue - data isn't version controlled
- **Simultaneous data access**: Multiple people can read from shared drive simultaneously
- **Output conflicts**: Each person writes to their own local output directory

## Troubleshooting

### "config.yml not found"

**Problem:** You haven't created your personal config file.

**Solution:**
```bash
cp config/config.template.yml config/config.yml
# Then edit config.yml with your paths
```

### "Error in normalizePath: path does not exist"

**Problem:** Your `data_root` path in `config.yml` is incorrect or you're not connected to the shared drive.

**Solution:**
1. Verify you're connected to the shared drive
2. Check the exact path to the Lab folder on your system
3. Update `config.yml` with the correct path

### "Package 'here' not found"

**Problem:** Missing required packages.

**Solution:**
```r
install.packages(c("here", "yaml"))
```

### Cross-platform path issues

**Problem:** Paths work on Windows but not Mac (or vice versa).

**Solution:** Always use the path helper functions - they handle platform differences automatically.


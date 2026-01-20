# Create directory structure
mkdir -p config
mkdir -p src/data_import
mkdir -p src/cleaning
mkdir -p src/analysis
mkdir -p src/visualization
mkdir -p src/utils
mkdir -p reports/templates
mkdir -p reports/archived
mkdir -p docs
mkdir -p tests

# Create files
touch .gitignore
touch README.md
touch config/config.template.yml
touch config/README.md
touch src/utils/paths.R
touch src/data_import/load_data.R
touch docs/DATA_STRUCTURE.md
touch docs/WORKFLOW.md

# Create .gitignore content
cat > .gitignore << 'EOF'
# Personal configuration (DO NOT COMMIT)
config/config.yml

# R specific
.Rproj.user
.Rhistory
.RData
.Ruserdata
*.Rproj

# Data files (NEVER COMMIT DATA)
*.csv
*.xlsx
*.xls
*.rds
*.rda
*.RData
*.sav
*.dta
*.sas7bdat

# Output directories
outputs/
results/
cache/
temp/

# Reports with potentially sensitive content
reports/archived/*.html
reports/archived/*.pdf
reports/archived/*.docx

# System files
.DS_Store
Thumbs.db
*.swp
*.swo
*~

# Temporary files
*.tmp
*.log

# Credentials and secrets
.env
.Renviron
credentials.yml
secrets.yml
EOF

# Create initial commit
git add .
git commit -m "Initial repository structure"

echo "Repository structure created successfully!"
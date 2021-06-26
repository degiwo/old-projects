# mlops
elaborate MLOps

## Content
- [Code Versioning](#code-versioning)
- [Data Versioning](#data-versioning)
- Data Pipeline
- [Model Pipeline](#model-pipeline)
- Model Versioning
- Model Comparison
- [Continous Integration](#continous-integration)
- Testing
- Performance Monitoring
- API
- Container/Environment

## Code Versioning

### Clone Repository
```sh
git clone https://github.com/degiwo/mlops.git
```

### Create own branch
```sh
git branch own-feature-branch
```

### Rebase feature branch from main
```sh
git checkout main
git pull
git checkout feature-branch
git rebase main
```

### Merge feature branch with main
```sh
git checkout main
git pull
git merge feature-branch
```

### Squash commit messages
```sh
git rebase -i HEAD~20 # in the interactive editor: ESC > :wq!
git commit --amend
git push -f
```

### Fetch from remote
```sh
git fetch --prune
```

## Data Versioning

### Initialize DVC
```sh
dvc init
```

### Set up Google Drive as a remote
```sh
dvc remote add -d myremote gdrive://1pmhbDZEa6QpHZQj6CfLm9tgT16Sv40t_
```

### Add data to remote and dvc file to git
```sh
dvc add data.csv
dvc push
git add data.csv.dvc
```

### Pull data from remote
```sh
dvc pull data.csv
```

## Model Pipeline

### Set up DVC pipeline
```sh
cat > dvc.yaml
```

Copy the following into dvc.yaml:
```yaml
stages:
  get_data:
    cmd: python get_data.py
    deps:
    - get_data.py
    outs:
    - data_raw.csv  
  process:
    cmd: python process_data.py
    deps:
    - process_data.py
    - data_raw.csv
    outs:
    - data_processed.csv
  train:
    cmd: python train.py
    deps:
    - train.py
    - data_processed.csv
    outs:
    - by_region.png
    metrics:
    - metrics.json:
        cache: false
```

### Reproduce pipeline
```sh
dvc repro
```

## Continous Integration

### Set up Github Actions
```sh
mkdir .github/workflows/
cat > ./.github/workflows/cml.yaml
```

Copy the following into cml.yaml:
```yaml
name: your-workflow-name
on: [push]
jobs:
  run:
    runs-on: [ubuntu-latest]
    # optionally use a convenient Ubuntu LTS + CUDA + DVC + CML image
    # container: docker://dvcorg/cml:0-dvc2-base1-gpu
    steps:
      - uses: actions/checkout@v2
      # may need to setup NodeJS & Python3 on e.g. self-hosted
      # - uses: actions/setup-node@v2
      #   with:
      #     node-version: '12'
      # - uses: actions/setup-python@v2
      #   with:
      #     python-version: '3.x'
      - uses: iterative/setup-cml@v1
      - name: Train model
        run: |
          # Your ML workflow goes here
          pip install -r requirements.txt
          python train.py
      - name: Write CML report
        env:
          REPO_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          # Post reports as comments in GitHub PRs
          cat results.txt >> report.md
          cml-send-comment report.md
```
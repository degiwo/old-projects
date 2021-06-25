# mlops
elaborate MLOps

## Content
- [Code Versioning](#code-versioning)
- [Data Versioning](#data-versioning)
- Data Pipeline
- Model Versioning
- Model Comparison
- Continous Integration
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
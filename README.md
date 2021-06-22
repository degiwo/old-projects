# mlops
elaborate MLOps

## Content
- [Code Versioning](##code-versioning)
- Data Versioning
- Data Pipeline
- Model Versioning
- Model Comparison
- Testing
- Performance Monitoring
- API

## Code Versioning

### Clone Repository
```sh
git clone https://github.com/degiwo/mlops.git
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
git rebase -i HEAD~20
git commit --amend
git push -f
```
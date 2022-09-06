# Deploy Machine Learning Model

## Project Structure
```
deployml
|   .gitignore
|   README.md
|
└───packages
|   |
|   └───regression_model
|   |   |   requirements.txt
|   |   |   tox.ini
|   |   |
|   |   └───src
|   |   |   |   __init__.py
|   |   |   |   pipeline.py
|   |   |   |   train_pipeline.py
|   |   |   |
|   |   |   └───datasets
|   |   |   |   |   __init__.py
|   |   |   |   |   original_data.csv
|   |   |   |
|   |   |   └───processing
|   |   |   |   |   __init__.py
|   |   |   |   |   preprocessors.py
|   |   |   |
|   |   |   └───processing
|   |   |   |   |   __init__.py
|   |   |   |   |   regression_model.pkl
```
from sklearn.linear_model import LogisticRegression

class Model(LogisticRegression):
    def __init__(self):
        super().__init__(solver="lbfgs")

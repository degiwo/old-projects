import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
import joblib
import mlflow


# Read prepared data
stock_data = pd.read_csv("../data/stock_data.csv")


# Model development process
X_train, X_test, y_train, y_test = train_test_split(
    stock_data[["High_amzn", "High_fb", "High_aapl"]], stock_data["Adj Close"], random_state=42
)
linear_model = LinearRegression()


def train(model=linear_model, x=X_train, y=y_train):
    model.fit(x, y)
    print(f"Training score: {model.score(x, y)}")


def evaluate(model=linear_model, x=X_test, y=y_test):
    mlflow.log_metric("test_acc", model.score(x, y))
    print(f"Test score: {model.score(x, y)}")


mlflow.set_experiment("lin_reg")
with mlflow.start_run():
    train(linear_model, X_train, y_train)
    evaluate(linear_model, X_test, y_test)
mlflow.end_run()

# Save trained model as pickle file
# joblib.dump(linear_model, "models/linear_model.pkl")

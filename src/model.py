import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
import joblib

# Read prepared data
stock_data = pd.read_csv("data/stock_data.csv")

# Model development process
X_train, X_test, y_train, y_test = train_test_split(
    stock_data[["High_amzn", "High_fb", "High_aapl"]], stock_data["Adj Close"], random_state=42
)
linear_model = LinearRegression()
linear_model.fit(X_train, y_train)

print(f"Training score: {linear_model.score(X_train, y_train)}")
print(f"Test score: {linear_model.score(X_test, y_test)}")

# Save trained model as pickle file
joblib.dump(linear_model, "models/linear_model.pkl")

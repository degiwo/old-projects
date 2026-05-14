# Store all configurations like paths, ...

# paths
PATH_DATA_FOLDER = "./spaceship_titanic/data/"
PATH_MODEL_FOLDER = "./spaceship_titanic/model/"
PATH_LOGS_FOLDER = "./spaceship_titanic/logs/"

# file names
FILE_NAME_ORIGINAL_DATA = "original_data.csv"
FILE_NAME_TRAIN_DATA = "train.csv"
FILE_NAME_TEST_DATA = "test.csv"
FILE_NAME_EVALUATION_DATA = "evaluation_data.csv"
FILE_NAME_MODEL_PIPELINE = "pipeline.pkl"

# column names
COLUMN_TARGET = "Transported"
COLUMN_TOTAL_BILL = [
    # columns to sum for new column TotalBill
    "RoomService",
    "FoodCourt",
    "ShoppingMall",
    "Spa",
    "VRDeck",
]
COLUMN_IMPUTE = [
    "Age",
    "RoomService",
    "FoodCourt",
    "ShoppingMall",
    "Spa",
    "VRDeck",
]
COLUMN_ONEHOT = ["HomePlanet", "CryoSleep", "Destination", "Age", "VIP"]

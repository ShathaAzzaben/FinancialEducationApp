import os
import pandas as pd
import kagglehub
from sklearn.model_selection import train_test_split
from sklearn.utils import resample

# Download dataset
dataset_path = kagglehub.dataset_download("nikhilkohli/us-stock-market-data-60-extracted-features")

all_data = []

# Load, feature engineer, and label each file
for file in os.listdir(dataset_path):
    if file.endswith(".csv"):
        df = pd.read_csv(os.path.join(dataset_path, file))

        if {'Date', 'Open', 'High', 'Low', 'Close(t)', 'Volume'}.issubset(df.columns):
            df = df[['Date', 'Open', 'High', 'Low', 'Close(t)', 'Volume']].copy()

            # Sort by date
            df = df.sort_values("Date").reset_index(drop=True)

            # Feature Engineering
            df["Range"] = df["High"] - df["Low"]
            df["Price_Change"] = df["Close(t)"] - df["Open"]
            df["Price_Change_Pct"] = (df["Close(t)"] - df["Open"]) / df["Open"]
            df["Volatility"] = (df["High"] - df["Low"]) / df["Open"]
            df["Volume_prev"] = df["Volume"].shift(1)
            df["Volume_Change"] = df["Volume"] / (df["Volume_prev"] + 1e-5)
            df["Candle_Ratio"] = abs(df["Close(t)"] - df["Open"]) / ((df["High"] - df["Low"]) + 1e-5)

            # Rolling mean (requires history)
            df["MA5"] = df["Close(t)"].rolling(window=5).mean()

            # Build Label using average of Close(t+1 to t+3)
            df["Close_t1"] = df["Close(t)"].shift(-1)
            df["Close_t2"] = df["Close(t)"].shift(-2)
            df["Close_t3"] = df["Close(t)"].shift(-3)
            df["Future_Avg"] = (df["Close_t1"] + df["Close_t2"] + df["Close_t3"]) / 3

            df["Label"] = df.apply(
                lambda row: "Buy" if row["Future_Avg"] > row["Close(t)"] * 1.015 else "Don't Buy",
                axis=1
            )

            # Clean up
            df.dropna(subset=["Future_Avg"], inplace=True)
            df.drop(columns=["Volume_prev", "Close_t1", "Close_t2", "Close_t3", "Future_Avg"], inplace=True)

            all_data.append(df)

# Combine all stock data
merged_df = pd.concat(all_data, ignore_index=True)

# Split into train/test BEFORE balancing
train_df, test_df = train_test_split(merged_df, test_size=0.2, shuffle=True, random_state=42)

# Balance the training set only
buy_train = train_df[train_df["Label"] == "Buy"]
dont_buy_train = train_df[train_df["Label"] == "Don't Buy"]

max_class_size = max(len(buy_train), len(dont_buy_train))

# Oversample both classes within the training set
buy_train_bal = resample(buy_train, replace=True, n_samples=max_class_size, random_state=42)
dont_buy_train_bal = resample(dont_buy_train, replace=True, n_samples=max_class_size, random_state=42)

# Combine and shuffle the balanced training set
train_df_balanced = pd.concat([buy_train_bal, dont_buy_train_bal]).sample(frac=1, random_state=42).reset_index(drop=True)

# Save the results
train_df_balanced.to_csv("train_data_balanced.csv", index=False)

# Balance test data using undersampling (to avoid data leakage)
buy_test = test_df[test_df["Label"] == "Buy"]
dont_buy_test = test_df[test_df["Label"] == "Don't Buy"]
min_test_size = min(len(buy_test), len(dont_buy_test))

buy_test_bal = resample(buy_test, replace=False, n_samples=min_test_size, random_state=42)
dont_buy_test_bal = resample(dont_buy_test, replace=False, n_samples=min_test_size, random_state=42)

test_df_balanced = pd.concat([buy_test_bal, dont_buy_test_bal]).sample(frac=1, random_state=42).reset_index(drop=True)
test_df_balanced.to_csv("test_data_balanced.csv", index=False)


# Print label distribution
print("Balanced Train Label Distribution:")
print(train_df_balanced["Label"].value_counts())
print("\nTest Label Distribution:")
print(test_df_balanced["Label"].value_counts())

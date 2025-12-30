import pandas as pd 
import numpy as np 
from datetime import datetime
import time 
from zoneinfo import ZoneInfo

start_time = time.time()

# invoice table shared by finance 
dataframe = spark.read.table("furlenco_analytics.user_uploads.invoice_equi")
df = dataframe.toPandas()
vertical = df['vertical'][0].lower()
invoices_df = df[["fur_id","Recognised date","Total"]]

# Closing Balance Table shared by finance
balance_df = spark.read.table("furlenco_analytics.user_uploads.unlmtd_tr_bal_30th_sep_25_given_to_auditors").toPandas()

# Date to be modified as required
current_date = datetime(2025, 9, 30).date()

AGE_BINS = [-float('inf'), 30, 60, 90, 120, 180, float('inf')]
AGE_LABELS = [
    'ZeroTo30',
    'ThirtyOneToSixty',
    'SixtyOneToNinety',
    'NinetyOneToOneTwenty',
    'OneTwentyOneToOneEighty',
    'MoreThanOneEighty'
]

# --- 2. Data Cleaning and Preparation (Vectorized) ---
balance_df.columns = ['furid', 'balance']
balance_df = balance_df[balance_df['furid'].notna() & (balance_df['furid'].str.lower() != 'total')]
balance_df['balance'] = pd.to_numeric(balance_df['balance'].astype(str).str.replace(',', ''), errors='coerce')
users_with_outstanding = balance_df[balance_df['balance'] > 0].copy()

invoices_df.columns = ['furid', 'invoice_date', 'invoice_value']
invoices_df = invoices_df[invoices_df['furid'].notna()]
invoices_df['invoice_value'] = pd.to_numeric(invoices_df['invoice_value'].astype(str).str.replace(',', ''), errors='coerce')
invoices_df = invoices_df[invoices_df['invoice_value'] >= 0]

# Convert dates, gracefully handling any errors
invoices_df['invoice_date'] = pd.to_datetime(invoices_df['invoice_date'], dayfirst=True)
invoices_df.dropna(subset=['invoice_date'], inplace=True)

invoices_df['age'] = (pd.to_datetime(current_date) - pd.to_datetime(invoices_df['invoice_date'])).dt.days
invoices_df['age_bucket'] = pd.cut(invoices_df['age'], bins=AGE_BINS, labels=AGE_LABELS, right=True)

# --- 3. Core Allocation Logic (Vectorized) ---
# This block replaces your entire slow 'for' loop

# Merge balances with their corresponding invoices
merged_df = pd.merge(users_with_outstanding, invoices_df, on='furid', how='left')

# Sort invoices from oldest to newest for each user
merged_df.sort_values(by=['furid', 'age'], inplace=True)

# Calculate the cumulative sum of invoices for each user
# fillna(0) is critical for users who have a balance but no invoices
# merged_df['invoice_value'].fillna(0, inplace=True)
merged_df.fillna({'invoice_value':0},inplace=True)
merged_df['cumulative_invoice'] = merged_df.groupby('furid')['invoice_value'].cumsum()

# Calculate the portion of the balance used by *previous* invoices
prev_cumulative_invoice = merged_df['cumulative_invoice'] - merged_df['invoice_value']

# ⭐ KEY STEP: Allocate the remaining balance to the current invoice
# The amount allocated is the smaller of the remaining balance or the invoice value.
# .clip() efficiently handles this for the entire dataset at once.
allocated_amount = (merged_df['balance'] - prev_cumulative_invoice).clip(lower=0, upper=merged_df['invoice_value'])
merged_df['amount'] = allocated_amount

# Identify any residual balance (when total invoices are less than the balance)
user_summary = merged_df.groupby('furid').agg(
    total_allocated=('amount', 'sum'),
    balance=('balance', 'first')
)
user_summary['residual_balance'] = user_summary['balance'] - user_summary['total_allocated']

# Prepare the residual balances to be added to the 'MoreThanOneEighty' bucket
residual_df = user_summary[user_summary['residual_balance'] > 0.01][['residual_balance']].reset_index()
residual_df.rename(columns={'residual_balance': 'amount'}, inplace=True)
residual_df['age_bucket'] = 'MoreThanOneEighty'

# --- 4. Final Aggregation and Formatting ---
# Combine the primary allocations with the residual amounts
final_report_data = pd.concat([merged_df[['furid', 'age_bucket', 'amount']], residual_df], ignore_index=True)

# Create the final pivot table using the more efficient pivot_table function
final_report = final_report_data.pivot_table(
    index='furid',
    columns='age_bucket',
    values='amount',
    aggfunc='sum',
    fill_value=0
).reset_index()

# Ensure all standard columns exist and are in the correct order
for col in AGE_LABELS:
    if col not in final_report.columns:
        final_report[col] = 0
final_report = final_report[['furid'] + AGE_LABELS]
final_report.rename(columns={'furid': 'FurID'}, inplace=True)

# --- 5. Save Output ---
output_filename = f'invoicing_ageing_report_{datetime.now(ZoneInfo("Asia/Kolkata")).strftime("%Y-%m-%dT%H:%M")}_{vertical}_by_invoice_age.csv'
final_report.to_csv(output_filename, index=False)
end_time = time.time()

print(f"✅ Report generation complete!")
print(f"   Saved to: {output_filename}")
print(f"   New execution time: {end_time - start_time:.4f} seconds.")
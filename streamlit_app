import streamlit as st
import pandas as pd
import numpy as np

st.set_page_config(layout="wide")
st.title("📊 Monthly Revenue Movement")

# -----------------------------
# Month selector
# -----------------------------
months = [
    "Apr'25", "May'25", "Jun'25", "Jul'25",
    "Aug'25", "Sep'25", "Oct'25", "Nov'25",
    "Dec'25", "Jan'26", "Feb'26", "Mar'26"
]

c1, c2 = st.columns(2)
with c1:
    month_1 = st.selectbox("Select Month 1", months, index=0)
with c2:
    month_2 = st.selectbox("Select Month 2", months, index=1)

# Ensure order
if months.index(month_2) <= months.index(month_1):
    st.error("Month 2 must be after Month 1")
    st.stop()

# -----------------------------
# Updated rows to match screenshot
# -----------------------------
rows = [
    "Opening Revenue",
    "Min tenure for opening month",
    "Adjusted opening",
    "New deliveries (Addition of Cx)",
    "No longer NPA Cx",
    "Upsell (Addition in item count)",
    "NPA",
    "Partial pickup (Reduction in item count)",
    "Full pickup (Reduction of Cx)",
    "Minimum tenure charges",
    "Pickup cancellations",
    "Penalty",
    "Plan transition (Same count of items)",
    "VAS Revenue",
    "VAS Revenue - Furlenco Care & Flexi",
    "VAS Revenue - Delivery charges",
    "VAS Revenue - Installation Charges",
    "Current month VAS",
    "Previous month VAS",
    "Total closing Revenue",
    "Closing Revenue (Items)",
    "Total Revenue",
    "Gap",
]


# -----------------------------
# Generator for summary data
# -----------------------------
def generate_month(seed, opening_revenue):
    np.random.seed(seed)

    movements = {
        "Min tenure for opening month": np.random.randint(2_000_000, 4_000_000),
        "Adjusted opening": 0,  # This is calculated
        "New deliveries (Addition of Cx)": np.random.randint(15_000_000, 19_000_000),
        "No longer NPA Cx": np.random.randint(1_500_000, 3_000_000),
        "Upsell (Addition in item count)": np.random.randint(4_000_000, 6_000_000),
        "NPA": 0,
        "Partial pickup (Reduction in item count)": -np.random.randint(4_000_000, 6_000_000),
        "Full pickup (Reduction of Cx)": -np.random.randint(12_000_000, 15_000_000),
        "Minimum tenure charges": np.random.randint(2_500_000, 4_000_000),
        "Pickup cancellations": 0,
        "Penalty": 0,
        "Plan transition (Same count of items)": np.random.randint(2_000_000, 4_000_000),
        "VAS Revenue": 0,
        "VAS Revenue - Furlenco Care & Flexi": 0,
        "VAS Revenue - Delivery charges": 0,
        "VAS Revenue - Installation Charges": 0,
        "Current month VAS": np.random.randint(10_000_000, 12_000_000),
        "Previous month VAS": np.random.randint(9_000_000, 11_000_000),
    }

    items_open = np.random.randint(350_000, 380_000)
    cx_open = np.random.randint(105_000, 115_000)

    items_close = items_open + np.random.randint(15_000, 25_000)
    cx_close = cx_open + np.random.randint(3_000, 6_000)

    # Calculate adjusted opening
    min_tenure = movements["Min tenure for opening month"]
    adjusted_opening = opening_revenue + min_tenure
    movements["Adjusted opening"] = adjusted_opening

    # Calculate total closing revenue
    total_closing = (
            adjusted_opening +
            movements["New deliveries (Addition of Cx)"] +
            movements["No longer NPA Cx"] +
            movements["Upsell (Addition in item count)"] +
            movements["NPA"] +
            movements["Partial pickup (Reduction in item count)"] +
            movements["Full pickup (Reduction of Cx)"] +
            movements["Minimum tenure charges"] +
            movements["Pickup cancellations"] +
            movements["Penalty"] +
            movements["Plan transition (Same count of items)"]
    )

    closing_revenue_items = total_closing
    total_closing_with_vas = total_closing + movements["Current month VAS"] + movements["Previous month VAS"]

    total_revenue = closing_revenue_items
    gap = np.random.randint(-500_000, 500_000)

    data = []

    for row in rows:
        if row == "Opening Revenue":
            revenue = opening_revenue
            items = items_open
            cx = cx_open
        elif row == "Adjusted opening":
            revenue = adjusted_opening
            items = None
            cx = None
        elif row in movements:
            revenue = movements[row]
            if row == "New deliveries (Addition of Cx)":
                items = np.random.randint(35_000, 45_000)
                cx = np.random.randint(12_000, 14_000)
            elif row == "No longer NPA Cx":
                items = np.random.randint(3_000, 5_000)
                cx = np.random.randint(800, 1_200)
            elif row == "Upsell (Addition in item count)":
                items = np.random.randint(10_000, 12_000)
                cx = np.random.randint(3_000, 4_000)
            elif row == "Partial pickup (Reduction in item count)":
                items = -np.random.randint(9_000, 11_000)
                cx = -np.random.randint(3_000, 4_000)
            elif row == "Full pickup (Reduction of Cx)":
                items = -np.random.randint(25_000, 30_000)
                cx = -np.random.randint(7_500, 9_000)
            elif row == "Minimum tenure charges":
                items = None
                cx = np.random.randint(1_200, 1_500)
            else:
                items = None
                cx = None
        elif row == "Total closing Revenue":
            revenue = total_closing_with_vas
            items = None
            cx = None
        elif row == "Closing Revenue (Items)":
            revenue = closing_revenue_items
            items = None
            cx = None
        elif row == "Total Revenue":
            revenue = total_revenue
            items = None
            cx = None
        elif row == "Gap":
            revenue = gap
            items = None
            cx = None
        else:
            revenue = None
            items = None
            cx = None

        arpu = revenue / cx if cx not in [None, 0] and revenue else None

        data.append({
            "Particular": row,
            "Items": items,
            "Cx": cx,
            "Revenue": revenue,
            "ARPU": round(arpu, 0) if arpu else None
        })

    return pd.DataFrame(data), closing_revenue_items


# -----------------------------
# Generate customer-level detail data
# -----------------------------
def generate_customer_details(particular, month, revenue, items, cx, seed=42):
    """Generate dummy customer-level data for drill-down"""
    np.random.seed(seed)

    # Determine number of records
    num_records = min(abs(cx) if cx and cx != 0 else 100, 200)

    cities = ['Bangalore', 'Mumbai', 'Delhi', 'Pune', 'Hyderabad', 'Chennai']
    regions = ['South', 'West', 'North', 'Central']
    categories = ['Furniture', 'Appliances', 'Electronics', 'Home Decor']
    reasons = ['Relocation', 'Quality Issue', 'Financial', 'Not Satisfied', 'Upgrade']

    # Generate customer data
    customers = []
    for i in range(num_records):
        cust_id = f"CUST{np.random.randint(100000, 999999)}"
        cust_name = f"Customer {np.random.randint(1, 10000)}"
        order_id = f"ORD{np.random.randint(10000000, 99999999)}"

        # Distribute revenue across customers
        if revenue and num_records > 0:
            base_rev = revenue / num_records
            variation = np.random.uniform(0.5, 1.5)
            cust_revenue = base_rev * variation
        else:
            cust_revenue = np.random.randint(500, 50000)

        city = np.random.choice(cities)
        region = np.random.choice(regions)
        category = np.random.choice(categories)

        record = {
            'Customer ID': cust_id,
            'Customer Name': cust_name,
            'Order ID': order_id,
            'Revenue': cust_revenue,
            'City': city,
            'Region': region,
            'Category': category
        }

        # Add specific fields based on particular type
        if 'pickup' in particular.lower():
            record['Return Reason'] = np.random.choice(reasons)
            month_prefix = month.split("'")[0]
            record['Return Date'] = f"{month_prefix}-{np.random.randint(1, 28):02d}"
        elif 'delivery' in particular.lower() or 'deliveries' in particular.lower():
            month_prefix = month.split("'")[0]
            record['Delivery Date'] = f"{month_prefix}-{np.random.randint(1, 28):02d}"
            record['Delivery Address'] = f"{np.random.randint(1, 999)} {city} Street"
        elif 'upsell' in particular.lower():
            record['Product'] = np.random.choice(['Sofa', 'Bed', 'Table', 'Chair', 'TV', 'Fridge'])
            month_prefix = month.split("'")[0]
            record['Added Date'] = f"{month_prefix}-{np.random.randint(1, 28):02d}"

        customers.append(record)

    return pd.DataFrame(customers)


# -----------------------------
# Drill-down modal
# -----------------------------
@st.dialog("📋 Customer Details", width="large")
def show_customer_details(particular, month, revenue, items, cx, seed):
    st.subheader(f"{particular} - {month}")

    # Generate detail data
    detail_df = generate_customer_details(particular, month, revenue, items, cx, seed)

    # Summary metrics
    col1, col2, col3, col4 = st.columns(4)
    with col1:
        st.metric("Total Customers", f"{len(detail_df):,}")
    with col2:
        st.metric("Total Revenue", f"₹{detail_df['Revenue'].sum():,.0f}")
    with col3:
        st.metric("Avg Revenue/Customer", f"₹{detail_df['Revenue'].mean():,.0f}")
    with col4:
        st.metric("Max Revenue", f"₹{detail_df['Revenue'].max():,.0f}")

    st.markdown("---")

    # Filters
    col1, col2, col3 = st.columns(3)
    with col1:
        search = st.text_input("🔍 Search Customer ID/Name", key=f"search_{particular}_{month}")
    with col2:
        city_filter = st.multiselect("Filter by City", detail_df['City'].unique(), key=f"city_{particular}_{month}")
    with col3:
        region_filter = st.multiselect("Filter by Region", detail_df['Region'].unique(),
                                       key=f"region_{particular}_{month}")

    # Apply filters
    filtered_df = detail_df.copy()
    if search:
        filtered_df = filtered_df[
            filtered_df['Customer ID'].str.contains(search, case=False, na=False) |
            filtered_df['Customer Name'].str.contains(search, case=False, na=False)
            ]
    if city_filter:
        filtered_df = filtered_df[filtered_df['City'].isin(city_filter)]
    if region_filter:
        filtered_df = filtered_df[filtered_df['Region'].isin(region_filter)]

    # Display table with formatted revenue
    display_df = filtered_df.copy()
    display_df['Revenue'] = display_df['Revenue'].apply(lambda x: f"₹{x:,.0f}")

    st.dataframe(
        display_df,
        use_container_width=True,
        height=400,
        hide_index=True
    )

    # Download button
    csv = filtered_df.to_csv(index=False)
    st.download_button(
        "📥 Download Details (CSV)",
        csv,
        f"{particular}_{month}_details.csv",
        "text/csv",
        key=f"download_{particular}_{month}"
    )


# -----------------------------
# Generate sequential months
# -----------------------------
opening_m1 = np.random.randint(160_000_000, 170_000_000)

df_m1, closing_m1 = generate_month(seed=10, opening_revenue=opening_m1)
df_m2, closing_m2 = generate_month(seed=20, opening_revenue=closing_m1)

# -----------------------------
# Create header row
# -----------------------------
st.subheader("Revenue Bridge View")
st.info("💡 Click on any Revenue, Items, or Cx number to view customer-level details")

# Create header
header_cols = st.columns([2.5, 0.8, 0.8, 1.3, 0.8, 0.8, 0.8, 1.3, 0.8])
with header_cols[0]:
    st.markdown("**Particulars**")
with header_cols[1]:
    st.markdown(f"**Items count**")
with header_cols[2]:
    st.markdown(f"**Cx count**")
with header_cols[3]:
    st.markdown(f"**Taxable revenue<br>(without VAS)**", unsafe_allow_html=True)
with header_cols[4]:
    st.markdown(f"**ARPU**")
with header_cols[5]:
    st.markdown(f"**Items count**")
with header_cols[6]:
    st.markdown(f"**Cx count**")
with header_cols[7]:
    st.markdown(f"**Taxable revenue<br>(without VAS)**", unsafe_allow_html=True)
with header_cols[8]:
    st.markdown(f"**ARPU**")

# Month headers
month_header_cols = st.columns([2.5, 3.7, 3.7])
with month_header_cols[0]:
    st.write("")
with month_header_cols[1]:
    st.markdown(f"<h4 style='text-align: center;'>{month_1}</h4>", unsafe_allow_html=True)
with month_header_cols[2]:
    st.markdown(f"<h4 style='text-align: center;'>{month_2}</h4>", unsafe_allow_html=True)

st.markdown("---")

# -----------------------------
# Display with clickable cells
# -----------------------------
for idx, (_, row) in enumerate(df_m1.iterrows()):
    cols = st.columns([2.5, 0.8, 0.8, 1.3, 0.8, 0.8, 0.8, 1.3, 0.8])

    particular = row['Particular']

    # Particular column
    with cols[0]:
        if particular in ['Opening Revenue', 'Total closing Revenue', 'Total Revenue', 'Gap']:
            st.markdown(f"**{particular}**")
        else:
            st.write(particular)

    # Month 1 columns
    with cols[1]:
        items_m1 = row['Items']
        if pd.notna(items_m1):
            if st.button(f"{int(items_m1):,}", key=f"items_{particular}_m1_{idx}", use_container_width=True):
                show_customer_details(particular, month_1, row['Revenue'], items_m1, row['Cx'], seed=10 + idx)
        else:
            st.write("")

    with cols[2]:
        cx_m1 = row['Cx']
        if pd.notna(cx_m1):
            if st.button(f"{int(cx_m1):,}", key=f"cx_{particular}_m1_{idx}", use_container_width=True):
                show_customer_details(particular, month_1, row['Revenue'], row['Items'], cx_m1, seed=10 + idx)
        else:
            st.write("")

    with cols[3]:
        rev_m1 = row['Revenue']
        if pd.notna(rev_m1):
            if st.button(f"₹{int(rev_m1):,}", key=f"rev_{particular}_m1_{idx}", use_container_width=True,
                         type="primary"):
                show_customer_details(particular, month_1, rev_m1, row['Items'], row['Cx'], seed=10 + idx)
        else:
            st.write("")

    with cols[4]:
        arpu_m1 = row['ARPU']
        if pd.notna(arpu_m1):
            st.write(f"{int(arpu_m1):,}")
        else:
            st.write("")

    # Month 2 columns
    row_m2 = df_m2.iloc[idx]

    with cols[5]:
        items_m2 = row_m2['Items']
        if pd.notna(items_m2):
            if st.button(f"{int(items_m2):,}", key=f"items_{particular}_m2_{idx}", use_container_width=True):
                show_customer_details(particular, month_2, row_m2['Revenue'], items_m2, row_m2['Cx'], seed=20 + idx)
        else:
            st.write("")

    with cols[6]:
        cx_m2 = row_m2['Cx']
        if pd.notna(cx_m2):
            if st.button(f"{int(cx_m2):,}", key=f"cx_{particular}_m2_{idx}", use_container_width=True):
                show_customer_details(particular, month_2, row_m2['Revenue'], row_m2['Items'], cx_m2, seed=20 + idx)
        else:
            st.write("")

    with cols[7]:
        rev_m2 = row_m2['Revenue']
        if pd.notna(rev_m2):
            if st.button(f"₹{int(rev_m2):,}", key=f"rev_{particular}_m2_{idx}", use_container_width=True,
                         type="primary"):
                show_customer_details(particular, month_2, rev_m2, row_m2['Items'], row_m2['Cx'], seed=20 + idx)
        else:
            st.write("")

    with cols[8]:
        arpu_m2 = row_m2['ARPU']
        if pd.notna(arpu_m2):
            st.write(f"{int(arpu_m2):,}")
        else:
            st.write("")

st.markdown("---")
st.success(f"✔ Opening revenue of {month_2} equals Closing revenue of {month_1}: ₹{int(closing_m1):,}")

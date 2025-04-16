

#  Raise_application – Exploring SQL Window Functions

Welcome to our SQL Window Functions assignment!  
Repo by **Team Name: `Raise_application`** 😄

# Group member:
**25188 Dondou Abiyi**

**25459 Mugisha Eric**

## 📋 Dataset

We’re using a custom dataset of **sales transactions** across different product categories and regions.

### 📁 Files
- `create_tables.sql` – Table structure
- `insert_data.sql` – Sample data
- `window_functions.sql` – All queries
- `README.md` – Explanation and documentation (this file)

---

## 🛠️ Table Schema

```sql
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    region VARCHAR(50),
    amount INT,
    sale_date DATE
);
```

---

## 📥 Sample Data

```sql
INSERT INTO sales VALUES (1, 'Laptop', 'Electronics', 'North', 1200, '2024-01-10');
INSERT INTO sales VALUES (2, 'Mouse', 'Electronics', 'North', 25, '2024-01-11');
INSERT INTO sales VALUES (3, 'Keyboard', 'Electronics', 'North', 45, '2024-01-12');
INSERT INTO sales VALUES (4, 'Shoes', 'Fashion', 'South', 70, '2024-01-10');
INSERT INTO sales VALUES (5, 'Jacket', 'Fashion', 'South', 90, '2024-01-11');
INSERT INTO sales VALUES (6, 'T-shirt', 'Fashion', 'South', 25, '2024-01-13');
INSERT INTO sales VALUES (7, 'Chair', 'Furniture', 'East', 100, '2024-01-10');
INSERT INTO sales VALUES (8, 'Desk', 'Furniture', 'East', 200, '2024-01-11');
INSERT INTO sales VALUES (9, 'Lamp', 'Furniture', 'East', 40, '2024-01-12');
INSERT INTO sales VALUES (10, 'Tablet', 'Electronics', 'West', 300, '2024-01-10');
INSERT INTO sales VALUES (11, 'Monitor', 'Electronics', 'West', 150, '2024-01-11');
INSERT INTO sales VALUES (12, 'Speaker', 'Electronics', 'West', 80, '2024-01-12');
```
![table_creation](https://github.com/user-attachments/assets/bbba4e77-82ca-4d04-9fce-6958cd0b4718)

---

## 🧪 Queries & Explanations

### 1️⃣ Compare Values with Previous or Next Records

```sql
SELECT 
    sale_id,
    product_name,
    category,
    region,
    amount,
    LAG(amount) OVER (PARTITION BY region ORDER BY sale_date) AS previous_amount,
    LEAD(amount) OVER (PARTITION BY region ORDER BY sale_date) AS next_amount,
    CASE
        WHEN amount > LAG(amount) OVER (PARTITION BY region ORDER BY sale_date) THEN 'HIGHER'
        WHEN amount < LAG(amount) OVER (PARTITION BY region ORDER BY sale_date) THEN 'LOWER'
        WHEN amount = LAG(amount) OVER (PARTITION BY region ORDER BY sale_date) THEN 'EQUAL'
        ELSE 'N/A'
    END AS comparison_with_previous
FROM sales;
```

#### 🔍 Explanation:
- **LAG()** and **LEAD()** are used to access the **previous** and **next** amount within the same region.
- We then compare the current amount with the **previous** one to determine whether it is **HIGHER**, **LOWER**, or **EQUAL**.
- Helps in trend analysis across time within regions.

---

### 2️⃣ Ranking Data within a Category

```sql
SELECT 
    product_name,
    category,
    region,
    amount,
    RANK() OVER (PARTITION BY category ORDER BY amount DESC) AS rank_amount,
    DENSE_RANK() OVER (PARTITION BY category ORDER BY amount DESC) AS dense_rank_amount
FROM sales;
```

#### 🔍 Explanation:
- We rank products within each **category** based on **amount (sales)** in descending order.
- **RANK()**: Gives the same rank for ties but skips the next rank.
- **DENSE_RANK()**: Also gives the same rank for ties but doesn’t skip ranks.
- Example:
  - Amounts: `100, 100, 90`
  - `RANK()` → `1, 1, 3`
  - `DENSE_RANK()` → `1, 1, 2`

---

### 3️⃣ Identifying Top Records

```sql
SELECT *
FROM (
    SELECT 
        product_name,
        category,
        amount,
        RANK() OVER (PARTITION BY category ORDER BY amount DESC) AS rnk
    FROM sales
) ranked_sales
WHERE rnk <= 3;
```
![Alt text](https://github.com/user-attachments/assets/610e8e55-5c03-4208-86f4-f2b6ca06a43a)

#### 🔍 Explanation:
- We use a subquery to rank products by amount within each **category**.
- Then filter to show only the **Top 3** per category.
- This ensures **ties are respected** using `RANK()`.

---

### 4️⃣ Finding the Earliest Records

```sql
SELECT *
FROM (
    SELECT 
        product_name,
        category,
        sale_date,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY sale_date ASC) AS row_num
    FROM sales
) ordered_sales
WHERE row_num <= 2;
```

#### 🔍 Explanation:
- We use `ROW_NUMBER()` to assign a **unique order** to each sale by date within a category.
- Then filter to return the **first 2 sales** per category based on `sale_date`.
- Useful for identifying **early trends or first movers**.

---

### 5️⃣ Aggregation with Window Functions

```sql
SELECT 
    product_name,
    category,
    amount,
    MAX(amount) OVER (PARTITION BY category) AS max_in_category,
    MAX(amount) OVER () AS overall_max
FROM sales;
```

#### 🔍 Explanation:
- `MAX() OVER (PARTITION BY category)`: Gets the **highest amount** within each category.
- `MAX() OVER ()`: Gets the **overall highest sale** in the entire dataset.
- Allows you to show **both local and global maximums** in the same result.

---


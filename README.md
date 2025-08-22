# Online Shopping System using MySQL

## 🛒 Project Overview
A simple online shopping system built using MySQL that manages products, customers, and orders. 
It uses a stored procedure to place orders and automatically update stock quantities.

---

## 🎯 Objective
To manage shopping operations like:
- Customer ordering
- Product stock checking
- Stock deduction after placing order
- Handling insufficient stock cases using a stored procedure

---

## 🧱 Key Features
- **Product Table**: Stores product info (ID, name, price, stock)
- **Customer Table**: Stores customer info
- **Orders Table**: Stores order date, customer and total amount
- **OrderDetails Table**: Stores items in each order

---

## ⚙️ Stored Procedure: `PlaceOrder`
- Checks stock availability
- Places order with product quantities
- Updates stock
- Shows error if stock is insufficient

---

## 🧪 Technologies Used tools
- MySQL
- XAMPP + phpMyAdmin
- GitHub
git 
---

## 📈 Sample Output
```sql
CALL PlaceOrder(1003, 102, 1, 2, 3, 2);
```

- Reduces stock for Product 1 and Product 3
- Creates entries in Orders and OrderDetails tables

---

## ✅ Status
- Tables Created ✅
- Data Inserted ✅
- Procedure Tested ✅
- GitHub Upload ✅

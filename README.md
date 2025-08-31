<img width="250" height="250" alt="mivro icons" src="https://github.com/user-attachments/assets/b13a94e2-8c54-4e0f-b073-39f812d47c5a" />

# Mivro Inventory & Sales Manager

A simple yet powerful Flutter app for managing products, categories, and sales with built-in analytics.  

---

## ✨ Features

- **Product Management**
  - Add, update, and delete products
  - Track product quantities
  - Products automatically move to `Uncategorized` if their category is deleted

- **Category Management**
  - Create custom categories
  - Delete categories safely (products get reassigned to `Uncategorized`)
  - Predefined base categories

- **Sales Management**
  - Add and delete sales
  - Product quantity automatically decreases on sale
  - Deleting a sale restores the sold quantity

- **Analytics**
  - Visualize sales trends with charts (fl_chart)
  - Monitor category distribution
  - Track total revenue and product stock

---

## 📊 Data Tracked

- **Products**
  - `id`, `name`, `price`, `quantity`, `category`
- **Categories**
  - `name` (unique)
- **Sales**
  - `id`, `productId`, `quantity`, `date`
- **Analytics Metrics**
  - Total Sales Revenue
  - Top-selling Products
  - Sales Over Time (line chart)
  - Category Distribution (pie chart)

---

## 🛠️ Tech Stack

- **Bloc / Cubit** – State management
- **Hive** – Local storage
- **fl_chart** – Data visualization
- **Google Fonts** – Typography

---

## 🖼️ Screenshots

<img width="1080" height="1080" alt="1" src="https://github.com/user-attachments/assets/3359ed34-456d-48cc-94e7-f72c53e0e948" />

<img width="1080" height="1080" alt="2" src="https://github.com/user-attachments/assets/3890bb39-1bb1-4c6e-bd7e-bf65004d0b26" />

---
## 📺 Demo


https://github.com/user-attachments/assets/3f9dda3a-48d5-4f11-b8f4-5ea3fa56c58d



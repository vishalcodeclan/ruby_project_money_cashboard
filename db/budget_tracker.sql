DROP TABLE transactions;
DROP TABLE budgets;
DROP TABLE categories;
DROP TABLE vendors;

CREATE TABLE categories (
  id SERIAL8 PRIMARY KEY,
  name VARCHAR(255),
  budget_id INT8 references budgets(id)
);

CREATE TABLE vendors (
  id SERIAL8 PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE budgets (
  id SERIAL8 PRIMARY KEY;
  amount INT8,
  start_date DATE,
  end_date DATE,
  category_id INT8 references categories(id),
);

CREATE TABLE transactions (
  id SERIAL8 PRIMARY KEY,
  transaction_date DATE,
  amount INT8,
  category_id INT8 references categories(id),
  vendor_id INT8 references vendors(id),
);

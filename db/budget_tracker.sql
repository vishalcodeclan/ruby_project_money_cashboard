DROP TABLE transactions;
DROP TABLE budgets;
DROP TABLE categories;
DROP TABLE vendors;


CREATE TABLE categories (
  id SERIAL8 PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE vendors (
  id SERIAL8 PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE budgets (
  id SERIAL8 PRIMARY KEY,
  amount_set NUMERIC,
  start_date DATE,
  category_id INT8 references categories(id)
);

CREATE TABLE transactions (
  id SERIAL8 PRIMARY KEY,
  transaction_date DATE,
  amount NUMERIC,
  category_id INT8 references categories(id),
  vendor_id INT8 references vendors(id)
);

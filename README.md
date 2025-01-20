# Stored Procedures and Functions in a Database

This repository contains SQL scripts for the generation of stored procedures and functions in a database, applying advanced SQL knowledge to create programming code that can execute various tasks at the database level.

## Objective

The goal of this project is to practice advanced SQL concepts in database programming by creating stored procedures and functions to perform specific tasks within the database.

## Development

### Initial Steps
1. Use the entity-relationship design, table creation script, and example data table (Excel file) published on the course platform as the working base.
2. Use Microsoft SQL Express as the DBMS.

### Tasks to be Implemented
1. **InsertarVenta Stored Procedure:**
   - Create the stored procedure "InsertarVenta" to register a new sale in the database. The stored procedure logic includes receiving parameters such as product code, quantity sold, customer identification number, employee code, store code, sale date, delivery date, and discount. Assume the invoice status is paid. Before insertion, validate the product's existence and sufficient stock quantity in the indicated store. If validations are successful, insert the invoice values and update the product's stock quantity.

2. **MontoTotalComprasCliente Function:**
   - Create the function "MontoTotalComprasCliente" to obtain the total purchases per customer in a specific period. The function logic involves receiving parameters such as customer identification number, start date, and end date. The function should return the total purchases (sum of each invoice's total) made by the customer in the specified period.

3. **ActualizarProducto Stored Procedure:**
   - Create the stored procedure "ActualizarProducto" to update product information in the database. The stored procedure logic includes receiving parameters such as product code, product name, unit price, brand code, and category code. Before updating, validate the product's existence. If the validation is successful, update the product information.

4. **StockTotalPorProducto Function:**
   - Create the function "StockTotalPorProducto" to calculate the total stock of a product in all stores. The function logic involves receiving the product code as a parameter and returning the sum of the stock quantity of the product in all stores.

## Usage Instructions
- Utilize the provided SQL scripts with Microsoft SQL Express software and the existing database based on the entity-relationship design, table creation script, and example data.
- Modify the scripts as needed for your specific database requirements.

## Contact

- LinkedIn: [Jorge Chaves Montiel](https://www.linkedin.com/in/jorge-chaves-montiel/)
- Email: jchavezmontiel@gmail.com

Thanks for reviewing my project! I am excited to explore new opportunities in the world of data analytics, finance, machine learning and deep learning. Feel free to contact me for more information about my work! 📊📈💼

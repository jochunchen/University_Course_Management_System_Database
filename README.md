# University-Course-Management-System-Database
This repository contains the SQL scripts for a project focused on managing and analyzing university course data. The scripts demonstrate a complete data pipeline, from raw data ingestion to a fully normalized and relational database schema.
## 1. Raw Data Ingestion (course_data_1nf_2023.sql)
This initial script creates a denormalized table called course_data. This table serves as the starting point, containing all the raw data in a single, unorganized format. It is designed to simulate a simple data dump, with comprehensive information on courses, students, and their academic records all in one place. This script is essential for providing the foundation and source material for the subsequent data transformation steps.
## 2. Database Schema Design (NF3-1.sql)
This script establishes a robust, normalized database schema by breaking down the single course_data table into multiple, interconnected tables. This design improves data integrity, eliminates redundancy, and makes the database more scalable and efficient. The schema includes tables for STUDENT, COURSE, TEACHER, CLASSROOM, and several junction tables (TeachBy, TakeBy, etc.) to manage complex relationships.
## 3. SQL Utility Function (NF3-2.sql)
This script introduces a T-SQL user-defined function named SplitStringToChars. This utility function is designed to handle string manipulation by splitting a given string into a table of its individual characters. This function is a key component of the data transformation process, enabling the parsing of complex, unstructured data like course times into a structured format that can be stored in the relational database.
## 4. Data Transformation and Population (NF3-3.sql)
This final script is the most critical part of the project. It orchestrates the entire data migration process:
1. Extracts Data: It systematically extracts unique records from the raw course_data table.
2. Parses Time Data: It uses the SplitStringToChars function to parse the unstructured course_time field, separating it into day and session components.
3. Populates Normalized Tables: The transformed data is then inserted into the clean, normalized tables created in Script 2.
4. Cleans Up: It concludes by dropping temporary tables, leaving behind a fully populated, well-structured relational database ready for querying and analysis.

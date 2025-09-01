
import csv
import sqlite3

# Connect to SQLite database (file-based)
conn = sqlite3.connect("movies.db")
cursor = conn.cursor()

# Create table with your columns
cursor.execute("""
    CREATE TABLE IF NOT EXISTS movies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        Series_Title TEXT,
        Released_Year INTEGER,
        Genre TEXT,
        IMDB_Rating REAL,
        Director TEXT,
        Star1 TEXT,
        Star2 TEXT,
        Star3 TEXT
    )
""")

# Read CSV and insert data
with open("movies.csv", "r", encoding="utf-8") as file:
    reader = csv.DictReader(file) # reads with headers
    for row in reader:
        cursor.execute("""
            INSERT INTO movies 
            (Series_Title, Released_Year, Genre, IMDB_Rating, Director, Star1, Star2, Star3)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            row["Series_Title"],
            row["Released_Year"],
            row["Genre"],
            row["IMDB_Rating"],
            row["Director"],
            row["Star1"],
            row["Star2"],
            row["Star3"]
        ))

conn.commit()
cursor.close()
conn.close()

print("Movies imported into movies.db successfully!")
	


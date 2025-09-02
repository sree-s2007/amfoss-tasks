import sqlite3
import csv

# Connect to SQLite database
conn = sqlite3.connect("movies.db")
cursor = conn.cursor()

# Open CSV file
with open("movies.csv", newline="", encoding="utf-8") as csvfile:
    reader = csv.reader(csvfile)
    header = next(reader) # skip header row
    for row in reader:
        cursor.execute(
            """
            INSERT INTO movies
            (Series_Title, Released_Year, Genre, IMDB_Rating, Director, Star1, Star2, Star3)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """,
            (row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7])
        )

# Commit changes
conn.commit()
print("Data imported successfully!")

cursor.close()
conn.close()

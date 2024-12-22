# Songs Analyzer

## Overview
Flask Songs Project is a robust backend-focused Python application designed for processing, managing, and analyzing song data stored in a structured database. This project includes advanced functionality for handling large-scale song datasets, generating detailed insights, and supporting dynamic SQL-based operations.

Additionally, this backend serves as a solid foundation for developing a frontend interface for song processing and analysis. Developers can build interactive applications leveraging the structured database and analytical capabilities provided by this project.
---

## Features

### Song Management:
- **Automated Song Ingestion**: Upload and process `.txt` song files directly into the database.
- **Detailed Word and Paragraph Analysis**: Track word positions, paragraph structures, and relationships within songs.

### Database Operations:
- **Dynamic SQL Execution**: Execute parameterized SQL queries and stored procedures seamlessly.
- **Comprehensive Database Cleanup**: Reset database state with efficient data purging tools.

### Advanced Analytics:
- **Song Statistics**: Generate comprehensive statistics about words, paragraphs, and lines within songs.
- **Search and Indexing**: Locate specific words, patterns, or phrases in songs and retrieve indexed results.
- **Rhyme Finder**: Identify rhyming words across songs or within specific contexts.

### Group and Word Management:
- **Custom Group Creation**: Organize words into thematic groups for advanced analysis.
- **Dynamic Word Associations**: Add or remove words from groups and maintain relational integrity.

### Dockerized SQL Server:
- **Pre-configured Database Container**: Includes a `.bat` script to create and manage an MSSQL-based database container for streamlined setup and use.

---

## Installation

### Prerequisites:
- Python 3.8 or later (recommended).
- Docker (for SQL Server container).
- Virtual environment setup (optional but recommended).

### Setup:

1. Clone the repository:
   ```bash
   git clone https://github.com/afik319/songs_analyzer.git
   ```

2. Create and activate a virtual environment:
   ```bash
   python -m venv .venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Configure environment variables:
   Create a `.env` file in the project root with the following format:
   ```env
   DB_TYPE=mssql
   HOST=localhost
   NAME=songs_db
   USER=sa
   PASSWORD=your_password
   DRIVER=ODBC Driver 17 for SQL Server
   ```

5. Set up the SQL Server container (optional):
   Run the provided `setup_container.bat` file to create an MSSQL container:
   ```bash
   new_sql_server.bat
   ```

6. Run the application:
   ```bash
   python main.py
   ```

---

## Usage

### Adding Songs:
- Place `.txt` song files in the `static/songs` directory or update the path in the `load_songs_from_files()` function.
- Run the script to process and upload them into the database automatically.

### Sample Queries:
- Retrieve statistics for a specific song:
  ```python
  await words_statistics_in_song_df("song_name")
  ```
- Find rhymes for a word:
  ```python
  await get_rhymes_for_word_df("word")
  ```

### Reset Database:
- Clear all data from the database using:
  ```python
  await clear_db()
  ```

---

## Project Structure

```plaintext
flask_songs_project/
├── static/songs/          # Directory for song text files
├── sql_via_code/          # Core SQL execution and utilities
├── text_processing.py     # Utilities for text analysis
├── functionality.py       # Core application logic
├── queries_bank.py        # SQL query definitions
├── requirements.txt       # Dependencies
├── main.py                # Entry point of the application
├── new_sql_server.bat    # Script to set up MSSQL Docker container
```

---

## Key Functions

### Analytical Queries:
- **words_statistics_in_song_df**: Retrieve word-level statistics for a specific song.
- **songs_with_expression_df**: Locate songs containing specific phrases or patterns.
- **get_rhymes_for_word_df**: Identify rhyming words within or across songs.

### Group Management:
- **insert_new_group**: Create thematic word groups for analysis.
- **group_words_index_df**: Retrieve indexed words within a specific group.
- **delete_group**: Remove groups and their associated data.

---

## Dockerized Database

### Setup with `new_sql_server.bat`:
The project includes a `.bat` script to quickly deploy a Docker container running MSSQL:

#### Script Highlights:
1. Creates a new Docker container from the pre-built image `afik319/mssql-songs-db`.
2. Maps the database port to `1433` on localhost.

Run the script:
```bash
new_sql_server.bat
```

Ensure Docker is installed and running before executing the script.

---

## License
This project is licensed under the MIT License.

---

## Contact
For questions or support, contact:
- **Author**: Afik Ratzon
- **Email**: afik.ratzon@gmail.com

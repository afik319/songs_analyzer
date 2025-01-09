# TuneDB - A Text-Based Lyrics Analysis, Search, and Indexing System

TuneDB is a Python-based web application that helps you upload, store, analyze, and manage song lyrics from text files. It features both a **backend** (built with Python) and a **frontend** (HTML, JavaScript, and TailwindCSS).

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Usage](#usage)
  - [Running the Application](#running-the-application)
  - [Uploading Songs](#uploading-songs)
- [Technical Details](#technical-details)
  - [Backend (Quart + Python)](#backend-quart--python)
  - [Frontend (HTML + TailwindCSS + JavaScript)](#frontend-html--tailwindcss--javascript)
- [Database](#database)
- [Routes](#routes)
- [Contributing](#contributing)

---

## Overview
TuneDB is designed to handle large sets of song lyrics in `.txt` format. It parses each uploaded text file (song), stores them in a relational database, and provides various utilities:
- Searching lyrics by words.
- Searching for specific phrases or expressions in songs.
- Deleting or editing song details.
- Displaying statistical information about words, lines, paragraphs, etc.
- Grouping words, managing groups, and more.

The project demonstrates an asynchronous backend with a separate event loop for database tasks, as well as a user-friendly UI built with HTML and TailwindCSS.

---

## Features
1. **Uploading Songs**  
   Allows uploading one or multiple `.txt` files. Each file represents a song.

2. **Lyrics Indexing and Search**  
   - Search for specific words, expressions, or phrases within the lyrics.
   - Find rhymes based on the last syllables.
   - View usage statistics for words, lines, paragraphs, and entire songs.

3. **Groups Management**  
   - Create groups for words.
   - Assign words to groups or remove them.
   - Delete entire groups.

4. **Expressions Management**  
   - Insert custom expressions.
   - Delete expressions on demand.
   - Search the expressions across all songs.

5. **Statistics**  
   - View comprehensive song-based statistics:
     - **Total words, total lines, total paragraphs, total characters**, etc.
     - **Word frequency**: how often each word appears within one song (and across all songs).
     - **Paragraph / line statistics**: average number of words per paragraph/line, paragraph/line densities, etc.
     - **Relative density**: compare how dense a line or paragraph is in one song vs. the overall average.
     - **Groups and expressions**: see how specific groups of words or custom expressions appear in the songs.

6. **Database Reset**  
   - Optionally reset (clear) all data from the database and remove all songs from `static/songs`.

---


**Key Python files**:
1. **`app.py`**  
   Main Quart server. Defines routes (e.g., `/upload`, `/delete-song`, `/insert-expression`, `/get-rhymes`, etc.) and manages an additional asynchronous event loop for DB tasks.

2. **`load_songs_files.py`**  
   - Processes `.txt` files (songs).
   - Splits lyrics into words, lines, paragraphs.
   - Inserts data into the database.

3. **`functionality.py`**  
   - Core functions for inserting/updating/deleting songs, details, groups, etc.
   - Contains functions for retrieving DB data (words, expressions, groups, etc.).

4. **`expression_processing.py`**  
   - Allows searching for multi-word expressions or phrases in `.txt` files.
   - Returns DataFrame results (e.g., which line/paragraph contains a phrase).

5. **`queries_bank.py`**  
   - Central place for SQL queries (INSERT, UPDATE, DELETE, SELECT).
   - Avoids scattering SQL code throughout the codebase.

6. **`text_processing.py`**  
   - Splits text into tokens while preserving punctuation/newline structure.
   - Extracts last syllables (for rhymes) using NLTK’s CMUDict or the `pronouncing` library.

**Key Frontend Templates** (in `templates/`):
- **`base.html`**  
  Layout for TailwindCSS styling, includes the sidebar and main content structure.
- **Various HTML files** like:
  - `upload.html`
  - `group.html`
  - `rhymes.html`
  - `expressions.html`
  - `stat.html`
  - `search.html`
  - `indexing.html`
  …all use Jinja2 templating from the `app.py` routes.

---

## Installation

Below are the recommended steps for setting up TuneDB in a Windows environment.  
**Note**: If you have a different OS or setup, adapt accordingly.

1. **Set Up the Python Virtual Environment**  
   - Double-click `venv.bat`.  
     - This script creates a new virtual environment (`venv`) and installs all required dependencies from `requirements.txt`.  
     - This is a **one-time** setup; you typically **do not** have to run it every time.

2. **Install Docker Desktop**  
   - Make sure Docker Desktop is installed and running on your machine.  
   - For Docker installation instructions, see the official [Docker documentation](https://docs.docker.com/get-docker/).

3. **Run the New SQL Server Container**  
   - Double-click `new_sql_server.bat`.  
     - This spins up a Docker container (named `sqlserver_container`) from the image `afik319/mssql-songs-db` and exposes **port 1433** by default.  
     - If you want to use a different port, change the `1433` value in the `.bat` file, **and** update the corresponding `HOST` value in the `.env` file (for example, `localhost:NEW_PORT`).  

4. **Configure the `.env` File**  
   - By default, it looks like this:
     ```
     DB_TYPE=MSSQL
     HOST=localhost:1433
     NAME=songs
     USER=SA
     PASSWORD=YourStrongPass123
     DRIVER=ODBC Driver 17 for SQL Server
     ```
   - Modify these settings if needed (e.g., different port, different DB name or credentials, etc.).  

5. **Launch the Application**  
   - Double-click `songs.bat` (assuming you have such a file).  
     - This should activate the virtual environment and start the Quart application (`app.py`) or equivalent script.  
     - Once running, open your browser at `http://127.0.0.1:5000` (or whichever host/port your app is set to).

6. **Verify Installation**  
   - Access the main page in your browser.  
   - You can now upload songs (`.txt` files) and verify your DB settings.

### Additional Notes
- `requirements.txt` contains all Python dependencies. If you need to manually install them (e.g., for non-Windows environments), run:

---

## Usage

### Running the Application

- (Code block fix needed)  
  Example commands:  
  python app.py  

- The server typically runs on `http://127.0.0.1:5000`.

### Uploading Songs
- **From the UI**:  
  Navigate to the “Upload” page and click **Browse**. Select one or more `.txt` files, then click **Upload**.
- **Files are stored** in `./static/songs/`.
- **Database** is updated with each song’s lines, paragraphs, words, etc.

---

## Technical Details

### Backend (Quart + Python)
- Asynchronous calls are handled by a separate event loop (`bg_loop`).
- `app.py` orchestrates the routes, while database transactions are mostly done with `await call_in_background(...)`.

### Frontend (HTML + TailwindCSS + JavaScript)
- The HTML templates are located in `templates/` and use [Jinja2](https://jinja.palletsprojects.com/) for dynamic data.
- **TailwindCSS** is loaded from a CDN.
- JavaScript code in `<script>` tags is used for client-side actions like:
  - Filtering table rows.
  - Handling user input and dynamic page interactions (select/deselect, search filters, etc.).

---

## Database
- The project uses a SQL database for storing songs, words, paragraphs, lines, groups, etc.
- **Stored Procedures** (like `RemoveSong`, `DeleteAllData`) and ad-hoc queries (in `queries_bank.py`) handle the heavy-lifting.

**Example**:
- **`songs` table**: holds song metadata (name, creation date, etc.).
- **`words_in_songs` table**: each row is a single word with references to paragraph, line, and position.

---

## Routes
Some main routes defined in `app.py`:

- **`/upload`** (POST): Upload new `.txt` files for parsing.  
- **`/delete-song/<song_name>`** (DELETE): Remove a song from the server folder and DB.  
- **`/delete-expression/<expression_str>`** (DELETE): Remove an expression from DB.  
- **`/insert-expression`** (POST): Insert a new expression.  
- **`/get-expression-shows`** (GET): Returns JSON with occurrences of an expression in `.txt` files.  
- **`/get-rhymes`** (GET): Get possible rhymes for a word.  
- **`/clear-db`** (DELETE): Clears the entire DB and static files.  
- **`/expressions`**, **`/search`**, **`/stat`**, **`/group`**, **`/indexing`**: Render templates for different sections of the UI.

---

## Contributing
Contributions are welcome! Feel free to open a pull request or file an issue.

1. Fork the repo
2. Create your feature branch (again, code block fix needed):  
   Example:  
   git checkout -b feature/newFeature  
3. Commit your changes:  
   git commit -am 'Add some feature'  
4. Push to the branch:  
   git push origin feature/newFeature  
5. Create a new Pull Request

---
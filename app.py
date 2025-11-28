from flask import Flask, render_template, request
from run_sql import run_sql
import os

app = Flask(__name__)

SQL_DIR = "sql"

def load_sql(filename):
    path = os.path.join(SQL_DIR, filename)
    with open(path, "r") as f:
        return f.read()


# -----------------------------
# MAIN MENU
# -----------------------------
@app.route("/")
def menu():
    return render_template("index.html")


# -----------------------------
# DROP TABLES
# -----------------------------
@app.route("/drop")
def drop_tables():
    sql = load_sql("drop_tables.sql")
    out = run_sql(sql, html=False)
    return render_template("result.html", title="Drop Tables", output=out)


# -----------------------------
# CREATE TABLES
# -----------------------------
@app.route("/create")
def create_tables():
    sql = load_sql("create_tables.sql")
    out = run_sql(sql, html=False)
    return render_template("result.html", title="Create Tables", output=out)


# -----------------------------
# POPULATE TABLES
# -----------------------------
@app.route("/populate")
def populate_tables():
    sql = load_sql("populate_tables.sql")
    out = run_sql(sql, html=False)
    return render_template("result.html", title="Populate Tables", output=out)


# -----------------------------
# QUERY SELECTION PAGE
# -----------------------------
@app.route("/query")
def query_tables():
    return render_template("query_select.html")


# -----------------------------
# VIEW TABLE OR VIEW
# -----------------------------
@app.route("/view_table")
def view_table():
    name = request.args.get("table")

    if not name:
        return render_template("result.html",
                               title="Error",
                               output="No table selected.")

    sql = f"SELECT * FROM {name};"
    out = run_sql(sql, html=True)

    return render_template("result.html",
                           title=f"Viewing {name}",
                           output=out)


# -----------------------------
# VIEW ADVANCED REPORT 
# -----------------------------
@app.route("/view_report")
def view_report():
    report_name = request.args.get("report")

    if not report_name:
        return render_template("result.html",
                               title="Error",
                               output="No report selected.")

    sql = f"SELECT * FROM {report_name};"
    out = run_sql(sql, html=True)

    return render_template("result.html",
                           title=f"Advanced Report: {report_name}",
                           output=out)







@app.route("/add_movie")
def add_movie():
    return render_template("add_movie.html")


@app.route("/add_movie_submit", methods=["POST"])
def add_movie_submit():
    name = request.form["name"]
    director = request.form["director"]
    genre = request.form["genre"]
    language = request.form["language"]
    year = request.form["year"]

    sql = f"""
        INSERT INTO MOVIE (Movie_id, Movie_name, Director, Genre, Language, Release_year)
        VALUES ((SELECT NVL(MAX(Movie_id),0)+1 FROM MOVIE),
                '{name}', '{director}', '{genre}', '{language}', {year});
    """

    out = run_sql(sql, html=False)
    return render_template("result.html", title="Movie Added", output=out)


# -----------------------------
# UPDATE MOVIE - SELECT WHICH MOVIE
# -----------------------------
@app.route("/select_movie_update")
def select_movie_update():

    query = "SELECT Movie_id, Movie_name FROM MOVIE ORDER BY Movie_id;"
    raw = run_sql(query, html=False)

    movies = []
    for line in raw.split("\n"):
        parts = line.split()
        if len(parts) >= 2 and parts[0].isdigit():
            movies.append((parts[0], " ".join(parts[1:])))

    return render_template("select_movie_update.html", movies=movies)


# -----------------------------
# UPDATE MOVIE FORM
# -----------------------------
@app.route("/update_movie")
def update_movie():
    movie_id = request.args.get("movie_id")
    return render_template("update_movie.html", movie_id=movie_id)


# -----------------------------
# UPDATE MOVIE SUBMISSION
# -----------------------------
@app.route("/update_movie_submit", methods=["POST"])
def update_movie_submit():
    movie_id = request.form["movie_id"]

    fields = {
        "Movie_name": request.form["name"],
        "Director": request.form["director"],
        "Genre": request.form["genre"],
        "Language": request.form["language"],
        "Release_year": request.form["year"],
    }

    set_clauses = []
    for col, value in fields.items():
        if value.strip():
            if col == "Release_year":
                set_clauses.append(f"{col} = {value}")
            else:
                set_clauses.append(f"{col} = '{value}'")

    if not set_clauses:
        return render_template("result.html",
                               title="Update Movie",
                               output="No fields provided.")

    sql = f"""
        UPDATE MOVIE
        SET {', '.join(set_clauses)}
        WHERE Movie_id = {movie_id};
    """

    out = run_sql(sql, html=False)
    return render_template("result.html", title="Movie Updated", output=out)



# -----------------------------
# DELETE A MOVIE
# -----------------------------
@app.route("/delete_movie")
def delete_movie_form():
    return render_template("delete_movie.html")


# -----------------------------
# PROCESS DELETE MOVIE
# -----------------------------
@app.route("/delete_movie_action", methods=["POST"])
def delete_movie_action():
    movie_id = request.form.get("movie_id")

    if not movie_id:
        return render_template("result.html",
                               title="Delete Movie",
                               output="No Movie ID entered.")


    sql = f"DELETE FROM MOVIE WHERE Movie_id = {movie_id};"

    out = run_sql(sql, html=False)

    return render_template("result.html",
                           title="Delete Movie",
                           output=f"Deleted Movie ID {movie_id}<br><br>{out}")




if __name__ == "__main__":
    app.run(debug=True)

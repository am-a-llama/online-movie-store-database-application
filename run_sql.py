import os
import subprocess
from dotenv import load_dotenv

load_dotenv()

SSH_USER = os.getenv("SSH_USER")
SSH_HOST = os.getenv("SSH_HOST")

ORACLE_USER = os.getenv("ORACLE_USER")
ORACLE_PASS = os.getenv("ORACLE_PASS")
ORACLE_HOST = os.getenv("ORACLE_HOST")
ORACLE_PORT = os.getenv("ORACLE_PORT")
ORACLE_SID = os.getenv("ORACLE_SID")

# Final Oracle connect string
ORACLE_CONN = (
    f"{ORACLE_USER}/{ORACLE_PASS}@"
    f"(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)"
    f"(Host={ORACLE_HOST})(Port={ORACLE_PORT}))"
    f"(CONNECT_DATA=(SID={ORACLE_SID})))"
)


def run_sql(sql_text, html=False):
    """
    Runs SQL on remote TMU Oracle via SSH + sqlplus64.
    If html=True, converts SQLPlus output into an HTML table.
    """

    wrapper = f"""
SET HEADING ON
SET PAGESIZE 5000
SET LINESIZE 5000
SET COLSEP '|'
SET TRIMSPOOL ON

{sql_text}

EXIT
"""

    ORACLE_SQLPLUS = "/usr/bin/sqlplus64"
    escaped_conn = f"'{ORACLE_CONN}'"

    ssh_cmd = (
        f"ssh {SSH_USER}@{SSH_HOST} "
        f"\"printf \\\"{wrapper}\\\" | {ORACLE_SQLPLUS} -s {escaped_conn}\""
    )

    raw_output = subprocess.getoutput(ssh_cmd).strip()

    if html:
        return convert_to_html_table(raw_output)
    else:
        return raw_output


def convert_to_html_table(text):
    """
    Converts SQLPlus column output into a clean HTML table.
    Only used for SELECT queries.
    """

    lines = [l for l in text.split("\n") if l.strip()]

    cleaned = []
    for line in lines:
        stripped = line.strip()

        # Remove separator lines like ----|----|----
        if set(stripped.replace("|", "").strip()) == {"-"}:
            continue

        cleaned.append(stripped)

    if len(cleaned) < 2:
        return "<p>No results.</p>"

    headers = [h.strip() for h in cleaned[0].split("|")]

    html = "<table style='border-collapse:collapse; margin:20px auto; color:white;' border='1' cellpadding='8'>"
    html += "<tr>" + "".join(f"<th style='background:#333;'>{h}</th>" for h in headers) + "</tr>"

    for row in cleaned[1:]:
        cols = [c.strip() for c in row.split("|")]
        html += "<tr>" + "".join(f"<td>{c}</td>" for c in cols) + "</tr>"

    html += "</table>"
    return html

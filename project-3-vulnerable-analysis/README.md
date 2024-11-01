# Project 3 - Analyze code and look for vulnerabilities

This project is focused on analyzing vulnerable code snippets using GitHub Copilot. The snippet provided below was captured by a code scanning tool without any additional context, your task will be to use GH Copilot to analyze the code for any known security vulnerabilities and document it. Copilot will assist you in identifying potential issues and generating proper documentation.

```python
def get_user_data(username):
    conn = sqlite3.connect('example.db')
    cursor = conn.cursor()
    
    # Secure against SQL injection
    query = "SELECT * FROM users WHERE username = ?"
    cursor.execute(query, (username,))
    
    result = cursor.fetchall()
    conn.close()
    
    return result

<details>

<summary>Hints for Completion</summary>
    - Are regular expressions for input validation secure?  Ask Copilot for other ways to handle input validation.
	- Ask Copilot how to create a virtual environment and install a secure library

</details>
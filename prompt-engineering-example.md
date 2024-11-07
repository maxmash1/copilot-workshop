# Example Demo for Copilot - Short

- [Purpose](#purpose)
- [Getting Started](#getting-started)
- [Examples](#Examples)
    - [Hello World with Current Date and Time](#hello-world-with-current-date-and-time)
    - [Creating Math Function with User Generated Inputs with Error Handling](#creating-math-function-with-user-generated-inputs-with-error-handling)
    - [Adding a Terraform Deployment](#adding-a-terraform-deployment)
    - [Copilot with Bookstore](#copilot-with-bookstore)

## Purpose

The purpose of these demo examples is to be able to quickly demo Copilot features in the IDE without much prep, setup, or in-depth technical knowledge. They can be adjusted to fit for time and customer interest. 

> [!IMPORTANT]
> Due to the way Copilot works, results are generated probabilistically, and are subject to change unexpectedly due to a variety of factors. These examples have been picked as they tend to produce relatively consistent results, but your miles may vary. This demo was written using the GPT 4o model.

> [!NOTE]
> Language translation has been removed to keep this demo simple.  It can be done with Copilot editor, but has a limitation on the number of files.


## Getting Started

For these demos you will need the following:
- [Visual Studio Code](https://code.visualstudio.com/)
- [Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)
- [Copilot Chat](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot-chat)
- Install Python 3.x
    - [Brew](https://brew.sh/) is recommended for Macintosh users
- Install VS Code Python language support extension pack
- Create a new folder named `shortdemo` and in VS Code 
- Shift + Cmd + P and run `Python: Create Environment` and follow the instructions to create a venv

> [!WARNING]
> You may have to restart VS Code for your terminal to activate the venvs depending on your settings.  Alternatively, you can run `source ./.venv/bin/activate`


## Examples

### Hello World with Current Date and Time 

You can start out with the simplest example just to take a moment to demonstrate the basic functionality and and explain the mechanics of Copilot. 

#### Key Points
Explain the basic mechanics of Copilot: 
- Inline chat prompts to start building
- Model Choice
- Autocomplete suggestions
  - Accept suggestions by hitting tab
  - Viewing alternative suggestions

#### Demo Steps
- Create a new python file, and start building with the following inline chat prompt (cmd + i)

`Create a hello world function and include current date and time with datetime module`

- Make sure to note here that different models are available and the benefits of each

- After accepting the suggestion, start typing `echo` after the print line for autocomplete suggestions and toggle through the alternatives.


<details>
<summary>Typical Copilot Output</summary>

```python
from datetime import datetime

def hello_world():
    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"Hello, World! Current date and time is: {current_time}")

if __name__ == "__main__":
    hello_world()
```
</details>

----
### Creating Math Function with User Generated Inputs with Error Handling

This example demonstrates how to add extra qualifiers around what you are asking Copilot to do - in this case, adding error handling. This is also a good opportunity to show off some of the features of Copilot Chat and you can demonstrate how Copilot learns from it's context.

#### Key Points
- **/edit** - Updaes code from context
- **/explain** - Explains what code is doing in words
- **/doc**: Comments code
- **/setupTests** and **/tests** for creating tests
- Multiple file support using the editor
- **@workspace** for quesions on your workspace


> [!TIP]
>  If at any point in the demo something isn't working, prompt `/fix` to have Copilot attempt to resolve whatever is broken

#### Demo Steps
- Create a new file `math_ops.py` and start building with the following inline chat prompt (cmd + i)

`Create a function to divide two user generated numbers with error handling`

- Highlight the code block and prompt the following which will trigger `/edit`

`Update the code to also ask for a third number and add the result to the first two numbers`

- Prompt `/explain` to have Copilot explain in detail what the code is doing.
- Prompt `/doc` to have Copilot generate a commented explanation within the code.
- Open the Copilot side window and prompt `/setupTests` to begin setting up your IDE for testing.  This demo uses pytest > root directory > test_*.py
    - Follow the directions, using insert into terminal
- Prompt `@workspace /tests` to have Copilot generate unit tests for this code.
  - Save the generated file as `test_math_ops.py`
  - Run the tests 
  - Run the program
- Open the Copilot editor and prompt

`Create a graphical display of these numbers in a webpage instead of showing the output in the terminal`
- Copilot should create an app.py and index.html, accept these changes and save the files
    - Notice that all these files are now in the working set for additionial changes
- Prompt chat the following and follow the directions to show a working web application

`@workspace How do I run this application`

<details>
<summary>Typical Copilot Result</summary>

math_ops.py
```python
fdef divide_numbers(num1, num2, num3):
    try:
        result = num1 / num2
        final_result = result + num3
    except ZeroDivisionError:
        return "Error: Division by zero is not allowed."
    return final_result

if __name__ == "__main__":
    num1 = float(input("Enter the first number: "))
    num2 = float(input("Enter the second number: "))
    num3 = float(input("Enter the third number: "))
    print(divide_numbers(num1, num2, num3))
```

app.py
```python
from flask import Flask, request, render_template
from math_ops import divide_numbers

app = Flask(__name__)

@app.route("/", methods=["GET", "POST"])
def index():
    result = None
    if request.method == "POST":
        try:
            num1 = float(request.form["num1"])
            num2 = float(request.form["num2"])
            num3 = float(request.form["num3"])
            result = divide_numbers(num1, num2, num3)
        except ValueError:
            result = "Invalid input. Please enter numeric values."
    return render_template("index.html", result=result)

if __name__ == "__main__":
    app.run(debug=True)
```

index.html
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Math Operations</title>
</head>
<body>
    <h1>Divide Numbers</h1>
    <form method="post">
        <label for="num1">Enter the first number:</label>
        <input type="text" id="num1" name="num1" required><br><br>
        <label for="num2">Enter the second number:</label>
        <input type="text" id="num2" name="num2" required><br><br>
        <label for="num3">Enter the third number:</label>
        <input type="text" id="num3" name="num3" required><br><br>
        <button type="submit">Calculate</button>
    </form>
    {% if result is not none %}
        <h2>Result: {{ result }}</h2>
    {% endif %}
</body>
</html>
```

</details>

----
### Adding a Terraform Deployment

##### Key Points
- How easy it is to generate boilerplate terraform code without having to lookup from other contexts


#### Demo Steps
- In the Copilot editor with all of the files created in the working set prompt

`Create a terraform template for azure` 
- Copilot will generate all the necessary files for an azure deployment with terraform for a flask application
- Click accept and save the files

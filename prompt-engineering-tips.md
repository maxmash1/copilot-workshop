# Prompt Engineering Tips and Tricks
## Prompt Engineering
- Be specific and provide context with prompts
	- Explore the following using https://editor.p5js.org/ and Copilot IDE Chat
`draw an ice cream cone` 
vs
`draw an ice cream cone with using p5.js`
vs
`draw an ice cream cone with a single scoop and a cherry on top of whip cream using p5.js`
- If you can't describe it, provide examples for better output
- Iterate to improve results

## Copilot IDE Chat
### General
- Use `@workspace /new` to create a project workspace with proper scaffolding
- Use `@workspace` for questions on how to build or run your application if unfamiliar
- `/help` to see all the commands available in your copilot since it can be different with Copilot extensions
	- This command also helps you understand how to provide context
- Use `/startDebugging` to have Copilot assist with debug setup
- Auto complete should be used as assistant when in deep code flow and chat/editor should used for code generation from prompt
- In the terminal, highlight and have copilot explain for compile errors

### Multi File
- Use the editor for working with multiple files and generating new files

### Single File
- Highlight code and and use `/edit` to make updates
- Use `/fix` for suggestions on how to improve code quality
- Click any errors/warnings "the dreaded squiggles" and have copilot fix
- Before running `/tests`, always use `/setupTests` to get VSCode ready for your project
- `/fixTestFailure` is fantastic for troubleshooting tests

### Extensions
- `@terminal` for assistance with anything in the terminal
- `@vscode` for assistance with anything in VSCode
- `@mermaid` for creating diagrams



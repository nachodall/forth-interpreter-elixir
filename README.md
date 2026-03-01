# Forth Interpreter (Elixir)

This project is a full-featured **Forth interpreter** built with **Elixir**, integrated into a **Phoenix LiveView** application with **PostgreSQL** database persistence.



## Overview

The application allows users to write Forth programs, evaluate them in real-time, and automatically persist the execution history in a database.

### Architecture
* **Core Logic:** Pure Elixir module (`Forth.eval/2`) handling token parsing, stack operations, and strict error handling (e.g., stack underflows, division by zero). Cleanly integrated into the application's domain logic in `lib/forth_interpreter_elixir/forth.ex`.
* **Web Interface:** A reactive single-page application built with **Phoenix LiveView** for instant user feedback.
* **Persistence:** **PostgreSQL** database integrated via **Ecto** to store and display the history of all evaluations.

### Supported Language Features
* **Integer Arithmetic:** `+`, `-`, `*`, `/`
* **Stack Manipulation:** `DUP`, `DROP`, `SWAP`, `OVER`
* **Custom Words:** Definition of new words using the standard syntax (`: word-name definition ;`).

---

## 1. Prerequisites
Ensure you have the following installed on your system:
* **Elixir** (1.18 or later)
* **Erlang/OTP** (27 or later)
* **PostgreSQL** (Running locally)

## 2. Compilation & Setup
Before running the application for the first time, you must install dependencies and setup the database.

```bash
# Install dependencies
mix deps.get

# Setup the database (create and migrate)
# Note: Ensure your DB credentials in config/dev.exs are correct
mix ecto.setup
```
## 3. Running the Application

To start the Phoenix LiveView interface:
```Bash
# Start the server
mix phx.server
```
Once started, you can access the interface at http://localhost:4000.

## 4. Running Tests

The project includes a comprehensive test suite for both the core Forth logic and the web components.
Bash
```Bash
# Run all tests
mix test
```

## 5. Using the Program

    Input: Type your Forth code into the "Program Input" text area. (Example: 1 2 + 3 *)

    Action: Click the Evaluate button to process the code.

    Results: The current result (stack state or error message) will appear immediately below the input area.

    History: Every evaluation is automatically saved to the PostgreSQL database and displayed in the history table at the bottom of the page.

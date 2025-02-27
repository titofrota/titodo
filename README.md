# TiTodo ✅ -  What needs to be done?

TiTodo is a simple yet effective to-do list application built with Ruby on Rails and Docker. It provides an intuitive interface for managing tasks, allowing users to create, edit, complete, and delete to-dos seamlessly.

[Live Demo](https://titodo.onrender.com)

## Table of Contents

- [TiTodo ✅ -  What needs to be done?](#titodo-----what-needs-to-be-done)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Tech Stack](#tech-stack)
  - [Setup and Installation](#setup-and-installation)
  - [Running the Application](#running-the-application)
  - [Running Tests](#running-tests)
  - [License](#license)

## Features

- View a list of to-do items
- Filter tasks by status: pending, completed, or all
- Create new to-do items
- Edit existing tasks
- Mark tasks as complete
- Delete tasks

## Tech Stack

- **Back-end:** Ruby on Rails, PostgreSQL
- **Front-end:** ERB, TailwindCSS, Turbo, Stimulus
- **Infrastructure:** Docker, Docker Compose

## Setup and Installation

Ensure you have [Docker](https://docs.docker.com/get-docker/) installed before proceeding.

```sh
git clone https://github.com/italofrota/titodo.git
cd titodo
cp .env.example .env
docker compose up --build
```

Once the setup is complete, initialize the database:

```sh
./run rails db:setup
```

## Running the Application

Start the application by running:

```sh
docker compose up
```

Then, open [http://localhost:8000](http://localhost:8000) in your browser.

## Running Tests

To run the test suite, execute:

```sh
./run test
```

For static code analysis using Rubocop:

```sh
./run rubocop
```

## License

This project is licensed under the MIT License. You must keep my name and email address in the LICENSE file to adhere to the agreement. If you modify this project, feel free to add your name and email on a new line.

Thanks to [Nick Janetakis](https://nickjanetakis.com) for the base starter template.
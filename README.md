# Sample Application

## Requirements

1. Elixir 1.7.x
2. PostgreSQL 10.x

## Project structure

* `Api` (`apps/api`) - Web API layer
* `Core` (`apps/core`) - data layer

## Setup

1. Configure database credentials:

  ```bash
  cp apps/core/config/secret.exs.example apps/core/config/dev.secret.exs
  cp apps/core/config/secret.exs.example apps/core/config/test.secret.exs
  ```

1. Setup database:

  ```bash
  mix core.setup
  ```

1. Start the server and console

  ```bash
  iex -S mix phx.server
  ```

1. Access the API under http://localhost:4000.

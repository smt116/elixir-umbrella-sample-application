# Sample Application

## Requirements

1. Elixir 1.7.x
2. PostgreSQL 10.x

## Project structure

* `Core` (`apps/core`) - data layer

## Setup

1. Configure database credentials:

  ```bash
  cp apps/core/config/secret.exs.example apps/core/config/dev.secret.exs
  cp apps/core/config/secret.exs.example apps/core/config/test.secret.exs
  ```

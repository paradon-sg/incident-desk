# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Users

There is no self sign-up. Each user has exactly one role, `customer` or `agent`.

* **Development:** `bin/rails db:seed` creates `customer@example.com` and `agent@example.com`.
  Their password is a local-only placeholder (`password`), or the value of `SEED_PASSWORD` if set.
  Seeds create no users in production.
* **Any environment:** create a user with

  ```sh
  bin/rails users:create EMAIL=someone@example.com ROLE=agent
  ```

  The task prompts for the password without echoing it. For scripted use, pass it in the
  `PASSWORD` environment variable instead.

# Stack patterns

Starting points for the services a project needs. Adapt them to what the
architecture says — versions, extensions, extras — and never add a service the
project does not use.

Every pattern follows the same rules: ports on `127.0.0.1`, images pinned to a
version, secrets from `.env`, a healthcheck on the database, named volumes for
data, and a `name:` for the compose project.

## PHP and Laravel

Full set in [../templates/php-laravel/](../templates/php-laravel/):

| File | Goes to |
| --- | --- |
| `compose.yaml` | `compose.yaml` |
| `Dockerfile` | `docker/app/Dockerfile` |
| `dockerignore` | `.dockerignore` |
| `env.example` | keys appended to `.env.example` and `.env` |

- Application: `php:<version>-apache` with the document root on `public/`,
  the extensions the project uses (`pdo_mysql` or `pdo_pgsql`, `zip`, `intl`,
  `bcmath`…) and Composer copied from `composer:2`.
- Inside the container, `DB_HOST` is the service name (`db`), not `127.0.0.1`.
- Prepare: `composer install`, `php artisan key:generate` when `APP_KEY` is
  empty, `php artisan migrate --seed`.
- Tests: `php artisan test`.

## PostgreSQL instead of MySQL

```yaml
  db:
    image: postgres:17
    environment:
      POSTGRES_DB: ${DB_DATABASE}
      POSTGRES_USER: ${DB_USERNAME}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    ports:
      - "127.0.0.1:${DB_FORWARD_PORT:-54320}:5432"
    volumes:
      - db-data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U $${POSTGRES_USER} -d $${POSTGRES_DB}"]
      interval: 5s
      timeout: 5s
      retries: 20
```

## Node.js

```yaml
  app:
    image: node:22
    working_dir: /app
    command: sh -c "npm ci && npm run dev -- --host 0.0.0.0"
    ports:
      - "127.0.0.1:${APP_PORT:-3000}:3000"
    volumes:
      - .:/app
      - node-modules:/app/node_modules
    env_file: .env
```

`--host 0.0.0.0` is inside the container only; the port mapping still binds
to `127.0.0.1` on his machine. The `node-modules` volume keeps Linux-built
modules out of his Windows folder.

## Python

```yaml
  app:
    image: python:3.13
    working_dir: /app
    command: sh -c "pip install -r requirements.txt && python manage.py runserver 0.0.0.0:8000"
    ports:
      - "127.0.0.1:${APP_PORT:-8000}:8000"
    volumes:
      - .:/app
    env_file: .env
```

## Extras — only when the architecture names them

```yaml
  redis:
    image: redis:7.4
    ports:
      - "127.0.0.1:${REDIS_FORWARD_PORT:-63790}:6379"

  mailpit:
    image: axllent/mailpit:v1.21
    ports:
      - "127.0.0.1:${MAIL_UI_PORT:-8025}:8025"
```

A queue worker reuses the application image with the worker command as
`command:`; a scheduler, the same with the scheduler command.

## Windows notes

- Paths in `compose.yaml` use forward slashes.
- Shell scripts copied into images need LF line endings; the repository may
  check them out as CRLF. Prefer commands in `compose.yaml` or the
  `Dockerfile` over separate scripts.
- Bind-mounted folders are slower on Windows; that is expected locally and not
  a reason to change the layout.

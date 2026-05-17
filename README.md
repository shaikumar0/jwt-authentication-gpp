# Secure JWT Authentication API

## Overview
A secure, stateless authentication API built with Node.js, Express, and PostgreSQL. Features RSA-2048 signed JWTs, refresh tokens, Bcrypt password hashing, and Docker Compose containerization.

## Prerequisites
- Docker & Docker Compose
- Bash & OpenSSL (to generate RSA keys)
- curl & jq (for the test script)

## Setup and Running
1. **Generate RSA Keys**: Run `./generate-keys.sh`. This ensures `private.pem` and `public.pem` are securely generated and placed in the `keys/` directory.
2. **Start Services**: Run `docker-compose up -d --build` to build the app container and start the Postgres database.
3. **Database Initialization**: `init.sql` automatically provisions tables on startup. The app uses `depends_on` with `service_healthy` to wait for Postgres.

## Testing the API
Run the provided automated test flow on a bash environment:
```bash
./test-auth-flow.sh
```

## Environment Variables
Reference `.env.example` in the directory root. For standard docker-compose functionality, defaults are already provided.

## Architecture & Security
- RS256 algorithm used for JWTs, ensuring private keys strictly sign tokens, while microservices would only need public keys.
- Bcrypt (10 rounds) hashes passwords before db insertion.
- Login route is guarded by a 5 req/min rate limiter to thwart brute force.
- Refresh rotation ensures access token brevity (15 minutes).


just wanna check how rebase works

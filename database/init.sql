-- PostgreSQL reference schema. Use Laravel migrations for normal deployment.
-- Do not apply this SQL and then run the create-table migration on the same database.
CREATE TABLE users (
 id BIGSERIAL PRIMARY KEY, name VARCHAR(255) NOT NULL, email VARCHAR(255) UNIQUE NOT NULL,
 password VARCHAR(255) NOT NULL, role VARCHAR(255) NOT NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL
);
CREATE TABLE api_tokens (
 id BIGSERIAL PRIMARY KEY, user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
 token_hash VARCHAR(64) UNIQUE NOT NULL, expires_at TIMESTAMP NOT NULL
);
CREATE TABLE technicians (
 id UUID PRIMARY KEY, user_id BIGINT UNIQUE NOT NULL REFERENCES users(id),
 zone VARCHAR(255) NOT NULL, zones JSON NOT NULL, specialties JSON NOT NULL,
 fee DECIMAL(10,2) NOT NULL, rating DECIMAL(9,6) NOT NULL DEFAULT 0,
 reviews INTEGER NOT NULL DEFAULT 0, years INTEGER NOT NULL DEFAULT 0,
 verified BOOLEAN NOT NULL DEFAULT FALSE, available BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE TABLE requests (
 id UUID PRIMARY KEY, client_id BIGINT NOT NULL REFERENCES users(id),
 specialty VARCHAR(255) NOT NULL, zone VARCHAR(255) NOT NULL, address VARCHAR(255) NOT NULL,
 description TEXT NOT NULL, status VARCHAR(255) NOT NULL,
 technician_id UUID NULL REFERENCES technicians(id), agreed_fee DECIMAL(10,2) NULL,
 rating SMALLINT NULL, created_ms BIGINT NOT NULL, pending_until BIGINT NOT NULL,
 completed_at BIGINT NULL, rating_until BIGINT NULL, events JSON NOT NULL
);
CREATE INDEX requests_status_index ON requests(status);
CREATE TABLE offers (
 id BIGSERIAL PRIMARY KEY, request_id UUID NOT NULL REFERENCES requests(id) ON DELETE CASCADE,
 technician_id UUID NOT NULL REFERENCES technicians(id), status VARCHAR(255) NOT NULL,
 sent_at BIGINT NOT NULL, expires_at BIGINT NOT NULL, score DECIMAL(9,6) NOT NULL,
 UNIQUE(request_id,technician_id)
);
CREATE INDEX offers_expires_at_index ON offers(expires_at);

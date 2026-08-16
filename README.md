# EMS AlgaShop

E-commerce platform project built during the AlgaWorks Microservices Specialist Course (EMS).

- Level 2 - Domain-Driven Design
- Level 3 - Microservices Design and Engineering with REST
- Level 4 - Microservices Resilience and Scalability
- Level 5 - Security, Authentication and Authorization in Microservices

## Microservices

### authorization-server
Issues and manages OAuth2 / OpenID Connect tokens for the platform. Built with **Spring Authorization Server**, acting as the identity provider that every other service trusts as an OAuth2 resource server (and `ordering` additionally as an OAuth2 client). Handles user account management, email verification, password reset, RSA/JWKS-signed JWT access tokens, and role- and client-scoped authorization policies.

### ordering
Handles customer orders, shopping carts, and checkout flows. Built with a **purist DDD** approach, using Hexagonal Architecture (Ports & Adapters) to fully isolate the domain model from frameworks and persistence concerns. Integrates with `product-catalog` for product data and with RapiDex (mocked via WireMock) for shipping.

### billing
Handles invoice generation, credit card management, and payment processing. Built with a **pragmatic DDD** approach, allowing domain models to be closer to persistence entities to reduce implementation complexity. Integrates with the FastPay fake payment gateway.

### billing-scheduler
Short-lived scheduled microservice that performs background tasks for the billing service, such as canceling expired invoices via the FastPay API. Uses lightweight Spring JDBC instead of JPA.

### product-catalog
Manages products and categories. Built with **Contract-Driven Development (CDD)** using Spring Cloud Contract.

### template
Reference starter project used as a base template for creating new microservices in this project.

## Tech Stack

- **Language:** Java 25
- **Framework:** Spring Boot 4.0.x, Spring Cloud 2025.1.0, Spring Cloud AWS 4.0.0
- **Modules:** Spring Web MVC, Data JPA, Data MongoDB, Validation, Cache, REST Client, Security (OAuth2 Resource Server / Client), Actuator, Resilience (Circuit Breaker)
- **Security & Identity:** Spring Authorization Server (OAuth2 + OpenID Connect provider), RSA-signed self-contained JWT access tokens with JWKS, Spring Session JDBC
- **Caching:** Redis 8.4 (Cache-Aside and Write-Through patterns, CacheEvict invalidation)
- **Databases:** PostgreSQL 17, MongoDB 8 (replica set)
- **Migrations:** Flyway
- **Contracts & Docs:** Spring Cloud Contract 5.0.0, Spring REST Docs (AsciiDoc)
- **Testing:** JUnit 5, Mockito, AssertJ, REST Assured, Testcontainers, WireMock
- **Build:** Gradle
- **Utilities:** Lombok, ModelMapper, HypersistenceTSID, Grafana K6, Commons Validator
- **Infrastructure:** Docker, Docker Compose, AWS S3 / Secrets Manager / Parameter Store (mocked via LocalStack), Mailpit (SMTP testing)

## Running Locally

Start all infrastructure dependencies (PostgreSQL, MongoDB, Redis, WireMock, FastPay, LocalStack, Mailpit):

```bash
docker compose up -d
```

Each service runs with the `development` Spring profile. `authorization-server` is host-bound to `auth.algashop.local` — add the aliases from `etc/hostnames` to your hosts file for OAuth2 redirect flows to work locally. Default ports:

| Service               | Port                |
|-----------------------|---------------------|
| ordering               | 8080                |
| authorization-server   | 8081                |
| billing                | 8082                |
| product-catalog        | 8083                |
| WireMock               | 8787                |
| Localstack             | 4566                |
| FastPay                | 9995                |
| Mailpit (SMTP UI)      | 8025                |
| PostgreSQL             | 5432                |
| MongoDB                | 27017, 27018, 27019 |
| Redis                  | 6379                |
# EMS AlgaShop

E-commerce platform project built during the AlgaWorks Microservices Specialist Course (EMS).

- Level 2 - Domain-Driven Design
- Level 3 - Microservices Design and Engineering with REST
- Level 4 - Microservices Resilience and Scalability
- Level 5 - Security, Authentication and Authorization in Microservices
- Level 6 - API Gateway, BFF and Service Discovery

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
Manages products and categories, including stock control (restock/withdraw) and product image storage on AWS S3 (mocked via LocalStack). Uses MongoDB as its document store with Redis caching (Cache-Aside and Write-Through) and HTTP caching (ETags, Last-Modified, Cache-Control) on product endpoints.

### service-registry
Service discovery server for the platform. Built with **Netflix Eureka** (via Spring Cloud), letting every other microservice register itself and letting the gateways and clients resolve peer instances by name (`lb://`) instead of hardcoded hosts/ports.

### gateway-admin
API gateway for the `admin` back-office app. Built with **Spring Cloud Gateway** (WebFlux, reactive), routing to `ordering`, `product-catalog`, and `authorization-server` through Eureka-discovered instances. Handles OAuth2 resource-server JWT validation, Redis-backed rate limiting, circuit breaking/retries, and CORS for the admin SPA.

### gateway-ecommerce
API gateway for the `ecommerce` storefront app. Built with **Spring Cloud Gateway** (WebFlux, reactive), routing to `ordering`, `billing`, `product-catalog`, and `authorization-server` through Eureka-discovered instances, and doubling as a lightweight **BFF** that aggregates product highlights and categories for the storefront home page. Handles OAuth2 resource-server JWT validation, Redis-backed rate limiting/local response caching, and circuit breaking/retries.

### template
Reference starter project used as a base template for creating new microservices in this project.

## Apps

### admin
Back-office admin dashboard. Built as an **Angular** SPA, authenticating via OAuth2 Authorization Code + PKCE and consuming the platform through `gateway-admin`.

### ecommerce
Customer-facing storefront. Built as a **Spring Boot Web MVC + Thymeleaf** server-rendered app, authenticating via OAuth2 (Authorization Code for browser users, Client Credentials for machine-to-machine calls) and consuming the platform through `gateway-ecommerce`.

## Tech Stack

- **Language:** Java 25
- **Framework:** Spring Boot 4.0.x, Spring Cloud 2025.1.x, Spring Cloud AWS 4.0.0
- **Modules:** Spring Web MVC, Data JPA, Data MongoDB, Validation, Cache, REST Client, WebClient, Security (OAuth2 Resource Server / Client), Actuator, Resilience (Circuit Breaker)
- **Security & Identity:** Spring Authorization Server (OAuth2 + OpenID Connect provider), RSA-signed self-contained JWT access tokens with JWKS, Spring Session JDBC / Redis
- **API Gateway & Service Discovery:** Spring Cloud Gateway (WebFlux, reactive routing/filters), Spring Cloud Netflix Eureka (service registry and client-side/gateway load balancing via `lb://`), BFF aggregation with reactive `WebClient`
- **Caching:** Redis 8.4 (Cache-Aside and Write-Through patterns, CacheEvict invalidation, gateway rate limiting and local response cache)
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

Each service runs with the `development` Spring profile. `authorization-server` is host-bound to `auth.algashop.local`, `gateway-admin`/`admin` to `admin-api.algashop.local`/`admin.algashop.local`, and `gateway-ecommerce`/`ecommerce` to `api.algashop.local`/`algashop.local` — add the aliases from `etc/hostnames` to your hosts file for OAuth2 redirect flows to work locally. Default ports:

| Service               | Port                |
|-----------------------|---------------------|
| ordering               | 8080                |
| authorization-server   | 8081                |
| billing                | 8082                |
| product-catalog        | 8083                |
| service-registry       | 8761                |
| gateway-admin          | 9998                |
| gateway-ecommerce      | 9999                |
| client admin (Angular dev server) | 4200            |
| client ecommerce (Web MVC)    | 9080                |
| WireMock               | 8787                |
| Localstack             | 4566                |
| FastPay                | 9995                |
| Mailpit (SMTP UI)      | 8025                |
| PostgreSQL             | 5432                |
| MongoDB                | 27017, 27018, 27019 |
| Redis                  | 6379                |

`ordering`, `billing`, `product-catalog`, `gateway-admin`, and `gateway-ecommerce` register themselves with `service-registry` (Eureka) and must reach it at startup; the gateways additionally require Redis for rate limiting.
# EMS AlgaShop

E-commerce platform project built during the AlgaWorks Microservices Specialist Course (EMS).

- Level 2 - Domain-Driven Design
- Level 3 - Microservices Design and Engineering with REST
- Level 4 - Microservices Resilience and Scalability

## Microservices

### ordering
Handles customer orders, shopping carts, and checkout flows. Built with a **purist DDD** approach, using Hexagonal Architecture (Ports & Adapters) to fully isolate the domain model from frameworks and persistence concerns. Integrates with `product-catalog` for product data and with RapiDex (mocked via WireMock) for shipping.

### billing
Handles invoice generation, credit card management, and payment processing. Built with a **pragmatic DDD** approach, allowing domain models to be closer to persistence entities to reduce implementation complexity. Integrates with the FastPay payment gateway.

### billing-scheduler
Short-lived scheduled microservice that performs background tasks for the billing service, such as canceling expired invoices via the FastPay API. Uses lightweight Spring JDBC instead of JPA.

### product-catalog
Manages products and categories. Built with **Contract-Driven Development (CDD)** using Spring Cloud Contract, and API documentation generated via Spring REST Docs. Supports HTTP caching with ETags and Last-Modified headers.

### template
Reference starter project used as a base template for creating new microservices in this project.

## Tech Stack

- **Language:** Java 25
- **Framework:** Spring Boot 4.0.x, Spring Cloud 2025.1.0
- **Modules:** Spring Web MVC, Data JPA, Data MongoDB, Validation, Cache, REST Client, Security
- **Caching:** Redis 8.4 (Cache-Aside and Write-Through patterns, CacheEvict invalidation)
- **Databases:** PostgreSQL 17, MongoDB 8 (replica set)
- **Migrations:** Flyway
- **Contracts & Docs:** Spring Cloud Contract 5.0.0, Spring REST Docs (AsciiDoc)
- **Testing:** JUnit 5, Mockito, AssertJ, REST Assured, Testcontainers, WireMock
- **Build:** Gradle
- **Utilities:** Lombok, ModelMapper, HypersistenceTSID
- **Infrastructure:** Docker, Docker Compose

## Running Locally

Start all infrastructure dependencies (PostgreSQL, MongoDB, Redis, WireMock, FastPay):

```bash
docker compose up -d
```

Each service runs with the `development` Spring profile. Default ports:

| Service         | Port                |
|-----------------|---------------------|
| ordering        | 8080                |
| billing         | 8082                |
| product-catalog | 8083                |
| WireMock        | 8787                |
| FastPay         | 9995                |
| PostgreSQL      | 5432                |
| MongoDB         | 27017, 27018, 27019 |
| Redis           | 6379                |
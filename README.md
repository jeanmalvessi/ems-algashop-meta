# EMS AlgaShop
This is a project built during the AlgaWorks Microservices Specialist Course (EMS).

- Level 2 - Domain-Driven Design.
- Level 3 - Microservices Design and Engineering with REST.
- Level 4 - Microservices Resilience and Scalability.

It simulates an e-commerce application and has the following microservices as submodules:

# ordering
Microservice built using a purist approach of DDD, separating the domain model from frameworks and any technological influences, in addition to the distinction between domain entities and persistence entities.

# billing
Microservice built using a pragmatic approach of DDD, accepting a certain dependence on frameworks and bringing the domain model closer to technological aspects, such as persistence, in order to reduce complexity and facilitate implementation.

# billing-scheduler
Microservice built as a short-lived microservice to perform scheduled asynchronous tasks for the billing microservice.

# product-catalog
Microservice built using CDD (Contract-Driven Development) with Spring Cloud Contract.

# Tech stack:
- Java 25
- Spring
  - Boot
  - Web
  - Data JPA / MongoDB
  - Validation
  - Cloud Contract
  - REST Docs
- Databases
  - PostgreSQL
  - MongoDB
- Tools
  - Flyway
  - Docker
  - Testcontainers
  - WireMock
  - Gradle
  - Lombok
  - JUnit / Mockito / AssertJ / REST Assured

# EMS AlgaShop
This is a project built during the AlgaWorks Microservices Specialist Course (EMS).

- Level 2 - Domain-Driven Design.
- Level 3 - Microservices Design and Engineering with REST.

It simulates an e-commerce application and has the microservices as submodules:

# ordering
Microservice built using a purist approach of DDD, separating the domain model from frameworks and any technological influences, in addition to the distinction between domain entities and persistence entities.

# billing
Microservice built using a pragmatic approach of DDD, accepting a certain dependence on frameworks and bringing the domain model closer to technological aspects, such as persistence, in order to reduce complexity and facilitate implementation.

# product-catalog (in development)
Microservice built using CDD (Contract-Driven Development) with Spring Cloud Contract.

# The technologies used are:
- Java 21
- Spring (Boot, Web, Data JPA, Validation, Cloud Contract, REST Docs)
- PostgreSQL Database with Flyway
- Docker
- Gradle
- Lombok

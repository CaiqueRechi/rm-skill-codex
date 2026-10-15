# Coverage checklist

This is the definition of a complete requirements survey. Every item below
ends in a covered state — `respondido`, `não se aplica` or `adiado` — before the
survey counts as 100%. The probe questions are starting points, not a script:
ask them in his language, adapted to the request, one at a time.

An item is answered only when the answer is specific enough to build and test
from. "Precisa ser seguro" does not close a security item; "login com o AD da
empresa, só a equipe de vendas vê o relatório de margem" does.

## 1. Context and problem

| Item | Covered when you know |
| --- | --- |
| 1.1 Problem | what goes wrong today, for whom, and how it is handled now |
| 1.2 Objective | what changes once this exists, in one sentence he agrees with |
| 1.3 Motivation | why now — a deadline, a cost, a customer, a regulation |
| 1.4 Current solution | spreadsheet, legacy system, manual process — and what of it must survive |

Probes: "Hoje, como isso é feito?" · "O que acontece se isso não for feito?"

## 2. Stakeholders and users

| Item | Covered when you know |
| --- | --- |
| 2.1 Decision maker | who approves scope and accepts delivery |
| 2.2 Personas | each kind of user, what they need from it, how many of each |
| 2.3 Permissions | what each persona can see and do, and what it must never see |
| 2.4 Usage context | desktop, mobile, field, shop floor, offline — and when they use it |

## 3. Business model

| Item | Covered when you know |
| --- | --- |
| 3.1 Value | what the business gains — revenue, cost cut, compliance, time |
| 3.2 Who pays | internal cost centre, customer subscription, per transaction, per seat |
| 3.3 Pricing and plans | tiers, limits per plan, trial, billing cycle — or "internal, no billing" |
| 3.4 Scale of the business | number of customers, companies, branches, now and in two years |
| 3.5 Success metric | the number that shows it worked, and its target |

## 4. Business rules

| Item | Covered when you know |
| --- | --- |
| 4.1 Rule inventory | every rule that decides, calculates, blocks or approves something |
| 4.2 Each rule | a concrete example **and** what happens when it does not apply |
| 4.3 Calculations | formulas, rounding, currency, taxes, units |
| 4.4 States and lifecycle | the statuses an entity goes through and who moves it between them |
| 4.5 Approvals | which actions need approval, by whom, and what happens on refusal |
| 4.6 Legal and fiscal rules | NF-e, LGPD, sector regulation — or confirmed none |

Probes: "Me dá um exemplo real disso." · "E quando não é assim?" · "Quem pode
mudar essa regra, e com que frequência ela muda?"

## 5. Functional requirements and flows

| Item | Covered when you know |
| --- | --- |
| 5.1 Main flows | the end-to-end journeys, step by step, per persona |
| 5.2 Alternative and error paths | what happens when a step fails or is cancelled |
| 5.3 Screens and outputs | screens, reports, exports, notifications, documents generated |
| 5.4 Search and filters | what users look for and by which fields |
| 5.5 Imports and bulk actions | spreadsheets, batch jobs, mass updates |
| 5.6 Notifications | who is told what, through which channel, when |

## 6. Data and domain

| Item | Covered when you know |
| --- | --- |
| 6.1 Entities | the things the system stores and their key attributes |
| 6.2 Relationships | cardinality between entities (one order, many items) |
| 6.3 Source of truth | for each entity: created here, or owned by another system |
| 6.4 Volume and growth | records per day and total after five years for the large entities |
| 6.5 History and audit | what must be versioned or logged, who changed what and when |
| 6.6 Retention and deletion | how long data is kept, what is deleted or anonymised, LGPD basis |
| 6.7 Migration | existing data to bring in, its source, quality and volume |

## 7. Integrations

| Item | Covered when you know |
| --- | --- |
| 7.1 Systems | every external system involved (ERP, CRM, payment, e-mail, government) |
| 7.2 Direction and trigger | who sends to whom, real time or batch, on which event |
| 7.3 Contract | API, file, database view, webhook — and whether documentation exists |
| 7.4 Failure | what happens when the other side is down or slow, and who is warned |
| 7.5 Limits | rate limits, cost per call, credentials and who owns them |

## 8. Technologies

| Item | Covered when you know |
| --- | --- |
| 8.1 Mandatory stack | languages, frameworks and databases that must be used |
| 8.2 Forbidden or discouraged | anything ruled out, and why |
| 8.3 Existing environment | servers, cloud, licences and tools already paid for |
| 8.4 Hosting | on-premise, cloud provider, shared hosting, who operates it |
| 8.5 Clients | browsers, mobile platforms, minimum versions, printers or devices |

## 9. Architecture

| Item | Covered when you know |
| --- | --- |
| 9.1 Style | monolith, modular monolith, services — with the reason |
| 9.2 Components | front end, back end, workers, queues, scheduler, storage |
| 9.3 Multi-tenancy | one company or many, and how their data is separated |
| 9.4 Environments | dev, homologation, production — and who uses each |
| 9.5 Deploy | how a version reaches production, and how it is rolled back |
| 9.6 Where work runs | what runs in the browser and what stays on the server, and why |

## 10. Engineering

| Item | Covered when you know |
| --- | --- |
| 10.1 Team | who builds and maintains it, their size and stack experience |
| 10.2 Repository and process | where the code lives, branching, review — default to `$crow:conventions` |
| 10.3 Tests | levels expected (unit, feature, browser) and what must never break |
| 10.4 CI/CD | pipeline that exists or must be built |
| 10.5 Documentation | where technical and user documentation lives |

## 11. Non-functional requirements

Every item here needs a number or a concrete criterion.

| Item | Covered when you know |
| --- | --- |
| 11.1 Performance | response time for the main operations, at which load |
| 11.2 Concurrency | simultaneous users at peak |
| 11.3 Availability | hours of operation, acceptable downtime, maintenance window |
| 11.4 Scalability | growth expected and what must keep working at that size |
| 11.5 Security | authentication, authorisation model, bot protection, sensitive data |
| 11.6 Compliance | LGPD, fiscal, sector audits, certifications |
| 11.7 Accessibility and language | accessibility level, languages, time zones, currencies |

## 12. Bottlenecks and risks

| Item | Covered when you know |
| --- | --- |
| 12.1 Peaks | when load concentrates — month end, shift change, campaigns |
| 12.2 Heavy operations | reports, imports, calculations that touch many records |
| 12.3 Single points of failure | a person, server or integration whose loss stops everything |
| 12.4 Third-party dependencies | external services whose limits or prices can block it |
| 12.5 Known unknowns | what nobody knows yet, and how it will be found out |

Probes: "Qual dia do mês isso mais é usado?" · "Qual relatório hoje demora?" ·
"Se o ERP cair, o que para?"

## 13. Constraints

| Item | Covered when you know |
| --- | --- |
| 13.1 Deadline | fixed date or not, and what is tied to it |
| 13.2 Budget | for building and for running — infrastructure, licences, APIs |
| 13.3 Organisational | policies, approvals, vendors that must be involved |

## 14. Scope and phases

| Item | Covered when you know |
| --- | --- |
| 14.1 MVP | the smallest delivery that is useful on its own |
| 14.2 Later phases | what comes after, in which order |
| 14.3 Out of scope | what is explicitly not part of this request |

## 15. Operations

| Item | Covered when you know |
| --- | --- |
| 15.1 Monitoring | what is watched, and who is alerted when it breaks |
| 15.2 Backup and recovery | frequency, retention, how long a restore may take |
| 15.3 Support | who users call, in which hours |
| 15.4 Training and rollout | how users learn it, pilot group, cut-over from the old process |

## 16. Acceptance

| Item | Covered when you know |
| --- | --- |
| 16.1 Acceptance criteria | how each main flow is checked as done |
| 16.2 Test data and scenarios | real cases to validate with |
| 16.3 Sign-off | who signs off, and on what evidence |

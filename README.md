<div align="center">

# 🔥 LeadForge CRM

### Full-Stack Customer Relationship Management Platform

A portfolio-grade CRM for managing leads, companies, contacts, sales opportunities, follow-ups, activities, revenue forecasting, pipeline analytics, and audit trails.

![React](https://img.shields.io/badge/React-18-61DAFB?logo=react&logoColor=black)
![Node.js](https://img.shields.io/badge/Node.js-Express-339933?logo=nodedotjs&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-4169E1?logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)
![JWT](https://img.shields.io/badge/Auth-JWT-black?logo=jsonwebtokens)

</div>

---

## Overview

**LeadForge CRM** demonstrates practical full-stack engineering through a realistic sales and customer-relationship workflow. It combines lead capture, contact and company management, opportunity tracking, pipeline stages, activities, analytics, role-based access, and audit logging in one containerized system.

## Core Features

- Lead management with scores, estimated value, source, and follow-up dates
- Company/account management
- Contact management
- Sales opportunities and configurable pipeline stages
- Kanban-style opportunity pipeline
- Calls, meetings, emails, notes, and follow-up activities
- Dashboard KPIs and revenue forecasting
- Lead-source analytics
- User roles and JWT authentication
- Audit logs for important mutations
- CSV export workflows
- Database backup and restore scripts
- Offline-friendly service-worker shell

## Architecture

```text
React + Vite SPA
      │
      │ REST / JSON + JWT
      ▼
Node.js + Express API
      │
      ▼
PostgreSQL 16
```

## Tech Stack

| Layer | Technologies |
|---|---|
| Frontend | React, React Router, Vite |
| Backend | Node.js, Express.js |
| Database | PostgreSQL, pg |
| Authentication | JWT, bcryptjs |
| Deployment | Docker, Docker Compose, Render Blueprint |
| Operations | Backup / restore shell and PowerShell scripts |

## Quick Start

```bash
git clone https://github.com/oshadif/LeadForge-CRM.git
cd LeadForge-CRM
docker compose up --build
```

Open:

- Frontend: `http://localhost:5175`
- Backend API: `http://localhost:4002`
- Health check: `http://localhost:4002/api/health`

## Demo Accounts

### Admin
`admin@demo.com` / `admin123`

### Sales Representative
`sales@demo.com` / `sales123`

> Demo credentials are for local portfolio use only. Replace them before any real deployment.

## Security Notes

- Never commit real `.env` files or production secrets.
- Replace demo passwords and the JWT secret before deployment.
- Use HTTPS and managed database credentials in production.
- Add rate limiting and centralized logging for internet-facing deployments.

## Deployment

A `render.yaml` Blueprint is included for a simple Render deployment using one Node web service and one PostgreSQL database.

## Roadmap

- [ ] Automated unit and integration tests
- [ ] CI/CD workflow
- [ ] Email notifications and reminders
- [ ] Advanced sales forecasting
- [ ] Custom pipeline configuration UI
- [ ] Import/export enhancements
- [ ] Fine-grained permissions
- [ ] Production observability

## Author

**Oshadi Vidumini Fernando**  
Software Engineer · Full-Stack & Mobile Developer  
GitHub: [@oshadif](https://github.com/oshadif)

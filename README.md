# RunFree

> AI-powered running app with training plans and social features

## Overview

RunFree is a free running app that combines **true AI-generated training plans** with social features. Unlike template-based alternatives, every training plan is uniquely generated based on running science principles and adapts continuously to each runner.

## Tech Stack

| Layer | Technology |
|-------|------------|
| **Web** | React + TypeScript |
| **Mobile** | React Native + Expo |
| **API** | Ruby on Rails |
| **AI Service** | Python + FastAPI + Claude API |
| **Realtime** | Node.js + Socket.io |
| **Database** | PostgreSQL + PostGIS |
| **Cache** | Redis |

## Project Structure

```
runfree/
├── apps/
│   ├── api/              # Rails API + Admin
│   ├── ai-service/       # Python AI microservice
│   ├── web/              # React web app
│   ├── mobile/           # React Native app (Phase 2)
│   └── realtime/         # Node.js WebSocket server (Phase 2)
├── packages/
│   ├── types/            # Shared TypeScript types
│   ├── api-client/       # API client
│   └── ui/               # Shared UI components
├── docker-compose.yml    # Local dev environment
└── Makefile              # Unified commands
```

## Getting Started

### Prerequisites

- Node.js 20+
- pnpm 9+
- Ruby 3.3+
- Python 3.11+
- Docker & Docker Compose

### Setup

```bash
# Clone the repo
git clone git@github.com:lmagsino/runfree.git
cd runfree

# Start database services
docker-compose up -d

# Install dependencies
make install

# Setup database
make db-setup

# Start development
make dev
```

### Commands

```bash
make help          # Show all commands
make dev           # Start all services
make test          # Run all tests
make lint          # Lint all code
```

## Architecture

<!-- Architecture diagrams will be added here -->

### System Architecture

```mermaid
flowchart TB
    subgraph Clients
        WEB[React Web<br/>:5173]
        MOBILE[React Native<br/>iOS/Android]
    end

    subgraph Backend
        API[Rails API<br/>:3000]
        AI[Python AI Service<br/>:8000]
        RT[Node.js Realtime<br/>:3001]
    end

    subgraph Data
        PG[(PostgreSQL<br/>+ PostGIS)]
        REDIS[(Redis)]
        S3[(S3 Storage)]
    end

    subgraph External
        CLAUDE[Claude API]
        GARMIN[Garmin Connect]
        STRAVA[Strava API]
    end

    WEB --> API
    MOBILE --> API
    WEB <--> RT
    MOBILE <--> RT

    API --> PG
    API --> REDIS
    API --> S3
    API --> AI

    AI --> CLAUDE

    RT --> REDIS

    API --> GARMIN
    API --> STRAVA
```

### Data Flow

```mermaid
sequenceDiagram
    participant U as User
    participant W as Web/Mobile
    participant API as Rails API
    participant AI as AI Service
    participant C as Claude API
    participant DB as PostgreSQL
    participant R as Redis

    Note over U,R: Plan Generation Flow
    U->>W: Complete onboarding
    W->>API: POST /api/v1/training_plans
    API->>DB: Save user profile
    API->>AI: Generate plan request
    AI->>C: Send prompt
    C-->>AI: Return plan JSON
    AI-->>API: Parsed plan
    API->>DB: Save training plan + workouts
    API-->>W: Plan created
    W-->>U: Show calendar

    Note over U,R: Workout Logging Flow
    U->>W: Complete workout
    W->>API: POST /api/v1/workouts/:id/complete
    API->>DB: Update workout
    API->>R: Publish activity event
    API-->>W: Workout saved
```

### Database Schema

```mermaid
erDiagram
    User ||--o| Profile : has
    User ||--o| Goal : has
    User ||--o| Availability : has
    User ||--o{ TrainingPlan : creates
    User ||--o{ Workout : logs
    User ||--o{ Activity : posts
    User }o--o{ User : follows

    TrainingPlan ||--o{ Workout : contains

    Workout ||--o| WorkoutRoute : has
    Workout ||--o{ Kudos : receives
    Workout ||--o{ Comment : receives

    Activity ||--o{ Kudos : receives
    Activity ||--o{ Comment : receives

    Club ||--o{ ClubMembership : has
    User ||--o{ ClubMembership : joins

    User {
        uuid id PK
        string email
        string encrypted_password
        timestamp created_at
    }

    Profile {
        uuid id PK
        uuid user_id FK
        string name
        string experience_level
        integer weekly_mileage
        jsonb race_times
        jsonb injury_history
    }

    TrainingPlan {
        uuid id PK
        uuid user_id FK
        string goal_type
        string goal_race
        date start_date
        date end_date
        string status
        jsonb ai_params
    }

    Workout {
        uuid id PK
        uuid user_id FK
        uuid training_plan_id FK
        string workout_type
        date scheduled_date
        string status
        jsonb planned
        jsonb completed
        jsonb feedback
    }
```

### API Flow

```mermaid
flowchart LR
    subgraph Auth
        A1[POST /auth/signup]
        A2[POST /auth/login]
        A3[DELETE /auth/logout]
    end

    subgraph Onboarding
        O1[POST /profile]
        O2[POST /goals]
        O3[POST /availability]
    end

    subgraph Training
        T1[POST /training_plans]
        T2[GET /training_plans/:id]
        T3[GET /workouts]
        T4[PATCH /workouts/:id]
        T5[POST /workouts/:id/complete]
    end

    subgraph AI
        AI1[POST /ai/generate_plan]
        AI2[POST /ai/adjust_plan]
        AI3[POST /ai/chat]
    end

    subgraph Social
        S1[GET /feed]
        S2[POST /kudos]
        S3[POST /comments]
        S4[POST /follow]
    end

    A1 --> O1
    O1 --> O2
    O2 --> O3
    O3 --> T1
    T1 --> AI1
    AI1 --> T2
    T2 --> T3
    T4 --> T5
    T5 --> S1
```

## Development

### Monorepo Structure

- **Turborepo** manages JS/TS apps (web, mobile, realtime, packages)
- **Rails** and **Python** apps are in the repo but managed separately
- **Docker Compose** unifies local development
- **Makefile** provides common commands across all languages

### Apps

| App | Port | Description |
|-----|------|-------------|
| `api` | 3000 | Rails API + Admin dashboard |
| `ai-service` | 8000 | Python AI microservice |
| `web` | 5173 | React web application |
| `realtime` | 3001 | Node.js WebSocket server |

## License

MIT

# 📊 Data Pipeline Health Monitor

A Grafana dashboard for monitoring a failing data pipeline — built as part of a Data Engineering consulting project. Includes fake historical data to simulate Monday pipeline failures, Kanban board tracking, alert history, and data volume analysis.

---

## 📁 Project Structure

```
├── docker-compose.yml        # Spins up PostgreSQL and Grafana containers
├── init.sql                  # Creates tables and inserts all fake data automatically
├── pipeline_dashboard.json   # Grafana dashboard — import this after setup
└── README.md
```

---

## 🧰 Prerequisites

Make sure you have the following installed:

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)

---

## 🚀 Getting Started

### Step 1 — Clone the repo

```bash
git clone https://github.com/lorenamekaj/Data-Pipeline-in-Trouble.git
cd pipeline-stabilization-project
```

### Step 2 — Start the containers

```bash
docker-compose up -d
```

This will start two containers:
- `pipeline_postgres` — PostgreSQL database on port `5432`
- `pipeline_grafana` — Grafana on port `3000`

The `init.sql` file runs automatically on first startup and creates all tables and inserts the fake data.

### Step 3 — Verify the database loaded correctly

```bash
docker exec -it pipeline_postgres psql -U admin -d pipeline_monitor -c "SELECT COUNT(*) FROM pipeline_runs;"
```

You should see `40` rows. If not, see the [Troubleshooting](#troubleshooting) section below.

### Step 4 — Open Grafana

Go to [http://localhost:3000](http://localhost:3000) in your browser.

```
Username: admin
Password: admin123
```

### Step 5 — Add PostgreSQL as a data source

1. Go to **Connections** → **Data Sources** → **Add data source**
2. Select **PostgreSQL**
3. Fill in the following:

| Field    | Value            |
|----------|------------------|
| Host     | `postgres:5432`  |
| Database | `pipeline_monitor` |
| User     | `admin`          |
| Password | `admin123`       |
| SSL Mode | `disable`        |

4. Click **Save & Test** — you should see a green confirmation message

### Step 6 — Get your datasource UID

```bash
curl -s http://admin:admin123@localhost:3000/api/datasources | python3 -m json.tool | grep -E '"uid"|"name"'
```

Copy the `uid` value next to your PostgreSQL datasource.

### Step 7 — Update the dashboard JSON

Open `pipeline_dashboard.json` and do a find and replace:

- Find: `YOUR_DATASOURCE_UID`
- Replace: your actual UID from Step 6

### Step 8 — Import the dashboard

1. In Grafana go to **Dashboards** → **Import**
2. Click **Upload JSON file**
3. Select `pipeline_dashboard.json`
4. Click **Import**

Your dashboard should now be fully populated with data.

---

## 📊 Dashboard Panels

The dashboard contains 13 panels across 6 rows:

| Panel | Type | Description |
|-------|------|-------------|
| Last Pipeline Run Status | Stat | Shows whether the most recent run succeeded or failed |
| Open Alerts | Stat | Count of unresolved alerts |
| Story Points Remaining | Stat | Sprint 1 points left to complete |
| Monday Failure Rate | Stat | Failure rate per day of the week |
| Pipeline Run Status Over Time | Time Series | Daily success/failure over 8 weeks |
| Failure Rate by Day of Week | Bar Chart | Highlights Monday as the problem day |
| Pipeline Execution Time | Time Series | Shows execution spikes on Mondays |
| Overall Success vs Failure | Pie Chart | Total breakdown across all runs |
| Data Volume Received vs Processed | Time Series | Shows weekend data accumulation |
| Average Data Volume by Day | Bar Chart | Monday volume vs weekday average |
| Kanban Tickets Per Column | Bar Chart | Current sprint board state |
| Sprint 1 Ticket Tracker | Table | All 5 sprint tickets with status and assignee |
| Alert History | Table | Full alert log with severity and resolution status |

---

## 🗄️ Database Tables

| Table | Description |
|-------|-------------|
| `pipeline_runs` | 40 rows of daily pipeline run history — Mondays always fail |
| `kanban_tickets` | Sprint 1 tickets with current Kanban column state |
| `pipeline_alerts` | Alert history with severity levels and resolution status |
| `data_volume` | Daily data volume showing Monday accumulation spike |

---

## 🔧 Troubleshooting

**No data in the database**

The `init.sql` only runs on first container startup. If you ran the containers before the file was in place, reset with:

```bash
docker-compose down -v
docker-compose up -d
```

The `-v` flag deletes the volume so PostgreSQL reinitialises and picks up the SQL file.

**Dashboard panels show No Data**

Your datasource UID in the JSON doesn't match Grafana. Follow Steps 6 and 7 above to fix it.

**Cannot connect to Grafana**

Make sure the containers are running:

```bash
docker ps
```

You should see both `pipeline_postgres` and `pipeline_grafana` listed as `Up`.

---

## 🛑 Stopping the containers

```bash
docker-compose down
```

To stop and delete all data:

```bash
docker-compose down -v
```

---

## 📌 Context

This project was built as part of a Data Engineering consulting exercise — Project 3: "Data Pipeline in Trouble". The scenario involves a client whose pipeline keeps failing every Monday due to undocumented dependencies, no monitoring, and unclear team ownership. The dashboard simulates what a monitoring setup would look like after the team stabilises the pipeline.

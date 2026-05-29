-- ================================================
-- Pipeline Monitor Database
-- Fake data for Grafana Dashboard Demo
-- ================================================

-- Table 1: Pipeline Run History
CREATE TABLE IF NOT EXISTS pipeline_runs (
    id SERIAL PRIMARY KEY,
    run_date DATE NOT NULL,
    run_day VARCHAR(10) NOT NULL,
    status VARCHAR(10) NOT NULL,       -- 'success' or 'failure'
    execution_time_seconds INT NOT NULL,
    rows_processed INT NOT NULL,
    error_message TEXT
);

-- Table 2: Kanban Board State
CREATE TABLE IF NOT EXISTS kanban_tickets (
    id SERIAL PRIMARY KEY,
    ticket_id VARCHAR(10) NOT NULL,
    title VARCHAR(100) NOT NULL,
    column_name VARCHAR(30) NOT NULL,
    assigned_to VARCHAR(30),
    created_date DATE NOT NULL,
    updated_date DATE NOT NULL,
    story_points INT NOT NULL
);

-- Table 3: Alert History
CREATE TABLE IF NOT EXISTS pipeline_alerts (
    id SERIAL PRIMARY KEY,
    alert_date TIMESTAMP NOT NULL,
    alert_type VARCHAR(50) NOT NULL,
    severity VARCHAR(10) NOT NULL,     -- 'critical', 'warning', 'info'
    message TEXT NOT NULL,
    resolved BOOLEAN DEFAULT FALSE
);

-- Table 4: Daily Data Volume
CREATE TABLE IF NOT EXISTS data_volume (
    id SERIAL PRIMARY KEY,
    run_date DATE NOT NULL,
    run_day VARCHAR(10) NOT NULL,
    rows_received INT NOT NULL,
    rows_processed INT NOT NULL,
    rows_failed INT NOT NULL
);

-- ================================================
-- PIPELINE RUN HISTORY (last 8 weeks)
-- Mondays fail much more often
-- ================================================
INSERT INTO pipeline_runs (run_date, run_day, status, execution_time_seconds, rows_processed, error_message) VALUES
-- Week 1
('2026-03-30', 'Monday',    'failure', 847,  0,      'Timeout: execution exceeded 800s threshold'),
('2026-03-31', 'Tuesday',   'success', 312,  145000, NULL),
('2026-04-01', 'Wednesday', 'success', 298,  138000, NULL),
('2026-04-02', 'Thursday',  'success', 321,  152000, NULL),
('2026-04-03', 'Friday',    'success', 305,  141000, NULL),
-- Week 2
('2026-04-06', 'Monday',    'failure', 901,  0,      'Memory limit exceeded: 4.2GB used'),
('2026-04-07', 'Tuesday',   'success', 287,  139000, NULL),
('2026-04-08', 'Wednesday', 'success', 310,  147000, NULL),
('2026-04-09', 'Thursday',  'success', 295,  143000, NULL),
('2026-04-10', 'Friday',    'success', 318,  150000, NULL),
-- Week 3
('2026-04-13', 'Monday',    'failure', 867,  0,      'Undocumented dependency: external API returned 503'),
('2026-04-14', 'Tuesday',   'success', 301,  144000, NULL),
('2026-04-15', 'Wednesday', 'success', 289,  136000, NULL),
('2026-04-16', 'Thursday',  'failure', 450,  71000,  'Partial failure: transformation step failed'),
('2026-04-17', 'Friday',    'success', 322,  148000, NULL),
-- Week 4
('2026-04-20', 'Monday',    'failure', 923,  0,      'Timeout: weekend data volume too large'),
('2026-04-21', 'Tuesday',   'success', 308,  146000, NULL),
('2026-04-22', 'Wednesday', 'success', 295,  140000, NULL),
('2026-04-23', 'Thursday',  'success', 311,  149000, NULL),
('2026-04-24', 'Friday',    'success', 299,  143000, NULL),
-- Week 5
('2026-04-27', 'Monday',    'failure', 812,  0,      'Memory limit exceeded: 3.9GB used'),
('2026-04-28', 'Tuesday',   'success', 314,  147000, NULL),
('2026-04-29', 'Wednesday', 'success', 302,  141000, NULL),
('2026-04-30', 'Thursday',  'success', 288,  138000, NULL),
('2026-05-01', 'Friday',    'success', 325,  152000, NULL),
-- Week 6
('2026-05-04', 'Monday',    'failure', 956,  0,      'Timeout: execution exceeded 800s threshold'),
('2026-05-05', 'Tuesday',   'success', 291,  140000, NULL),
('2026-05-06', 'Wednesday', 'success', 307,  145000, NULL),
('2026-05-07', 'Thursday',  'success', 318,  150000, NULL),
('2026-05-08', 'Friday',    'success', 296,  142000, NULL),
-- Week 7
('2026-05-11', 'Monday',    'failure', 889,  0,      'Undocumented dependency: schema change in source DB'),
('2026-05-12', 'Tuesday',   'success', 303,  143000, NULL),
('2026-05-13', 'Wednesday', 'success', 294,  139000, NULL),
('2026-05-14', 'Thursday',  'success', 309,  147000, NULL),
('2026-05-15', 'Friday',    'success', 287,  141000, NULL),
-- Week 8
('2026-05-18', 'Monday',    'failure', 934,  0,      'Memory limit exceeded: 4.1GB used'),
('2026-05-19', 'Tuesday',   'success', 316,  148000, NULL),
('2026-05-20', 'Wednesday', 'success', 299,  142000, NULL),
('2026-05-21', 'Thursday',  'success', 305,  145000, NULL),
('2026-05-22', 'Friday',    'success', 293,  140000, NULL);

-- ================================================
-- KANBAN TICKETS (current sprint state)
-- ================================================
INSERT INTO kanban_tickets (ticket_id, title, column_name, assigned_to, created_date, updated_date, story_points) VALUES
('T1', 'Map Pipeline End-to-End',               'In Progress',     'Lorena',  '2026-05-25', '2026-05-28', 5),
('T2', 'Identify Monday Failure Point',         'In Progress',     'Erza',    '2026-05-25', '2026-05-28', 3),
('T3', 'Set Up Basic Monitoring & Alerts',      'To Do',           NULL,      '2026-05-25', '2026-05-25', 5),
('T4', 'Standardize Weekend Deployment Changes','To Do',           NULL,      '2026-05-25', '2026-05-25', 3),
('T5', 'Implement Pipeline Recovery Procedures','To Do',           NULL,      '2026-05-25', '2026-05-25', 4),
('T6', 'Review existing pipeline logs',         'Done',            'Lorena',  '2026-05-25', '2026-05-27', 2),
('T7', 'Assign pipeline owner',                 'Ready for Review','Erza',    '2026-05-25', '2026-05-28', 1),
('T8', 'Document external dependencies list',   'On Hold',         'Lorena',  '2026-05-25', '2026-05-27', 2);

-- ================================================
-- ALERT HISTORY
-- ================================================
INSERT INTO pipeline_alerts (alert_date, alert_type, severity, message, resolved) VALUES
('2026-03-30 06:15:00', 'Pipeline Timeout',       'critical', 'Monday pipeline exceeded 800s execution threshold', TRUE),
('2026-04-06 06:22:00', 'Memory Exceeded',        'critical', 'Pipeline process used 4.2GB, limit is 4GB',         TRUE),
('2026-04-13 06:18:00', 'External API Failure',   'critical', 'Upstream API returned 503 - pipeline aborted',      TRUE),
('2026-04-16 09:45:00', 'Partial Failure',        'warning',  'Transformation step failed, partial data loaded',   TRUE),
('2026-04-20 06:31:00', 'Pipeline Timeout',       'critical', 'Monday pipeline exceeded 800s execution threshold', TRUE),
('2026-04-27 06:19:00', 'Memory Exceeded',        'critical', 'Pipeline process used 3.9GB, approaching limit',    TRUE),
('2026-05-04 06:27:00', 'Pipeline Timeout',       'critical', 'Monday pipeline exceeded 800s execution threshold', TRUE),
('2026-05-11 06:21:00', 'Schema Change Detected', 'critical', 'Source DB schema changed over weekend - aborted',   TRUE),
('2026-05-18 06:24:00', 'Memory Exceeded',        'critical', 'Pipeline process used 4.1GB, limit is 4GB',         TRUE),
('2026-05-28 14:00:00', 'No Monitoring Configured','warning', 'Pipeline has no alerting owner assigned',           FALSE);

-- ================================================
-- DAILY DATA VOLUME (weekends accumulate more)
-- ================================================
INSERT INTO data_volume (run_date, run_day, rows_received, rows_processed, rows_failed) VALUES
('2026-05-19', 'Monday',    520000, 0,      520000),
('2026-05-20', 'Tuesday',   148000, 148000, 0),
('2026-05-21', 'Wednesday', 141000, 141000, 0),
('2026-05-22', 'Thursday',  145000, 145000, 0),
('2026-05-23', 'Friday',    152000, 152000, 0),
('2026-05-26', 'Monday',    498000, 0,      498000),
('2026-05-27', 'Tuesday',   143000, 143000, 0),
('2026-05-28', 'Wednesday', 139000, 139000, 0);

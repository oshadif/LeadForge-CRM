CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS teams (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(120) UNIQUE NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  team_id UUID REFERENCES teams(id) ON DELETE SET NULL,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(180) UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role VARCHAR(30) NOT NULL DEFAULT 'sales',
  active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS companies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID REFERENCES users(id) ON DELETE SET NULL,
  name VARCHAR(180) NOT NULL,
  industry VARCHAR(120),
  website VARCHAR(200),
  phone VARCHAR(50),
  email VARCHAR(180),
  address TEXT,
  city VARCHAR(100),
  country VARCHAR(100),
  employee_count INTEGER,
  annual_revenue NUMERIC(16,2),
  status VARCHAR(30) NOT NULL DEFAULT 'prospect',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS contacts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID REFERENCES companies(id) ON DELETE SET NULL,
  owner_id UUID REFERENCES users(id) ON DELETE SET NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100),
  job_title VARCHAR(120),
  email VARCHAR(180),
  phone VARCHAR(50),
  mobile VARCHAR(50),
  source VARCHAR(80),
  status VARCHAR(30) NOT NULL DEFAULT 'active',
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS leads (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID REFERENCES users(id) ON DELETE SET NULL,
  company_name VARCHAR(180),
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100),
  email VARCHAR(180),
  phone VARCHAR(50),
  source VARCHAR(80),
  status VARCHAR(40) NOT NULL DEFAULT 'new',
  score INTEGER NOT NULL DEFAULT 0,
  estimated_value NUMERIC(14,2) NOT NULL DEFAULT 0,
  next_follow_up TIMESTAMPTZ,
  notes TEXT,
  converted BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS pipeline_stages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) UNIQUE NOT NULL,
  position INTEGER NOT NULL,
  probability INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS opportunities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID REFERENCES companies(id) ON DELETE SET NULL,
  contact_id UUID REFERENCES contacts(id) ON DELETE SET NULL,
  owner_id UUID REFERENCES users(id) ON DELETE SET NULL,
  stage_id UUID NOT NULL REFERENCES pipeline_stages(id),
  name VARCHAR(180) NOT NULL,
  amount NUMERIC(14,2) NOT NULL DEFAULT 0,
  expected_close_date DATE,
  source VARCHAR(80),
  status VARCHAR(30) NOT NULL DEFAULT 'open',
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  closed_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS activities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  lead_id UUID REFERENCES leads(id) ON DELETE CASCADE,
  contact_id UUID REFERENCES contacts(id) ON DELETE CASCADE,
  company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
  opportunity_id UUID REFERENCES opportunities(id) ON DELETE CASCADE,
  activity_type VARCHAR(40) NOT NULL,
  subject VARCHAR(180) NOT NULL,
  description TEXT,
  due_at TIMESTAMPTZ,
  completed BOOLEAN NOT NULL DEFAULT FALSE,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS notes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  lead_id UUID REFERENCES leads(id) ON DELETE CASCADE,
  contact_id UUID REFERENCES contacts(id) ON DELETE CASCADE,
  company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
  opportunity_id UUID REFERENCES opportunities(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  action VARCHAR(80) NOT NULL,
  entity_type VARCHAR(80),
  entity_id UUID,
  method VARCHAR(10),
  path TEXT,
  ip_address VARCHAR(80),
  after_data JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO teams(name) VALUES ('Sales Team'),('Management') ON CONFLICT(name) DO NOTHING;

INSERT INTO users(team_id,name,email,password_hash,role)
SELECT id,'Demo Admin','admin@demo.com',crypt('admin123',gen_salt('bf')),'admin'
FROM teams WHERE name='Management'
ON CONFLICT(email) DO NOTHING;

INSERT INTO users(team_id,name,email,password_hash,role)
SELECT id,'Demo Sales Rep','sales@demo.com',crypt('sales123',gen_salt('bf')),'sales'
FROM teams WHERE name='Sales Team'
ON CONFLICT(email) DO NOTHING;

INSERT INTO pipeline_stages(name,position,probability) VALUES
('Qualification',1,10),
('Discovery',2,25),
('Proposal',3,50),
('Negotiation',4,75),
('Won',5,100),
('Lost',6,0)
ON CONFLICT(name) DO NOTHING;

INSERT INTO companies(owner_id,name,industry,website,phone,email,address,city,country,employee_count,annual_revenue,status)
SELECT id,'Oceanview Hotels','Hospitality','https://oceanview.example','+1-555-1001','info@oceanview.example','12 Palm Road','Miami','USA',120,2500000,'customer'
FROM users WHERE email='sales@demo.com';

INSERT INTO companies(owner_id,name,industry,website,phone,email,address,city,country,employee_count,annual_revenue,status)
SELECT id,'Northstar Retail','Retail','https://northstar.example','+1-555-1002','contact@northstar.example','88 Market Street','Austin','USA',75,1800000,'prospect'
FROM users WHERE email='sales@demo.com';

INSERT INTO contacts(company_id,owner_id,first_name,last_name,job_title,email,phone,source,status,notes)
SELECT c.id,u.id,'Emma','Carter','Operations Manager','emma@oceanview.example','+1-555-2101','Referral','active','Interested in hotel management software.'
FROM companies c,users u WHERE c.name='Oceanview Hotels' AND u.email='sales@demo.com';

INSERT INTO contacts(company_id,owner_id,first_name,last_name,job_title,email,phone,source,status,notes)
SELECT c.id,u.id,'Liam','Brooks','IT Manager','liam@northstar.example','+1-555-2102','Website','active','Evaluating inventory and POS integration.'
FROM companies c,users u WHERE c.name='Northstar Retail' AND u.email='sales@demo.com';

INSERT INTO leads(owner_id,company_name,first_name,last_name,email,phone,source,status,score,estimated_value,next_follow_up,notes)
SELECT id,'Greenline Logistics','Sophia','Reed','sophia@greenline.example','+1-555-3101','LinkedIn','qualified',78,35000,NOW()+INTERVAL '2 days','Needs a logistics management platform.'
FROM users WHERE email='sales@demo.com';

INSERT INTO leads(owner_id,company_name,first_name,last_name,email,phone,source,status,score,estimated_value,next_follow_up,notes)
SELECT id,'BrightPath Education','Noah','Morgan','noah@brightpath.example','+1-555-3102','Website','new',55,22000,NOW()+INTERVAL '1 day','Interested in a school ERP.'
FROM users WHERE email='sales@demo.com';

INSERT INTO opportunities(company_id,contact_id,owner_id,stage_id,name,amount,expected_close_date,source,status,description)
SELECT c.id,ct.id,u.id,s.id,'Oceanview Hotel Platform',48000,CURRENT_DATE+30,'Referral','open','Custom hotel management and booking platform.'
FROM companies c JOIN contacts ct ON ct.company_id=c.id, users u, pipeline_stages s
WHERE c.name='Oceanview Hotels' AND u.email='sales@demo.com' AND s.name='Proposal';

INSERT INTO opportunities(company_id,contact_id,owner_id,stage_id,name,amount,expected_close_date,source,status,description)
SELECT c.id,ct.id,u.id,s.id,'Northstar Inventory Rollout',32000,CURRENT_DATE+45,'Website','open','Inventory and POS deployment across branches.'
FROM companies c JOIN contacts ct ON ct.company_id=c.id, users u, pipeline_stages s
WHERE c.name='Northstar Retail' AND u.email='sales@demo.com' AND s.name='Discovery';

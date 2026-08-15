import{Router}from"express";import{pool}from"../db.js";import{requireAuth}from"../middleware/auth.js";const r=Router();
r.get("/",requireAuth,async(req,res)=>{const [k,p,s,a]=await Promise.all([
pool.query(`SELECT (SELECT COUNT(*) FROM leads WHERE converted=false) open_leads,(SELECT COUNT(*) FROM opportunities WHERE status='open') open_opportunities,(SELECT COALESCE(SUM(amount),0) FROM opportunities WHERE status='open') pipeline_value,(SELECT COALESCE(SUM(amount),0) FROM opportunities WHERE status='won') won_revenue`),
pool.query(`SELECT s.id,s.name,s.position,s.probability,COUNT(o.id) deal_count,COALESCE(SUM(o.amount),0) value FROM pipeline_stages s LEFT JOIN opportunities o ON o.stage_id=s.id GROUP BY s.id ORDER BY s.position`),
pool.query(`SELECT COALESCE(source,'Unknown') source,COUNT(*) count FROM leads GROUP BY source ORDER BY count DESC`),
pool.query(`SELECT * FROM activities WHERE completed=false AND due_at IS NOT NULL ORDER BY due_at LIMIT 8`)
]);res.json({summary:k.rows[0],pipeline:p.rows,leadSources:s.rows,upcoming:a.rows})});export default r;
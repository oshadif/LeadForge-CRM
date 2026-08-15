import jwt from"jsonwebtoken";
export function requireAuth(req,res,next){const h=req.headers.authorization||"";const t=h.startsWith("Bearer ")?h.slice(7):null;if(!t)return res.status(401).json({message:"Authentication required."});try{req.user=jwt.verify(t,process.env.JWT_SECRET);next()}catch{return res.status(401).json({message:"Invalid or expired token."})}}
export function requireAdmin(req,res,next){if(req.user?.role!=="admin")return res.status(403).json({message:"Admin access required."});next()}

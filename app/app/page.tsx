import { createClient } from "@/lib/supabase/server";
import { Package,AlertTriangle,ArrowUpRight,WalletCards,ShoppingCart,Users,Boxes } from "lucide-react";
export default async function Dashboard(){
 const supabase=await createClient();
 const [{count:products},{count:customers},{count:orders}]=await Promise.all([
  supabase.from("products").select("*",{count:"exact",head:true}),
  supabase.from("customers").select("*",{count:"exact",head:true}),
  supabase.from("sales_orders").select("*",{count:"exact",head:true})
 ]);
 return <div className="page"><header className="page-header"><div><span className="eyebrow">ОГЛЯД</span><h1>Ваш бізнес під контролем</h1><p>Ключові показники та сигнали в одному місці.</p></div><button className="primary-button">+ Нова операція</button></header>
 <section className="metric-grid"><Metric icon={WalletCards} label="Виручка" value="—" hint="З'явиться після першої операції"/><Metric icon={ShoppingCart} label="Замовлення" value={orders??0} hint="У системі"/><Metric icon={Package} label="Товари" value={products??0} hint="У каталозі"/><Metric icon={Users} label="Клієнти" value={customers??0} hint="У базі"/></section>
 <section className="dashboard-grid"><div className="panel"><div className="panel-head"><div><h2>Швидкий старт</h2><p>Почніть з основних даних компанії.</p></div></div><div className="quick-grid">
 <Quick href="/app/products" icon={Package} title="Додати товар" text="Створити каталог"/><Quick href="/app/customers" icon={Users} title="Додати клієнта" text="Створити базу"/><Quick href="/app/sales" icon={ShoppingCart} title="Створити продаж" text="Перше замовлення"/><Quick href="/app/inventory" icon={Boxes} title="Перевірити склад" text="Залишки та рух"/>
 </div></div><div className="panel alert-panel"><div className="panel-head"><div><h2>Сигнали</h2><p>Те, що потребує уваги.</p></div><AlertTriangle size={20}/></div><div className="empty-state">Автоматичні попередження з'являться після появи операцій.</div></div></section></div>;
}
function Metric({icon:Icon,label,value,hint}:{icon:typeof WalletCards;label:string;value:string|number;hint:string}){return <div className="metric-card"><Icon size={19}/><span>{label}</span><strong>{value}</strong><small>{hint}</small></div>}
function Quick({href,icon:Icon,title,text}:{href:string;icon:typeof Package;title:string;text:string}){return <Link href={href} className="quick-card"><span className="quick-icon"><Icon size={18}/></span><span><b>{title}</b><small>{text}</small></span><ArrowUpRight size={16}/></Link>}

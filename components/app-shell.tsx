"use client";
import Link from "next/link";
import { usePathname,useRouter } from "next/navigation";
import { LayoutDashboard,ShoppingCart,Package,WalletCards,Users,Truck,BarChart3,Settings,LogOut,Boxes } from "lucide-react";
import { createClient } from "@/lib/supabase/client";

const nav=[["Огляд","/app",LayoutDashboard],["Продажі","/app/sales",ShoppingCart],["Склад","/app/inventory",Boxes],["Товари","/app/products",Package],["Клієнти","/app/customers",Users],["Закупівлі","/app/purchases",Truck],["Фінанси","/app/finance",WalletCards],["Аналітика","/app/analytics",BarChart3],["Налаштування","/app/settings",Settings]] as const;

export function AppShell({children,email}:{children:React.ReactNode;email:string}){
 const pathname=usePathname(); const router=useRouter();
 async function logout(){await createClient().auth.signOut();router.push("/login");router.refresh();}
 return <div className="app-layout"><aside className="sidebar">
  <Link href="/app" className="sidebar-brand"><span className="brand-mark">O</span><span>ORBITA</span></Link>
  <div className="workspace"><span className="workspace-dot"/>Моя компанія</div>
  <nav>{nav.map(([label,href,Icon])=><Link key={href} href={href} className={pathname===href?"nav-link active":"nav-link"}><Icon size={18}/><span>{label}</span></Link>)}</nav>
  <div className="sidebar-bottom"><div className="user-mini"><span className="avatar">{email[0]?.toUpperCase()??"U"}</span><div><b>{email.split("@")[0]}</b><small>{email}</small></div></div><button className="logout" onClick={logout}><LogOut size={16}/>Вийти</button></div>
 </aside><main className="app-main">{children}</main></div>;
}

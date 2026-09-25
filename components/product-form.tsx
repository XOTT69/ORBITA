"use client";
import {FormEvent,useState} from "react";
import {createClient} from "@/lib/supabase/client";
import {useRouter} from "next/navigation";
export function ProductForm(){
 const [name,setName]=useState("");const [sku,setSku]=useState("");const [sale,setSale]=useState("");const [purchase,setPurchase]=useState("");const [busy,setBusy]=useState(false);const router=useRouter();
 async function submit(e:FormEvent){e.preventDefault();setBusy(true);const supabase=createClient();const {data:{user}}=await supabase.auth.getUser();if(!user){setBusy(false);return router.push("/login");}
 const {data:member}=await supabase.from("organization_members").select("organization_id").eq("user_id",user.id).eq("status","active").limit(1).maybeSingle();
 if(!member){setBusy(false);alert("Спочатку створіть компанію.");return;}
 const {error}=await supabase.from("products").insert({organization_id:member.organization_id,name,sku:sku||null,sale_price:Number(sale)||0,purchase_price:Number(purchase)||0});
 setBusy(false);if(error)alert(error.message);else{setName("");setSku("");setSale("");setPurchase("");router.refresh();}
 }
 return <form className="inline-form" onSubmit={submit}><input value={name} onChange={e=>setName(e.target.value)} required placeholder="Назва товару"/><input value={sku} onChange={e=>setSku(e.target.value)} placeholder="SKU"/><input value={purchase} onChange={e=>setPurchase(e.target.value)} type="number" min="0" step="0.01" placeholder="Закупівля"/><input value={sale} onChange={e=>setSale(e.target.value)} type="number" min="0" step="0.01" placeholder="Продаж"/><button className="primary-button" disabled={busy}>{busy?"…":"Додати"}</button></form>;
}

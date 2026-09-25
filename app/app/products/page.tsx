import { createClient } from "@/lib/supabase/server";
import { ProductForm } from "@/components/product-form";
export default async function ProductsPage(){
 const supabase=await createClient();
 const {data:products}=await supabase.from("products").select("id,name,sku,sale_price,purchase_price,unit,is_active").order("created_at",{ascending:false});
 return <div className="page"><header className="page-header"><div><span className="eyebrow">КАТАЛОГ</span><h1>Товари</h1><p>Єдиний каталог товарів, SKU та цін.</p></div></header><div className="panel"><ProductForm/><div className="table-wrap"><table><thead><tr><th>Товар</th><th>SKU</th><th>Продаж</th><th>Закупівля</th><th>Статус</th></tr></thead><tbody>{products?.map(p=><tr key={p.id}><td><b>{p.name}</b></td><td>{p.sku||"—"}</td><td>{Number(p.sale_price).toLocaleString("uk-UA")} ₴</td><td>{Number(p.purchase_price).toLocaleString("uk-UA")} ₴</td><td><span className="status">{p.is_active?"Активний":"Вимкнений"}</span></td></tr>)}</tbody></table>{!products?.length&&<div className="empty-state">Товарів ще немає. Додайте перший вище.</div>}</div></div></div>;
}

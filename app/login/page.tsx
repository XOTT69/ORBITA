"use client";

import { FormEvent, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";

export default function LoginPage() {
  const router = useRouter();
  const [mode, setMode] = useState<"login" | "signup">("login");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [company, setCompany] = useState("");
  const [busy, setBusy] = useState(false);
  const [message, setMessage] = useState("");

  async function submit(e: FormEvent) {
    e.preventDefault();
    setBusy(true); setMessage("");
    const supabase = createClient();
    if (mode === "login") {
      const { error } = await supabase.auth.signInWithPassword({ email, password });
      if (error) setMessage(error.message); else router.push("/app");
    } else {
      const { data, error } = await supabase.auth.signUp({ email, password, options: { data: { company_name: company } } });
      if (error) setMessage(error.message);
      else if (data.session) router.push("/app");
      else setMessage("Перевірте email для підтвердження акаунта.");
    }
    setBusy(false);
  }

  return <main className="auth-page"><section className="auth-card">
    <div className="brand">ORBITA</div>
    <h1>{mode === "login" ? "Увійти в систему" : "Створити компанію"}</h1>
    <p className="muted">{mode === "login" ? "Продовжуйте керувати бізнесом." : "Перший крок — створити акаунт власника."}</p>
    <form onSubmit={submit} className="auth-form">
      {mode === "signup" && <label>Назва компанії<input value={company} onChange={e=>setCompany(e.target.value)} required placeholder="ТОВ «Моя компанія»"/></label>}
      <label>Email<input type="email" value={email} onChange={e=>setEmail(e.target.value)} required placeholder="you@company.ua"/></label>
      <label>Пароль<input type="password" minLength={6} value={password} onChange={e=>setPassword(e.target.value)} required placeholder="••••••••"/></label>
      {message && <div className="form-message">{message}</div>}
      <button className="primary-button" disabled={busy}>{busy ? "Зачекайте…" : mode === "login" ? "Увійти" : "Створити акаунт"}</button>
    </form>
    <button className="text-button" onClick={()=>{setMode(mode==="login"?"signup":"login");setMessage("")}}>
      {mode === "login" ? "Ще немає акаунта? Створити" : "Вже маєте акаунт? Увійти"}
    </button>
  </section></main>;
}

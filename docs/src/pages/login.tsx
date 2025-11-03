// typescript
// Datei: `src/pages/login.tsx`
import React, {JSX, useEffect, useState} from 'react';
import Layout from '@theme/Layout';
import useBaseUrl from '@docusaurus/useBaseUrl';

export default function LoginPage(): JSX.Element {
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');
    const [isDark, setIsDark] = useState<boolean>(false);
    const [loading, setLoading] = useState(false);

    const logoLight = useBaseUrl('/img/logo_vertical.svg');
    const logoDark = useBaseUrl('/img/logo_vertical_dark.svg');

    useEffect(() => {
        if (typeof window !== 'undefined' && window.matchMedia) {
            const mq = window.matchMedia('(prefers-color-scheme: dark)');
            const getInitialIsDark = () => document.documentElement.getAttribute('data-theme') === 'dark';
            setIsDark(getInitialIsDark());

            const handler = (e: MediaQueryListEvent) => setIsDark(e.matches);

            const themeObserver = new MutationObserver(() => {
                setIsDark(getInitialIsDark());
            });
            themeObserver.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });
            
            mq.addEventListener('change', handler);

            return () => {
                mq.removeEventListener('change', handler);
                themeObserver.disconnect();
            };
        }
    }, []);

    useEffect(() => {
        const bg = isDark ? '#0b1220' : '#f7f9fc';
        const prevHtmlBg = document.documentElement.style.background;
        const prevBodyBg = document.body.style.background;
        document.documentElement.style.background = bg;
        document.body.style.background = bg;
        return () => {
            document.documentElement.style.background = prevHtmlBg;
            document.body.style.background = prevBodyBg;
        };
    }, [isDark]);

    const API_BASE = 'https://shift-schedule-njnk.onrender.com';

    const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        setError('');
        if (!username || !password) {
            setError('Bitte Benutzername und Passwort eingeben.');
            return;
        }

        setLoading(true);
        try {
            const res = await fetch(`${API_BASE}/login`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ username, password }),
            });

            const data = await res.json().catch(() => ({}));
            if (!res.ok) {
                const msg = data?.error || 'Anmeldung fehlgeschlagen. Überprüfe Benutzername und Passwort.';
                setError(msg);
                setLoading(false);
                return;
            }

            const token = data?.access_token;
            if (!token) {
                setError('Kein Token vom Server erhalten.');
                setLoading(false);
                return;
            }

            localStorage.setItem('authToken', token);

            if (data?.expires_in) {
                const expiresAt = Date.now() + Number(data.expires_in) * 1000;
                localStorage.setItem('authTokenExpiresAt', String(expiresAt));
            }
            
            window.location.href = '/';
        } catch (err) {
            console.error('Login network error:', err);
            setError('Netzwerkfehler. Bitte versuche es später erneut.');
        } finally {
            setLoading(false);
        }
    };

    const cardBg = isDark
        ? 'linear-gradient(180deg, rgba(255,255,255,0.02), rgba(255,255,255,0.01))'
        : '#ffffff';
    const inputBg = isDark ? '#071022' : '#f3f7fb';
    const borderColor = isDark ? 'rgba(255,255,255,0.06)' : 'rgba(16,24,40,0.06)';
    const textColor = isDark ? '#e6eef8' : '#0f172a';

    return (
        <Layout title="Login" description="Anmelden">
            <div
                style={{
                    minHeight: '100vh',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    padding: '3rem 1rem',
                }}
            >
                <div
                    style={{
                        width: '100%',
                        maxWidth: 540,
                        borderRadius: 16,
                        padding: 28,
                        background: cardBg,
                        boxShadow: '0 12px 30px rgba(2,6,23,0.12)',
                        color: textColor,
                        backdropFilter: isDark ? 'blur(6px)' : undefined,
                        border: `1px solid ${borderColor}`,
                    }}
                >
                    <div style={{ display: 'flex', alignItems: 'center', gap: 14, marginBottom: 8 }}>
                        <picture>
                            <source srcSet={logoDark} media="(prefers-color-scheme: dark)" />
                            <img
                                src={logoLight}
                                alt="Logo"
                                style={{ height: 56, display: 'block' }}
                                onError={(e) => {
                                    (e.currentTarget as HTMLImageElement).style.display = 'none';
                                }}
                            />
                        </picture>

                        <div style={{ textAlign: 'center', flex: 1 }}>
                            <h1 style={{ margin: 0, fontSize: 20 }}>Willkommen zurück</h1>
                            <p
                                style={{
                                    margin: 0,
                                    fontSize: 13,
                                    color: isDark ? 'rgba(230,238,248,0.8)' : 'rgba(15,23,42,0.6)',
                                }}
                            >
                                Melde dich an, um fortzufahren
                            </p>
                        </div>
                    </div>

                    <form onSubmit={handleSubmit} style={{ display: 'grid', gap: 14, marginTop: 10 }}>
                        <label style={{ fontSize: 13, color: isDark ? 'rgba(230,238,248,0.85)' : 'rgba(15,23,42,0.7)' }}>
                            Benutzername (Vorname)
                            <input
                                type="text"
                                value={username}
                                onChange={(e) => setUsername(e.target.value)}
                                placeholder="z.B. max"
                                style={{
                                    width: '100%',
                                    marginTop: 8,
                                    padding: '12px 14px',
                                    borderRadius: 12,
                                    border: `1px solid ${borderColor}`,
                                    background: inputBg,
                                    color: textColor,
                                    outline: 'none',
                                    fontSize: 15,
                                }}
                                required
                                // Semantisch korrekter, da der Server nach dem Vornamen sucht.
                                autoComplete="given-name"
                            />
                        </label>

                        <label style={{ fontSize: 13, color: isDark ? 'rgba(230,238,248,0.85)' : 'rgba(15,23,42,0.7)' }}>
                            Passwort
                            <input
                                type="password"
                                value={password}
                                onChange={(e) => setPassword(e.target.value)}
                                placeholder="••••••••"
                                style={{
                                    width: '100%',
                                    marginTop: 8,
                                    padding: '12px 14px',
                                    borderRadius: 12,
                                    border: `1px solid ${borderColor}`,
                                    background: inputBg,
                                    color: textColor,
                                    outline: 'none',
                                    fontSize: 15,
                                }}
                                required
                                autoComplete="current-password"
                            />
                        </label>

                        {error && <div style={{ color: '#ff6b6b', fontSize: 13, textAlign: 'center' }}>{error}</div>}

                        <div style={{ display: 'flex', gap: 10, alignItems: 'center', justifyContent: 'space-between', marginTop: 6 }}>
                            <button
                                type="submit"
                                disabled={loading}
                                style={{
                                    flex: 1,
                                    background: loading ? 'linear-gradient(90deg,#a78bfa,#7dd3fc)' : 'linear-gradient(90deg,#6d28d9,#0891b2)',
                                    color: '#fff',
                                    padding: '12px 18px',
                                    borderRadius: 9999,
                                    border: 'none',
                                    fontWeight: 600,
                                    cursor: loading ? 'default' : 'pointer',
                                    boxShadow: '0 8px 20px rgba(13,26,60,0.18)',
                                    opacity: loading ? 0.9 : 1,
                                    transition: 'all 0.2s ease-in-out',
                                }}
                            >
                                {loading ? 'Lädt…' : 'Einloggen'}
                            </button>
                        </div>

                        <div style={{ textAlign: 'center' }}>
                            <a href="/register" style={{ fontSize: 14, color: isDark ? '#a8d1ff' : '#2563eb', textDecoration: 'none' }}>
                                Registrieren
                            </a>
                        </div>

                        <div style={{ textAlign: 'center' }}>
                            <a href="/forgot" style={{ fontSize: 13, color: isDark ? 'rgba(230,238,248,0.7)' : 'rgba(15,23,42,0.6)', textDecoration: 'none' }}>
                                Passwort vergessen?
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </Layout>
    );
}
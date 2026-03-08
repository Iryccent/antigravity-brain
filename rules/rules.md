# 📜 Reglas Globales del Antigravity Brain

> [!IMPORTANT]
> Estas reglas aplican a **TODOS los proyectos** gobernados por este Brain.  
> Son de cumplimiento obligatorio para todos los agentes de IA.

---

## 🏛️ Reglas Globales de Código

### RG-01: Zero Errores ESLint
- **Todo código** debe pasar `npx eslint` sin errores antes del merge
- Warnings deben ser menores a 5 por archivo
- Comando: `npx eslint . --max-warnings 5`

### RG-02: Cobertura de Tests Mínima
- Cobertura mínima: **85%** en statements, branches y functions
- Comando: `npx vitest run --coverage`
- El Test Guardian bloquea el merge si no se cumple

### RG-03: Límites de Complejidad
- Complejidad ciclomática máxima: **12** por función
- Funciones máximo **20 líneas** de código lógico
- Archivos máximo **350 líneas** (excluye comentarios)
- Anidamiento máximo: **4 niveles**

### RG-04: Nomenclatura
- **Componentes React:** PascalCase (`UserProfile`, `TaskCard`)
- **Hooks:** camelCase con prefijo `use` (`useUserData`, `useTaskList`)
- **Variables/funciones:** camelCase descriptivo (`handleSubmit`, `fetchUserData`)
- **Constantes globales:** SCREAMING_SNAKE_CASE (`MAX_RETRY_COUNT`)
- **Archivos:** kebab-case (`user-profile.tsx`, `task-card.tsx`)

### RG-05: Imports y Dependencias
- Sin imports no usados (error de ESLint)
- Sin dependencias circulares
- Imports agrupados: externos → internos → relativos
- Usar aliases de path (`@/components/`, `@/utils/`)

---

## 🔒 Restricciones de Seguridad

### RS-01: Zero API Keys en Código
- **PROHIBIDO** hardcodear keys, tokens o secrets
- Usar siempre variables de entorno: `process.env.VARIABLE_NAME`
- Archivos `.env` NUNCA en control de versiones
- Usar `.env.example` con valores placeholder

### RS-02: Validación de Inputs
- Todo input de usuario debe ser validado y sanitizado
- Usar librerías probadas: `zod`, `yup`, o validación nativa
- NUNCA confiar en datos del cliente sin validar en servidor

### RS-03: Autenticación y Autorización
- Usar Supabase Auth o NextAuth para autenticación
- Verificar permisos en el servidor (no solo en cliente)
- Tokens JWT con expiración razonable (máximo 24h para access tokens)
- Refresh tokens seguros con rotación

### RS-04: Sandbox y Entornos
- **local** → Solo desarrollo, nunca datos reales
- **staging** → Datos ficticios, pruebas de integración
- **production** → Solo tras PR aprobado y CI verde
- Variables de entorno separadas por ambiente

### RS-05: Dependencias
- Revisar vulnerabilidades: `npm audit` antes de cada deploy
- No usar dependencias con vulnerabilidades CRITICAL o HIGH sin parche
- Mantener dependencias actualizadas (máximo 6 meses de atraso)

---

## 🏗️ Guías Arquitectónicas

### GA-01: Principios SOLID
- **S** — Single Responsibility: Un módulo, una responsabilidad
- **O** — Open/Closed: Abierto para extensión, cerrado para modificación
- **L** — Liskov Substitution: Subtipos intercambiables
- **I** — Interface Segregation: Interfaces pequeñas y específicas
- **D** — Dependency Inversion: Depender de abstracciones

### GA-02: Estructura de Proyecto (Next.js)
```
src/
├── app/              # App Router (Next.js 13+)
│   ├── (auth)/       # Route groups
│   ├── api/          # API Routes
│   └── layout.tsx
├── components/       # Componentes React reutilizables
│   ├── ui/           # Primitivos de UI (Button, Input, etc.)
│   └── features/     # Componentes de features específicas
├── hooks/            # Custom hooks
├── lib/              # Utilidades y helpers
├── services/         # Lógica de negocio y llamadas a API
├── store/            # Estado global (Zustand/Jotai)
└── types/            # TypeScript types e interfaces
```

### GA-03: Patrones React Obligatorios
- Usar **Server Components** por defecto en Next.js
- `use client` solo cuando sea necesario (interactividad, hooks de estado)
- **Suspense** para loading states, **Error Boundaries** para errores
- Composición sobre herencia siempre

### GA-04: Gestión de Estado
- **Local state:** `useState` para estado de UI simple
- **Shared state:** Zustand o Jotai (NO Redux por defecto)
- **Server state:** React Query / TanStack Query
- **Forms:** React Hook Form + Zod para validación

### GA-05: Performance
- Imágenes: siempre usar `next/image` con dimensiones explícitas
- Fonts: `next/font` con `display: swap`
- Code splitting automático con dynamic imports para módulos > 50KB
- Memoización solo cuando haya problema medido de performance

---

## 🧪 Estándares de Testing

### ET-01: Pirámide de Tests
```
        /\
       /E2E\        ← 10% (Playwright, flujos críticos)
      /------\
     /Integra-\     ← 20% (API routes, hooks complejos)
    /  ción    \
   /------------\
  /    Unit      \  ← 70% (funciones, componentes, utils)
 /________________\
```

### ET-02: Convenciones de Nombrado
- Archivos: `*.test.ts` o `*.spec.ts` junto al archivo fuente
- E2E: `*.e2e.ts` en carpeta `/e2e`
- Describe: nombre del módulo (`UserService`, `useTaskList`)
- It/test: "should [behavior] when [condition]"

### ET-03: Cobertura Mínima por Tipo
| Tipo | Mínimo |
|------|--------|
| Utils / helpers | 95% |
| Hooks | 90% |
| Services | 85% |
| Componentes UI | 80% |
| API routes | 85% |

### ET-04: Mocks y Fixtures
- Centralizar mocks en `__mocks__/` o `src/test/mocks/`
- Usar `msw` (Mock Service Worker) para mock de APIs
- Fixtures con datos realistas pero anonimizados

---

## 📝 Estándares de Documentación

### ED-01: JSDoc Obligatorio
- Todas las funciones públicas de `services/` y `lib/`
- Props de componentes (excepto si TypeScript ya las documenta claramente)
- Hooks custom con ejemplos de uso

### ED-02: READMEs
- Cada feature compleja debe tener su propio `README.md`
- Incluir: propósito, cómo usar, dependencias, ejemplos

### ED-03: Comentarios
- Comentar el "por qué", no el "qué"
- Sin comentarios que repitan el código
- TODOs con ticket/issue: `// TODO(#123): Optimizar query`

---

## ⚡ Workflow de Trabajo

### WW-01: Antes de Empezar
1. Leer `AGENT.md` y este archivo
2. Verificar rama correcta (`feature/`, `fix/`, `refactor/`)
3. Nunca trabajar directo en `main`

### WW-02: Durante el Desarrollo
1. Commits atómicos y descriptivos (Conventional Commits)
2. Formato: `feat(scope): descripción` / `fix(scope): descripción`
3. Ejecutar `npx eslint` después de cada archivo modificado

### WW-03: Antes del Merge
1. `npx eslint . --max-warnings 5` → 0 errores
2. `npx vitest run --coverage` → ≥ 85%
3. PR con descripción clara de cambios
4. Al menos 1 review aprobado (del Ruthless Code Reviewer)
5. CI/GitHub Actions verde

---

**Última actualización:** Marzo 2026  
**Versión:** 1.0  
**Autor:** Jadriel + Antigravity

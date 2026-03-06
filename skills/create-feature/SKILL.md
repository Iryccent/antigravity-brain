# 🎨 Skill: Create Feature

> **Agente responsable:** React Component Specialist  
> **Propósito:** Scaffold rápido y estandarizado de nuevas features con estructura completa

---

## 📋 Descripción

Este skill genera automáticamente la estructura completa de una nueva feature React/Next.js, incluyendo componente, hook, servicio, tipos TypeScript y tests básicos.

## 🚀 Uso

```bash
node ~/.antigravity/skills/create-feature/scripts/create.js --name <FeatureName> [opciones]
```

### Opciones

| Flag | Descripción | Default |
|------|-------------|---------|
| `--name` | Nombre de la feature (PascalCase) | Requerido |
| `--path` | Ruta donde crear la feature | `src/features/` |
| `--with-tests` | Generar tests básicos | `true` |
| `--with-storybook` | Generar story de Storybook | `false` |
| `--type` | Tipo: `page`, `component`, `modal` | `component` |

### Ejemplos

```bash
# Feature básica
node create.js --name UserProfile

# Feature tipo página con Storybook
node create.js --name TaskDashboard --type page --with-storybook true

# Componente modal en ruta personalizada
node create.js --name ConfirmDialog --type modal --path src/components/modals/
```

---

## 📁 Estructura Generada

```
src/features/<feature-name>/
├── index.ts                      # Barrel export
├── <FeatureName>.tsx              # Componente principal
├── <FeatureName>.test.tsx         # Tests unitarios
├── use<FeatureName>.ts            # Custom hook
├── use<FeatureName>.test.ts       # Tests del hook
├── <feature-name>.service.ts      # Lógica de negocio/API
├── <feature-name>.types.ts        # TypeScript types
└── README.md                      # Documentación de la feature
```

---

## ✅ Checklist Post-Creación

Después de ejecutar el script, el React Component Specialist debe:

- [ ] Revisar y ajustar los tipos TypeScript generados
- [ ] Implementar la lógica real en el servicio
- [ ] Completar los tests con casos reales
- [ ] Verificar que ESLint no reporta errores
- [ ] Pasar el código al Test Guardian para revisión de cobertura
- [ ] Solicitar review del Ruthless Code Reviewer antes del merge

---

## 🔧 Requisitos

- Node.js ≥ 18
- Proyecto Next.js con TypeScript configurado
- `@/` alias configurado en `tsconfig.json`

---

**Versión:** 1.0  
**Última actualización:** Marzo 2026

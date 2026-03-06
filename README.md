# 🧠 Antigravity Brain - Configuración Avanzada 2026

> [!IMPORTANT]
> **Para Agentes de IA:** Lee [`AGENT.md`](./AGENT.md) PRIMERO antes de trabajar en este entorno.  
> Este Brain contiene **3 agentes especializados** con orquestación paralela y reglas de gobernanza global.

Este directorio contiene la **Gobernanza Global** de código para todos los proyectos, optimizada para máxima productividad con IA en 2026.

## 📁 Estructura

```
.antigravity/
├── AGENT.md                             # Instrucciones maestras para agentes (3 agentes)
├── README.md                            # Este archivo
├── argv.json                            # Configuración global optimizada (multi-agente + MCP)
├── sync-brain.ps1                       # Script de auto-sync con backup e integridad
├── rules/
│   └── rules.md                         # Reglas globales, seguridad y arquitectura
├── skills/
│   ├── create-feature/
│   │   ├── SKILL.md                     # Documentación del skill
│   │   └── scripts/
│   │       └── create.js               # Scaffold de features (Node.js)
│   ├── refactor-code/
│   │   ├── SKILL.md                     # Documentación del skill
│   │   └── scripts/
│   │       └── refactor.ps1            # Refactoring asistido (PowerShell)
│   └── test-suite/
│       ├── SKILL.md                     # Documentación del skill
│       └── scripts/
│           └── test.ps1                # Suite de testing con cobertura (PowerShell)
└── configs/
    ├── eslint/
    │   ├── .eslintrc.base.json          # Reglas maestras de ESLint
    │   ├── INSTALLATION_GUIDE.md        # Guía técnica
    │   ├── TEAM_MESSAGE.md              # Mensaje para el equipo
    │   └── EMERGENCY_PROTOCOL_ANTIGRAVITY.md  # Protocolo de rescate
    └── GITHUB_PERSISTENCE_SETUP.md      # Sincronización entre máquinas
```

## 🤖 Agentes Especializados

| Agente | Especialidad | Activación |
|--------|-------------|------------|
| **React Component Specialist** | Creación y optimización de componentes React/Next.js | `create-feature` |
| **Test Guardian** | Cobertura de tests ≥ 85%, TDD enforcement | `test-suite` |
| **Ruthless Code Reviewer** | Revisión implacable de calidad, deuda técnica | `refactor-code` |

Los 3 agentes pueden ejecutarse **en paralelo** para máxima productividad.

## 🚀 Inicio Rápido

1. **Sincronizar el Brain:**
   ```powershell
   powershell -File C:\Users\jadri\.antigravity\sync-brain.ps1
   ```

2. **Crear una nueva feature:**
   ```bash
   node ~/.antigravity/skills/create-feature/scripts/create.js --name MyFeature
   ```

3. **Ejecutar suite de tests:**
   ```powershell
   powershell -File ~/.antigravity/skills/test-suite/scripts/test.ps1
   ```

4. **Refactorizar código:**
   ```powershell
   powershell -File ~/.antigravity/skills/refactor-code/scripts/refactor.ps1 -Target src/
   ```

## 🛡️ Reglas Activas

- ❌ **Error:** Imports no usados
- ❌ **Error:** Dependencias circulares
- ❌ **Error:** API Keys hardcodeadas
- ⚠️ **Warn:** Complejidad ciclomática > 12
- ⚠️ **Warn:** Archivos > 350 líneas
- ⚠️ **Warn:** `console.log` (solo permite `warn`/`error`)
- ⚠️ **Warn:** Cobertura de tests < 85%

## 🔗 Integraciones MCP

- **FireCrawl** — Web scraping y extracción de contenido
- **Supabase** — Base de datos y autenticación
- **GitHub Actions** — CI/CD con artifacts y verificación automática

## 📊 Métricas Objetivo

| Métrica | Target |
|---------|--------|
| Cobertura de tests | ≥ 85% |
| ESLint errores | 0 |
| Tiempo de build | < 60s |
| Agentes paralelos | 3 simultáneos |

---

**Última actualización:** Marzo 2026  
**Versión:** 2.0 (Multi-agente + Skills + MCP)  
**Autor:** Jadriel + Antigravity

# 🧠 Antigravity Brain - Configuración Completa

> [!IMPORTANT]
> **Para Agentes de IA:** Lee [`AGENT.md`](file:///C:/Users/jadri/.antigravity/AGENT.md) PRIMERO antes de trabajar en este entorno.

Este directorio contiene la **Gobernanza Global** de código para todos los proyectos.

## 📁 Estructura

```
.antigravity/
├── configs/
│   ├── eslint/
│   │   ├── .eslintrc.base.json          # Reglas maestras
│   │   ├── INSTALLATION_GUIDE.md        # Guía técnica
│   │   ├── TEAM_MESSAGE.md              # Mensaje para el equipo
│   │   └── EMERGENCY_PROTOCOL_ANTIGRAVITY.md  # Protocolo de rescate
│   └── GITHUB_PERSISTENCE_SETUP.md      # Sincronización entre máquinas
└── sync-brain.ps1                        # Script de auto-sync (crear manualmente)
```

## 🚀 Inicio Rápido

1. **Instalación Local:**
   - Sigue `configs/eslint/INSTALLATION_GUIDE.md`

2. **Sincronización GitHub:**
   - Sigue `configs/GITHUB_PERSISTENCE_SETUP.md`

3. **Distribución al Equipo:**
   - Comparte `configs/eslint/TEAM_MESSAGE.md`

## 🛡️ Reglas Activas

- ❌ **Error:** Imports no usados
- ❌ **Error:** Dependencias circulares
- ⚠️ **Warn:** Complejidad > 12
- ⚠️ **Warn:** Archivos > 350 líneas
- ⚠️ **Warn:** `console.log` (solo permite `warn`/`error`)

---

**Última actualización:** Febrero 2026

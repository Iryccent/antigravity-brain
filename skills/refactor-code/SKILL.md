# 🔍 Skill: Refactor Code

> **Agente responsable:** Ruthless Code Reviewer  
> **Propósito:** Analizar y refactorizar código existente para mejorar calidad, legibilidad y mantenibilidad

---

## 📋 Descripción

Este skill ejecuta un análisis profundo del código en busca de violaciones a los principios SOLID, código duplicado, alta complejidad ciclomática, acoplamiento excesivo y otras señales de deuda técnica. Genera un reporte de severidad y puede aplicar fixes automáticos en casos simples.

## 🚀 Uso

```powershell
powershell -File ~/.antigravity/skills/refactor-code/scripts/refactor.ps1 -Target <ruta> [opciones]
```

### Parámetros

| Parámetro | Descripción | Default |
|-----------|-------------|---------|
| `-Target` | Ruta del archivo o directorio a analizar | Requerido |
| `-AutoFix` | Aplicar fixes automáticos cuando sea posible | `$false` |
| `-Report` | Generar reporte en archivo | `$false` |
| `-Severity` | Nivel mínimo a reportar: `low`, `medium`, `high`, `critical` | `medium` |

### Ejemplos

```powershell
# Analizar directorio completo
.\refactor.ps1 -Target src/

# Analizar con auto-fix y reporte
.\refactor.ps1 -Target src/services/ -AutoFix -Report

# Solo mostrar problemas críticos y altos
.\refactor.ps1 -Target src/ -Severity high
```

---

## 📊 Métricas Analizadas

| Métrica | Umbral Warning | Umbral Error |
|---------|---------------|--------------|
| Complejidad ciclomática | > 8 | > 12 |
| Líneas por función | > 15 | > 20 |
| Líneas por archivo | > 250 | > 350 |
| Parámetros por función | > 4 | > 6 |
| Nivel de anidamiento | > 3 | > 4 |

## 🚨 Severidades del Reporte

- **CRITICAL** — Violaciones de seguridad, bugs obvios, anti-patterns graves
- **HIGH** — Violaciones SOLID, complejidad extrema, código duplicado > 30%
- **MEDIUM** — Funciones largas, anidamiento excesivo, nombres no descriptivos
- **LOW** — Mejoras de estilo, optimizaciones menores

---

## ✅ Checklist Post-Refactoring

- [ ] Reporte generado y revisado
- [ ] Todos los CRITICAL y HIGH resueltos
- [ ] Tests siguen pasando tras los cambios
- [ ] ESLint sin errores
- [ ] Cobertura de tests no disminuyó

---

**Versión:** 1.0  
**Última actualización:** Marzo 2026

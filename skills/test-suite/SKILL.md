# 🛡️ Skill: Test Suite

> **Agente responsable:** Test Guardian  
> **Propósito:** Ejecutar suite completa de tests, verificar cobertura y bloquear merge si no cumple el mínimo

---

## 📋 Descripción

Este skill ejecuta el ciclo completo de testing: tests unitarios, de integración y E2E. Verifica que la cobertura sea ≥ 85% y genera un reporte detallado. Puede configurarse para bloquear el proceso de CI si no se cumple el umbral.

## 🚀 Uso

```powershell
powershell -File ~/.antigravity/skills/test-suite/scripts/test.ps1 [opciones]
```

### Parámetros

| Parámetro | Descripción | Default |
|-----------|-------------|---------|
| `-Type` | Tipo de tests: `unit`, `integration`, `e2e`, `all` | `all` |
| `-Coverage` | Ejecutar con reporte de cobertura | `$true` |
| `-MinCoverage` | Porcentaje mínimo requerido | `85` |
| `-Watch` | Modo watch para desarrollo | `$false` |
| `-CI` | Modo CI: bloquea si no cumple cobertura | `$false` |

### Ejemplos

```powershell
# Suite completa (default)
.\test.ps1

# Solo unit tests con cobertura
.\test.ps1 -Type unit -Coverage

# Modo CI estricto (falla si cobertura < 85%)
.\test.ps1 -Type all -CI -MinCoverage 85

# Modo watch para desarrollo
.\test.ps1 -Type unit -Watch
```

---

## 📊 Métricas de Cobertura

El Test Guardian exige cobertura mínima por tipo de archivo:

| Tipo de archivo | Mínimo |
|----------------|--------|
| `utils/` y `lib/` | 95% |
| `hooks/` | 90% |
| `services/` | 85% |
| `components/` | 80% |
| `api routes` | 85% |

## 🧪 Stack de Testing

- **Unit tests:** Vitest + React Testing Library
- **Integration tests:** Vitest con MSW (Mock Service Worker)
- **E2E tests:** Playwright
- **Cobertura:** v8 coverage (nativo en Vitest)

---

## ✅ Checklist del Test Guardian

Antes de aprobar un merge:

- [ ] `npx vitest run --coverage` sin fallos
- [ ] Cobertura global ≥ 85%
- [ ] Tests E2E de flujos críticos pasando
- [ ] Sin tests `.skip` o `.only` olvidados
- [ ] Mocks limpios (sin `console.error` suprimido)

---

**Versión:** 1.0  
**Última actualización:** Marzo 2026

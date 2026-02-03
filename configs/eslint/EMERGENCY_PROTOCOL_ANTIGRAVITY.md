# 🚨 PROTOCOLO DE EMERGENCIA: ANTIGRAVITY BRAIN 🚨

> [!IMPORTANT]
> Este documento rige el comportamiento del agente cuando pierde el rumbo o entra en bucles recursivos.

## 1. 📍 LA REGLA DE ORO DE LA UBICACIÓN
**EL CEREBRO (BRAIN) VIVE EN:** `C:\Users\jadri\.antigravity\configs\`
**EL CUERPO (PROYECTOS) VIVE EN:** `C:\Users\jadri\IRYCCENT_AXIS_HUB\`

Si estás editando configuración global ("Gobernanza", "Reglas", "Memoria"), **DEBES** estar en la carpeta `.antigravity`.
Si estás editando código de producto ("CRM", "Dashboard"), **DEBES** estar en la carpeta `IRYCCENT_AXIS_HUB`.

## 2. 🛑 STOP & RESET (EL BOTÓN ROJO)
Si fallas **2 veces seguidas** en una tarea técnica (ej: linter no corre, build falla):
1. **DETENTE INMEDIATAMENTE**.
2. No intentes una 3ra vez con una "ligera variación".
3. Lee este protocolo.
4. Pregunta al USUARIO.

## 3. 🛠️ GOBERNANZA DE CONFIGURACIÓN
- **Nunca improvises configs**. Usa las plantillas base en `configs/eslint/`.
- **No mezcles entornos**. No intentes correr comandos de proyecto (`npm run lint`) si estás configurando reglas globales.
- **Formato UNIVERSAL**. Prefiere JSON estándar para configs globales. Evita scripts complejos (.js/.ts) que dependan de entornos de ejecución locales no garantizados.

## 4. 🧠 RECUPERACIÓN DE CONTEXTO
Si el usuario dice "¿Dónde está el entrenamiento?", se refiere a ESTA carpeta (`.antigravity/configs`). **No busques en los proyectos.**

---
*Última actualización: Febrero 2026 - Protocolo de Rescate Activado*

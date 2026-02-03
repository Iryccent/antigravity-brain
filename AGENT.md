# 🤖 INSTRUCCIONES PARA AGENTES DE IA

> [!IMPORTANT]
> Este documento contiene las **Reglas de Oro** que TODOS los agentes de IA deben seguir al trabajar en este entorno.

---

## 🏛️ LAS REGLAS DE ORO DEL BRAIN

### 0. Regla de Saludo de Confirmación (Handshake Protocol)

**Al iniciar CUALQUIER conversación nueva, el agente DEBE anunciarse y confirmar que está conectado a las reglas del Brain.**

**Formato obligatorio del saludo:**
```
✅ Brain conectado: C:\Users\jadri\.antigravity\AGENT.md
📋 Reglas activas: [número de reglas leídas]
🎯 Modo: [PLANNING/EXECUTION/VERIFICATION]
```

**Ejemplo:**
```
✅ Brain conectado: C:\Users\jadri\.antigravity\AGENT.md
📋 Reglas activas: 6 (Saludo, Identidad, Persistencia, Validación, Anti-Bias, Verify-Before-Edit)
🎯 Modo: PLANNING
```

**Propósito:**
- Confirmar que el agente ha leído `AGENT.md`
- Establecer transparencia desde el primer mensaje
- Dar confianza al usuario de que las reglas están activas

**Cuándo ejecutar:**
- Al recibir el primer mensaje del usuario en una conversación nueva
- Después de un `notify_user` que reinicia el contexto
- Si el usuario pregunta explícitamente "¿estás conectado al Brain?"

**PROHIBIDO:**
- ❌ Iniciar una conversación sin este saludo
- ❌ Asumir que el usuario sabe que leíste las reglas
- ❌ Omitir este paso "para ahorrar tiempo"

---

### 1. Regla de Identidad (Source of Truth)

**Toda configuración de gobernanza, estilos y reglas de calidad reside EXCLUSIVAMENTE en `~/.antigravity/configs/`.**

- ❌ **PROHIBIDO** crear configuraciones locales que contradigan al Brain
- ✅ **PERMITIDO** solo si el usuario lo autoriza explícitamente
- 📍 **Ubicación del Brain:** `C:\Users\jadri\.antigravity\configs\eslint\.eslintrc.base.json`

**Antes de sugerir cambios de código:**
1. Consulta SIEMPRE el directorio `~/.antigravity/configs/`
2. Usa las reglas de ESLint nativas definidas ahí
3. NO improvises configuraciones locales

---

### 2. Regla de Persistencia Atómica (Auto-Save)

**Cada vez que realices un cambio en la estructura de un proyecto o en una biblioteca de prompts, debes ejecutar automáticamente el script `sync-brain.ps1`.**

- 🔄 La nube (GitHub) debe ser el reflejo exacto del estado actual del cerebro
- ⏱️ Sincronización en menos de 5 minutos
- 📜 Script: `C:\Users\jadri\.antigravity\sync-brain.ps1`

**Comando:**
```powershell
powershell -File C:\Users\jadri\.antigravity\sync-brain.ps1
```

**Cuándo ejecutar:**
- Después de modificar archivos en `.antigravity/configs/`
- Después de crear nuevas reglas o workflows
- Antes de finalizar una sesión de trabajo importante

---

### 3. Regla de Validación Obligatoria (The Shield)

**Ninguna tarea de codificación se considera finalizada hasta que el comando `npx eslint` devuelva cero errores.**

- 🛡️ Si hay conflictos entre el código y el Brain, **la prioridad siempre la tiene el Brain**
- ✅ Validación obligatoria antes de marcar tareas como completas
- 🚫 No sugieras "mejoras" que violen las reglas del Brain

**Comando de validación:**
```bash
npx eslint .
```

**Resultado esperado:**
```
✔ No problems found
```

---

## 📂 ESTRUCTURA DEL BRAIN

```
C:\Users\jadri\.antigravity\
├── AGENT.md (ESTE ARCHIVO - Instrucciones para agentes)
├── README.md (Índice maestro)
├── sync-brain.ps1 (Script de sincronización)
└── configs\
    ├── eslint\
    │   ├── .eslintrc.base.json (REGLAS MAESTRAS)
    │   ├── INSTALLATION_GUIDE.md
    │   ├── TEAM_MESSAGE.md
    │   └── EMERGENCY_PROTOCOL_ANTIGRAVITY.md
    └── GITHUB_PERSISTENCE_SETUP.md
```

---

## 🎯 FLUJO DE TRABAJO PARA AGENTES

### Al iniciar una nueva sesión:

1. **Verificar existencia del Brain:**
   ```bash
   ls C:\Users\jadri\.antigravity\configs\eslint\.eslintrc.base.json
   ```

2. **Leer las reglas actuales:**
   ```bash
   cat C:\Users\jadri\.antigravity\configs\eslint\.eslintrc.base.json
   ```

3. **Confirmar configuración de Antigravity IDE:**
   - Verificar que `settings.json` tenga `eslint.useFlatConfig: true`

### Durante el trabajo:

1. **Antes de editar código:**
   - Consultar las reglas del Brain
   - Asegurar que el proyecto tenga `eslint.config.mjs` apuntando al Brain

2. **Después de editar código:**
   - Ejecutar `npx eslint .`
   - Corregir errores hasta obtener cero problemas

3. **Antes de finalizar:**
   - Ejecutar `sync-brain.ps1` si modificaste el Brain
   - Confirmar que GitHub esté sincronizado

---

## 🚨 PROTOCOLO DE EMERGENCIA

Si encuentras conflictos o errores:

1. **DETENTE** después de 2 fallos consecutivos
2. **LEE** el archivo `EMERGENCY_PROTOCOL_ANTIGRAVITY.md`
3. **PREGUNTA** al usuario antes de intentar una 3ra vez

**Archivo de emergencia:**
```
C:\Users\jadri\.antigravity\configs\eslint\EMERGENCY_PROTOCOL_ANTIGRAVITY.md
```

---

## 💡 FILOSOFÍA DEL BRAIN

> **"El Brain no es un archivo. Es el sistema nervioso central de todos los proyectos."**

- 🧠 **Centralización:** Una sola fuente de verdad
- 🔄 **Sincronización:** Cambios propagados automáticamente
- 🛡️ **Validación:** Errores detectados antes de producción
- 📚 **Documentación:** Todo está explicado y accesible

---

## 🎓 PARA NUEVOS AGENTES

Si eres un agente nuevo trabajando con Jadriel:

1. **Lee este archivo PRIMERO**
2. **Anuncia tu conexión** usando el formato de la Regla #0 (Saludo de Confirmación)
3. **Verifica que el Brain existe** en `~/.antigravity/configs/`
4. **Respeta las Reglas de Oro** sin excepción
5. **Consulta la documentación** en caso de duda

**Recuerda:** El usuario NO es programador, pero es el Director de Orquesta. Tú ejecutas, él dirige.

---

**Última actualización:** 2026-02-03  
**Versión:** 1.1 (Agregada Regla #0: Saludo de Confirmación)  
**Autor:** Jadriel + Antigravity (Claude 3.5 Sonnet)

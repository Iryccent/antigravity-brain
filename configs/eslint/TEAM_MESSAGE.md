# 🚀 MENSAJE PARA EL EQUIPO: NUEVA GOBERNANZA DE CÓDIGO

Hola equipo,

A partir de ahora, **todos los proyectos** van a usar las mismas reglas de ESLint desde un solo lugar (el "Brain" de Antigravity). Esto nos ahorra discusiones sobre estilo de código y atrapa bugs antes de que lleguen a producción.

## ¿Qué cambia para ti?

1. **Una sola vez:** Instala los plugins de ESLint en tu proyecto (comando abajo).
2. **Configura tu editor:** Agrega 3 líneas a tu `settings.json` de VS Code.
3. **Listo:** Al guardar archivos, el código se limpia solo.

## Instalación (5 minutos)

### 1️⃣ Crea la carpeta del Brain
```bash
mkdir -p %USERPROFILE%\.antigravity\configs\eslint
```

### 2️⃣ Descarga el archivo maestro
Copia el archivo `.eslintrc.base.json` que está en el repo a esa carpeta.

### 3️⃣ Instala los plugins (en cada proyecto)
```bash
npm install --save-dev eslint eslint-plugin-import eslint-plugin-unused-imports eslint-plugin-sonarjs eslint-plugin-security
```

### 4️⃣ Configura VS Code
Abre `Settings JSON` (Ctrl+Shift+P → "Preferences: Open User Settings (JSON)") y pega:

```json
{
  "eslint.options": {
    "overrideConfigFile": "C:/Users/TU_USUARIO/.antigravity/configs/eslint/.eslintrc.base.json"
  },
  "eslint.validate": ["javascript", "javascriptreact", "typescript", "typescriptreact"],
  "editor.codeActionsOnSave": { "source.fixAll.eslint": "explicit" }
}
```

**⚠️ Cambia `TU_USUARIO` por tu nombre de usuario de Windows.**

---

## ¿Qué hace esto?

- ❌ **Bloquea** imports no usados (error de build)
- ⚠️ **Advierte** sobre funciones muy complejas (más de 12 ramas)
- ⚠️ **Advierte** sobre archivos muy largos (más de 350 líneas)
- ❌ **Bloquea** dependencias circulares
- ⚠️ **Advierte** sobre `console.log` olvidados (solo permite `warn` y `error`)

---

## Ayuda

Si algo no funciona, revisa el archivo `INSTALLATION_GUIDE.md` en la misma carpeta del Brain. Ahí está el troubleshooting completo.

**Preguntas:** Escríbeme directamente.

---
*Gobernanza activada - Febrero 2026*

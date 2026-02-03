# 📋 GUÍA DE INSTALACIÓN: ANTIGRAVITY BRAIN - ESLINT GLOBAL

> [!IMPORTANT]
> Esta configuración establece reglas de código **obligatorias** para todos los proyectos. No es opcional.

## 🎯 Objetivo
Tener un único archivo maestro de ESLint que gobierne todos tus proyectos desde un solo lugar (el "Brain" de Antigravity).

---

## 📂 PASO 1: Crear la Carpeta del Brain

Abre tu terminal y ejecuta:

```bash
mkdir -p %USERPROFILE%\.antigravity\configs\eslint
```

*(En Linux/Mac: `mkdir -p ~/.antigravity/configs/eslint`)*

---

## 📝 PASO 2: Copiar el Archivo Maestro

Copia el archivo `.eslintrc.base.json` (que ya está en esta carpeta) a:

**Windows:** `C:\Users\TU_USUARIO\.antigravity\configs\eslint\.eslintrc.base.json`
**Linux/Mac:** `~/.antigravity/configs/eslint/.eslintrc.base.json`

---

## 🔌 PASO 3: Instalar Plugins Requeridos

**CRÍTICO:** Aunque la configuración esté en el Brain, los plugins deben instalarse en cada proyecto.

Navega a la carpeta de tu proyecto y ejecuta:

```bash
npm install --save-dev eslint eslint-plugin-import eslint-plugin-unused-imports eslint-plugin-sonarjs eslint-plugin-security
```

---

## ⚙️ PASO 4: Configurar VS Code (o tu IDE)

Abre `Settings JSON` en VS Code (Ctrl+Shift+P → "Preferences: Open User Settings (JSON)") y agrega:

```json
{
  "eslint.options": {
    "overrideConfigFile": "C:/Users/TU_USUARIO/.antigravity/configs/eslint/.eslintrc.base.json"
  },
  "eslint.validate": ["javascript", "javascriptreact", "typescript", "typescriptreact"],
  "editor.codeActionsOnSave": { "source.fixAll.eslint": "explicit" }
}
```

**⚠️ REEMPLAZA `TU_USUARIO` con tu nombre de usuario de Windows/Linux.**

---

## ✅ PASO 5: Verificar que Funciona

1. Abre cualquier archivo `.js` o `.ts` en tu proyecto.
2. Escribe `console.log("test")` y guarda.
3. Deberías ver una advertencia amarilla (porque `no-console` está configurado como `warn`).

---

## 🛡️ Reglas Activas (No Negociables)

| Regla | Nivel | Descripción |
|-------|-------|-------------|
| `unused-imports/no-unused-imports` | Error | Imports no usados rompen el build |
| `complexity` | Warn | Funciones con más de 12 ramas de complejidad |
| `max-lines-per-file` | Warn | Archivos con más de 350 líneas |
| `import/no-cycle` | Error | Dependencias circulares prohibidas |
| `no-console` | Warn | Solo `console.warn` y `console.error` permitidos |

---

## 🚨 Troubleshooting

### "Plugin not found"
→ Ejecutaste `npm install` de los plugins en el proyecto? (Paso 3)

### "Config file not found"
→ Verificaste que la ruta en `settings.json` tenga TU nombre de usuario?

### "ESLint no hace nada"
→ Reinicia VS Code después de cambiar `settings.json`.

---

**Última actualización:** Febrero 2026

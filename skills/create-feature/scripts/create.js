#!/usr/bin/env node
// ============================================================
// Antigravity Brain - Create Feature Script
// Agente: React Component Specialist
// Versión: 1.0 - Marzo 2026
// ============================================================
// Uso: node create.js --name <FeatureName> [opciones]
// ============================================================

const fs = require("fs");
const path = require("path");

// ── Parsear argumentos CLI ──────────────────────────────────
function parseArgs(argv) {
  const args = {};
  for (let i = 2; i < argv.length; i += 2) {
    const key = argv[i].replace(/^--/, "");
    const value = argv[i + 1];
    args[key] = value;
  }
  return args;
}

// ── Validar y normalizar nombre ─────────────────────────────
function toPascalCase(str) {
  return str.charAt(0).toUpperCase() + str.slice(1);
}

function toKebabCase(str) {
  return str
    .replace(/([A-Z])/g, "-$1")
    .toLowerCase()
    .replace(/^-/, "");
}

// ── Plantillas de archivos ──────────────────────────────────
function getComponentTemplate(name) {
  const kebab = toKebabCase(name);
  return `import type { ${name}Props } from './${kebab}.types';
import { use${name} } from './use${name}';

export function ${name}({ className }: ${name}Props) {
  const { data, isLoading, error } = use${name}();

  if (isLoading) return <div>Cargando...</div>;
  if (error) return <div>Error: {error.message}</div>;

  return (
    <div className={className} data-testid="${kebab}">
      {/* Implementar componente */}
      <pre>{JSON.stringify(data, null, 2)}</pre>
    </div>
  );
}

export default ${name};
`;
}

function getHookTemplate(name) {
  const kebab = toKebabCase(name);
  return `import { useState, useEffect } from 'react';
import { ${kebab}Service } from './${kebab}.service';
import type { ${name}Data } from './${kebab}.types';

interface Use${name}Return {
  data: ${name}Data | null;
  isLoading: boolean;
  error: Error | null;
}

export function use${name}(): Use${name}Return {
  const [data, setData] = useState<${name}Data | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    let cancelled = false;

    async function fetchData() {
      try {
        setIsLoading(true);
        const result = await ${kebab}Service.getData();
        if (!cancelled) {
          setData(result);
        }
      } catch (err) {
        if (!cancelled) {
          setError(err instanceof Error ? err : new Error(String(err)));
        }
      } finally {
        if (!cancelled) {
          setIsLoading(false);
        }
      }
    }

    fetchData();
    return () => { cancelled = true; };
  }, []);

  return { data, isLoading, error };
}
`;
}

function getServiceTemplate(name) {
  const kebab = toKebabCase(name);
  return `import type { ${name}Data } from './${kebab}.types';

/**
 * Servicio para ${name}
 * Maneja toda la lógica de negocio y llamadas a API
 */
export const ${kebab}Service = {
  /**
   * Obtiene los datos de ${name}
   */
  async getData(): Promise<${name}Data> {
    // TODO: Implementar llamada real a API
    const response = await fetch('/api/${kebab}');

    if (!response.ok) {
      throw new Error(\`Error al obtener datos: \${response.statusText}\`);
    }

    return response.json();
  },
};
`;
}

function getTypesTemplate(name) {
  return `// TypeScript types para ${name}

export interface ${name}Props {
  className?: string;
}

export interface ${name}Data {
  id: string;
  // TODO: Agregar campos según la feature
  createdAt: string;
  updatedAt: string;
}
`;
}

function getTestTemplate(name) {
  const kebab = toKebabCase(name);
  return `import { render, screen } from '@testing-library/react';
import { describe, it, expect, vi } from 'vitest';
import { ${name} } from './${name}';
import * as hook from './use${name}';

// Mock del hook
vi.mock('./use${name}');

describe('${name}', () => {
  it('should render loading state', () => {
    vi.mocked(hook.use${name}).mockReturnValue({
      data: null,
      isLoading: true,
      error: null,
    });

    render(<${name} />);
    expect(screen.getByText('Cargando...')).toBeInTheDocument();
  });

  it('should render error state', () => {
    vi.mocked(hook.use${name}).mockReturnValue({
      data: null,
      isLoading: false,
      error: new Error('Error de prueba'),
    });

    render(<${name} />);
    expect(screen.getByText('Error: Error de prueba')).toBeInTheDocument();
  });

  it('should render data when loaded', () => {
    vi.mocked(hook.use${name}).mockReturnValue({
      data: { id: '1', createdAt: '2026-01-01', updatedAt: '2026-01-01' },
      isLoading: false,
      error: null,
    });

    render(<${name} />);
    expect(screen.getByTestId('${kebab}')).toBeInTheDocument();
  });
});
`;
}

function getHookTestTemplate(name) {
  const kebab = toKebabCase(name);
  return `import { renderHook, waitFor } from '@testing-library/react';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { use${name} } from './use${name}';
import { ${kebab}Service } from './${kebab}.service';

vi.mock('./${kebab}.service');

describe('use${name}', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('should start with loading state', () => {
    vi.mocked(${kebab}Service.getData).mockResolvedValue({
      id: '1',
      createdAt: '2026-01-01',
      updatedAt: '2026-01-01',
    });

    const { result } = renderHook(() => use${name}());
    expect(result.current.isLoading).toBe(true);
    expect(result.current.data).toBeNull();
    expect(result.current.error).toBeNull();
  });

  it('should fetch data successfully', async () => {
    const mockData = { id: '1', createdAt: '2026-01-01', updatedAt: '2026-01-01' };
    vi.mocked(${kebab}Service.getData).mockResolvedValue(mockData);

    const { result } = renderHook(() => use${name}());

    await waitFor(() => {
      expect(result.current.isLoading).toBe(false);
    });

    expect(result.current.data).toEqual(mockData);
    expect(result.current.error).toBeNull();
  });

  it('should handle errors', async () => {
    vi.mocked(${kebab}Service.getData).mockRejectedValue(new Error('API Error'));

    const { result } = renderHook(() => use${name}());

    await waitFor(() => {
      expect(result.current.isLoading).toBe(false);
    });

    expect(result.current.error?.message).toBe('API Error');
    expect(result.current.data).toBeNull();
  });
});
`;
}

function getIndexTemplate(name) {
  return `export { ${name} } from './${name}';
export type { ${name}Props, ${name}Data } from './${toKebabCase(name)}.types';
`;
}

function getReadmeTemplate(name) {
  const kebab = toKebabCase(name);
  return `# ${name}

## Descripción

[Describir el propósito de esta feature]

## Uso

\`\`\`tsx
import { ${name} } from '@/features/${kebab}';

export default function MyPage() {
  return <${name} />;
}
\`\`\`

## Props

| Prop | Tipo | Default | Descripción |
|------|------|---------|-------------|
| className | string | - | Clase CSS adicional |

## Dependencias

- [Listar dependencias de esta feature]

## Tests

\`\`\`bash
npx vitest run src/features/${kebab}/
\`\`\`

---

*Generado por Antigravity Brain - React Component Specialist*
`;
}

// ── Crear archivos ──────────────────────────────────────────
function createFeatureFiles(name, outputPath, withTests) {
  const kebab = toKebabCase(name);
  const featurePath = path.join(outputPath, kebab);

  // Crear directorio
  fs.mkdirSync(featurePath, { recursive: true });

  const files = {
    [`${name}.tsx`]: getComponentTemplate(name),
    [`use${name}.ts`]: getHookTemplate(name),
    [`${kebab}.service.ts`]: getServiceTemplate(name),
    [`${kebab}.types.ts`]: getTypesTemplate(name),
    "index.ts": getIndexTemplate(name),
    "README.md": getReadmeTemplate(name),
  };

  if (withTests !== "false") {
    files[`${name}.test.tsx`] = getTestTemplate(name);
    files[`use${name}.test.ts`] = getHookTestTemplate(name);
  }

  for (const [filename, content] of Object.entries(files)) {
    const filePath = path.join(featurePath, filename);
    fs.writeFileSync(filePath, content, "utf-8");
    console.log(`  ✓ Creado: ${path.relative(process.cwd(), filePath)}`);
  }

  return featurePath;
}

// ── Main ────────────────────────────────────────────────────
function main() {
  const args = parseArgs(process.argv);

  if (!args.name) {
    console.error("❌ Error: --name es requerido");
    console.error("   Uso: node create.js --name <FeatureName>");
    process.exit(1);
  }

  const name = toPascalCase(args.name);
  const outputPath = args.path || path.join(process.cwd(), "src", "features");
  const withTests = args["with-tests"] !== "false";

  console.log("");
  console.log("🎨 React Component Specialist — Creando feature...");
  console.log(`   Feature: ${name}`);
  console.log(`   Ruta: ${outputPath}`);
  console.log(`   Tests: ${withTests ? "✓" : "✗"}`);
  console.log("");

  const featurePath = createFeatureFiles(name, outputPath, args["with-tests"]);

  console.log("");
  console.log(`✅ Feature '${name}' creada en: ${featurePath}`);
  console.log("");
  console.log("📋 Próximos pasos:");
  console.log("   1. Implementa la lógica en el servicio");
  console.log("   2. Ajusta los tipos TypeScript");
  console.log("   3. Completa los tests con casos reales");
  console.log("   4. Ejecuta: npx eslint src/features/ && npx vitest run");
  console.log("");
}

main();

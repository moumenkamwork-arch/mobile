#!/usr/bin/env python3
"""Generate a minimal Playwright smoke-test harness for Flutter Web/admin/marketing surfaces."""
from __future__ import annotations
import argparse
from pathlib import Path

PACKAGE_JSON = '{"scripts":{"test":"playwright test","test:headed":"playwright test --headed"},"devDependencies":{"@playwright/test":"^1.49.0"}}'
CONFIG = """import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  timeout: 30_000,
  use: {
    baseURL: process.env.E2E_BASE_URL || 'http://localhost:8080',
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'mobile-chrome', use: { ...devices['Pixel 7'] } },
  ],
});
"""
SMOKE = """import { expect, test } from '@playwright/test';

test('app shell loads', async ({ page }) => {
  await page.goto('/');
  await expect(page.locator('body')).toBeVisible();
  await expect(page).toHaveTitle(/.+/);
});

test('critical route smoke checks', async ({ page }) => {
  const routes = (process.env.E2E_ROUTES || '/').split(',').map((r) => r.trim()).filter(Boolean);
  for (const route of routes) {
    await page.goto(route);
    await expect(page.locator('body')).toBeVisible();
  }
});
"""
README = """# Browser E2E Tests

Use these Playwright tests for Flutter Web, admin dashboards, landing pages, checkout, and browser-only smoke checks.

```bash
cd e2e/playwright
npm install
E2E_BASE_URL=http://localhost:8080 E2E_ROUTES=/,/login npm test
```

Do not commit real credentials. Use sandbox users and CI secrets.
"""

def write(path: Path, content: str, force: bool) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists() and not force:
        return
    path.write_text(content.strip() + "\n", encoding="utf-8")

def main() -> None:
    parser = argparse.ArgumentParser(description="Create Playwright smoke tests.")
    parser.add_argument("--root", default=".")
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()
    base = Path(args.root).resolve() / "e2e" / "playwright"
    write(base / "package.json", PACKAGE_JSON, args.force)
    write(base / "playwright.config.ts", CONFIG, args.force)
    write(base / "tests" / "smoke.spec.ts", SMOKE, args.force)
    write(base / "README.md", README, args.force)
    print(f"Generated Playwright smoke-test harness in {base}")

if __name__ == "__main__":
    main()

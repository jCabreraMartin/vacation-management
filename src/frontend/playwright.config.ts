import { defineConfig, devices } from '@playwright/test'

const backendUrl = 'http://localhost:5080'

export default defineConfig({
  testDir: './e2e',
  fullyParallel: false,
  workers: 1,
  forbidOnly: !!process.env.CI,
  retries: 0,
  reporter: [['list'], ['html', { open: 'never' }]],
  use: {
    baseURL: 'http://localhost:5173',
    trace: 'retain-on-failure',
  },
  projects: [{ name: 'chromium', use: { ...devices['Desktop Chrome'] } }],
  // Fresh processes per run: the in-memory seed (DL-B1-05) starts clean.
  webServer: [
    {
      command: `dotnet run --project ../backend/src/VacationManagement.Api --no-launch-profile --urls ${backendUrl}`,
      url: `${backendUrl}/api/vacation-requests/LAB-002`,
      reuseExistingServer: false,
      timeout: 120_000,
    },
    {
      command: 'npx vite --port 5173 --strictPort',
      url: 'http://localhost:5173',
      reuseExistingServer: false,
      env: { VITE_BACKEND_URL: backendUrl },
      timeout: 60_000,
    },
  ],
})

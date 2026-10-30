const assert = require('node:assert/strict')
const fs = require('node:fs')
const path = require('node:path')
const { test } = require('node:test')

const root = path.resolve(__dirname, '../..')
const workflow = fs.readFileSync(path.join(root, '.github/workflows/ci.yml'), 'utf8')

test('application jobs use their actual directories and lockfile', () => {
  assert.match(workflow, /working-directory: src\/backend/)
  assert.match(workflow, /working-directory: src\/frontend/)
  assert.match(workflow, /cache-dependency-path: src\/frontend\/package-lock.json/)
})

test('application gates fail closed and include coverage, mutation and E2E', () => {
  for (const command of [
    'dotnet build',
    'dotnet format',
    'dotnet test',
    'Assert-BackendCoverage.ps1',
    'dotnet tool run dotnet-stryker',
    'npm run lint',
    'npm run format:check',
    'npm run test:coverage',
    'npm run test:mutation',
    'npm run test:e2e',
  ]) {
    assert.ok(workflow.includes(command), `Missing gate: ${command}`)
  }
  assert.doesNotMatch(workflow, /continue-on-error|--if-present|\|\| true|azure\/login|terraform (?:plan|apply)/)
  assert.ok(workflow.includes("-ne 'success'"), 'Summary must reject skipped or cancelled gates')
})

test('configured mutation and frontend coverage thresholds are unchanged', () => {
  const backend = JSON.parse(fs.readFileSync(path.join(root, 'src/backend/stryker-config.json'), 'utf8'))
  const frontend = JSON.parse(fs.readFileSync(path.join(root, 'src/frontend/stryker.config.json'), 'utf8'))
  assert.equal(backend['stryker-config'].thresholds.break, 60)
  assert.equal(frontend.thresholds.break, 60)
  assert.match(fs.readFileSync(path.join(root, 'src/frontend/vite.config.ts'), 'utf8'), /lines: 80/)
})

test('historical preparation is distinct from the laboratory exception', () => {
  const research = fs.readFileSync(path.join(root, 'specs/006-rechazo-solicitudes/planning/research.md'), 'utf8')
  const tasks = fs.readFileSync(path.join(root, 'specs/006-rechazo-solicitudes/planning/tasks.md'), 'utf8')
  const index = fs.readFileSync(path.join(root, 'specs/README.md'), 'utf8')
  assert.match(research, /preparaci.n hist.rica/i)
  assert.match(research, /excepci.n del laboratorio/i)
  assert.match(tasks, /preparaci.n hist.rica/i)
  assert.match(index, /9\. Gherkin[^\n]*tests\/rechazo-solicitud\.feature/)
  const requirements = fs.readFileSync(path.join(root, 'specs/006-rechazo-solicitudes/requirements/requirements.md'), 'utf8')
  assert.match(requirements, /\| Estado \| Draft \|/)
})
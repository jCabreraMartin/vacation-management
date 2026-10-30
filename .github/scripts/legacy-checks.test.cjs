const assert = require('node:assert/strict')
const fs = require('node:fs')
const path = require('node:path')
const { test } = require('node:test')

const root = path.resolve(__dirname, '../..')
const read = (file) => fs.readFileSync(path.join(root, file), 'utf8')

test('contract checks use the real API suite without optional runners or writes', () => {
  const workflow = read('.github/workflows/contract-tests.yml')
  assert.match(workflow, /contents: read/)
  assert.match(workflow, /working-directory: src\/backend/)
  assert.match(workflow, /dotnet test tests\/VacationManagement.IntegrationTests/)
  assert.match(workflow, /legacy-checks\.cjs contracts/)
  assert.doesNotMatch(workflow, /npm ci|--if-present|cucumber-tests:|pact-tests:|createComment|secrets\.|contents: write/)
})

test('documentation governance performs real read-only checks', () => {
  const workflow = read('.github/workflows/devops-doc-sync.yml')
  assert.match(workflow, /contents: read/)
  assert.match(workflow, /legacy-checks\.cjs documentation/)
  assert.match(workflow, /node --test/)
  assert.doesNotMatch(workflow, /contents: write|pull-requests: write|git commit|git push|gh pr create|secrets\.|npm install|npm run docs:/)
})

function contractsFixture() {
  const architecture = 'GET /api/vacation-requests/{id}\nPOST /api/vacation-requests/{id}/rejection'
  return new Map([
    ['specs/006-rechazo-solicitudes/requirements/requirements.md', '**AC-LAB-01:** pending\n**AC-LAB-02:** conflict'],
    ['specs/006-rechazo-solicitudes/tests/rechazo-solicitud.feature', '@AC-LAB-01\nEscenario: reject\n@AC-LAB-02\nEscenario: repeat'],
    ['docs/design/architecture/architecture-overview.md', architecture],
    ['src/backend/src/VacationManagement.Api/VacationRequestEndpoints.cs', 'MapGet("/{id}")\nMapPost("/{id}/rejection")'],
    ['src/backend/tests/VacationManagement.IntegrationTests/VacationRequestEndpointsTests.cs', 'Reject_twice_returns_problem_409_and_keeps_rejected'],
  ])
}

test('traceability accepts real AC tags and reports formal contracts as not configured', () => {
  const { checkContracts } = require('./legacy-checks.cjs')
  const fixture = contractsFixture()
  const result = checkContracts([...fixture.keys()], (file) => fixture.get(file))
  assert.equal(result.criteria, 2)
  assert.equal(result.formalContracts, 'not-configured')
})

test('traceability rejects missing or unknown criteria instead of counting empty scenarios', () => {
  const { checkContracts } = require('./legacy-checks.cjs')
  for (const feature of ['@AC-LAB-01\nEscenario: only one', '@AC-LAB-01 @AC-LAB-02 @AC-LAB-99\nEscenario: unknown', '@AC-LAB-01 @AC-LAB-02']) {
    const fixture = contractsFixture()
    fixture.set('specs/006-rechazo-solicitudes/tests/rechazo-solicitud.feature', feature)
    assert.throws(() => checkContracts([...fixture.keys()], (file) => fixture.get(file)))
  }
})

test('new formal contracts require an explicitly configured validator', () => {
  const { checkContracts } = require('./legacy-checks.cjs')
  const fixture = contractsFixture()
  for (const contract of ['contracts/openapi.yaml', 'specs/006-rechazo-solicitudes/contracts/api.json', 'contracts/schema.graphql']) {
    assert.throws(() => checkContracts([...fixture.keys(), contract], (file) => fixture.get(file)), /validator/i)
  }
})

test('documentation link checks reject missing destinations and path escapes', () => {
  const { checkDocumentLinks } = require('./legacy-checks.cjs')
  assert.equal(checkDocumentLinks('docs/report.md', '[spec](../specs/feature.md)', new Set(['specs/feature.md'])), 1)
  assert.throws(() => checkDocumentLinks('docs/report.md', '[missing](missing.md)', new Set()), /missing/i)
  assert.throws(() => checkDocumentLinks('docs/report.md', '[escape](../../outside.md)', new Set()), /outside/i)
})

test('historical code examples do not become false document dependencies', () => {
  const { checkDocumentLinks } = require('./legacy-checks.cjs')
  const sample = '```text\n[example](absent.md)\n```\n[external](https://example.invalid)\n[section](#local)'
  assert.equal(checkDocumentLinks('docs/report.md', sample, new Set()), 0)
})

function documentationFixture() {
  const feature = 'specs/006-rechazo-solicitudes'
  const documents = [
    `${feature}/requirements/requirements.md`,
    `${feature}/requirements/use-cases/UC-008-rechazar-solicitud.md`,
    `${feature}/requirements/state-model.md`,
    `${feature}/planning/plan.md`,
    `${feature}/planning/research.md`,
    `${feature}/planning/tasks.md`,
    'specs/README.md',
    'specs/clarification-summary.md',
    'docs/design/architecture/architecture-overview.md',
    'docs/work-management/f006-bolt-1-audit.md',
    'docs/work-management/f006-bolt-1-publication.md',
    'docs/work-management/legacy-checks-adaptation.md',
  ]
  const fixture = new Map(documents.map((file) => [file, 'Evidence #74']))
  fixture.set(`${feature}/requirements/requirements.md`, '| Estado | Draft |')
  fixture.set(`${feature}/planning/research.md`, 'Preparación histórica; excepción del laboratorio')
  fixture.set('specs/clarification-summary.md', 'Preguntas abiertas\n| PA-06 | Lab | Abierta |\n| PA-14 | Lab | Abierta |\n| PA-26 | Lab | Abierta |')
  return fixture
}

test('project documentation requires actual evidence and preserves client Draft status', () => {
  const { checkDocumentation } = require('./legacy-checks.cjs')
  const fixture = documentationFixture()
  assert.equal(checkDocumentation([...fixture.keys()], (file) => fixture.get(file)).documents, 12)
  fixture.set('specs/006-rechazo-solicitudes/requirements/requirements.md', '| Estado | Approved |')
  assert.throws(() => checkDocumentation([...fixture.keys()], (file) => fixture.get(file)), /Draft/)
})

test('project documentation rejects missing, empty or broken published evidence', () => {
  const { checkDocumentation } = require('./legacy-checks.cjs')
  const target = 'specs/006-rechazo-solicitudes/planning/tasks.md'
  for (const replacement of [undefined, '', '[broken](missing.md)']) {
    const fixture = documentationFixture()
    if (replacement === undefined) fixture.delete(target)
    else fixture.set(target, replacement)
    assert.throws(() => checkDocumentation([...fixture.keys()], (file) => fixture.get(file)))
  }
})

test('each client clarification stays open even when the document mentions open questions elsewhere', () => {
  const { checkDocumentation } = require('./legacy-checks.cjs')
  const fixture = documentationFixture()
  fixture.set('specs/clarification-summary.md', fixture.get('specs/clarification-summary.md').replace('| PA-14 | Lab | Abierta |', '| PA-14 | Lab | Cerrada |'))

  assert.throws(() => checkDocumentation([...fixture.keys()], (file) => fixture.get(file)), /PA-14/)
})
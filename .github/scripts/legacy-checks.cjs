const assert = require('node:assert/strict')
const fs = require('node:fs')
const path = require('node:path')
const { execFileSync } = require('node:child_process')

const featureRoot = 'specs/006-rechazo-solicitudes'
const requirementsPath = `${featureRoot}/requirements/requirements.md`
const featurePath = `${featureRoot}/tests/rechazo-solicitud.feature`
const architecturePath = 'docs/design/architecture/architecture-overview.md'
const endpointPath = 'src/backend/src/VacationManagement.Api/VacationRequestEndpoints.cs'
const apiTestsPath = 'src/backend/tests/VacationManagement.IntegrationTests/VacationRequestEndpointsTests.cs'

function checkContracts(files, read) {
  const formal = files.filter((file) => /^(?:contracts\/|specs\/[^/]+\/contracts\/).+\.(?:ya?ml|json|graphql|gql)$/i.test(file))
  assert.equal(formal.length, 0, `Explicit validator configuration required for: ${formal.join(', ')}`)
  const requirements = read(requirementsPath)
  const feature = read(featurePath)
  const criteria = new Set([...requirements.matchAll(/\*\*(AC-LAB-\d{2}):\*\*/g)].map((match) => match[1]))
  const tags = new Set([...feature.matchAll(/(?:^|\s)@(AC-LAB-\d{2})(?=\s|$)/gm)].map((match) => match[1]))
  assert.ok(criteria.size > 0, 'No laboratory acceptance criteria were found')
  assert.match(feature, /^\s*Escenario:/m, 'No laboratory scenarios were found')
  assert.deepEqual([...tags].sort(), [...criteria].sort(), 'Acceptance criteria and scenario tags differ')
  const architecture = read(architecturePath)
  assert.ok(architecture.includes('GET /api/vacation-requests/{id}'), 'GET route missing from architecture')
  assert.ok(architecture.includes('POST /api/vacation-requests/{id}/rejection'), 'POST route missing from architecture')
  const endpoints = read(endpointPath)
  assert.ok(endpoints.includes('MapGet("/{id}"'), 'GET route missing from API')
  assert.ok(endpoints.includes('MapPost("/{id}/rejection"'), 'Rejection route missing from API')
  assert.ok(read(apiTestsPath).includes('Reject_twice_returns_problem_409_and_keeps_rejected'), 'API conflict regression missing')
  return { criteria: criteria.size, formalContracts: 'not-configured' }
}

function checkDocumentLinks(file, text, files) {
  const narrative = text.replace(/```[^\r\n]*\r?\n[\s\S]*?```/g, '')
  let count = 0
  for (const match of narrative.matchAll(/\]\(([^)\s]+)\)/g)) {
    const target = match[1].split('#')[0]
    if (!target || /^(?:https?:|mailto:)/i.test(target)) continue
    const decoded = decodeURIComponent(target)
    assert.ok(!path.posix.isAbsolute(decoded), `Document link points outside repository: ${target}`)
    const resolved = path.posix.normalize(path.posix.join(path.posix.dirname(file), decoded))
    assert.ok(!resolved.startsWith('../'), `Document link points outside repository: ${target}`)
    assert.ok(files.has(resolved), `${file}: missing published document destination ${resolved}`)
    count += 1
  }
  return count
}

function checkDocumentation(files, read) {
  const published = new Set(files)
  const documents = [
    requirementsPath,
    `${featureRoot}/requirements/use-cases/UC-008-rechazar-solicitud.md`,
    `${featureRoot}/requirements/state-model.md`,
    `${featureRoot}/planning/plan.md`,
    `${featureRoot}/planning/research.md`,
    `${featureRoot}/planning/tasks.md`,
    'specs/README.md',
    'specs/clarification-summary.md',
    architecturePath,
    'docs/work-management/f006-bolt-1-audit.md',
    'docs/work-management/f006-bolt-1-publication.md',
    'docs/work-management/legacy-checks-adaptation.md',
  ]
  let links = 0
  for (const file of documents) {
    assert.ok(published.has(file), `Required published evidence missing: ${file}`)
    const text = read(file)
    assert.ok(text.trim().length > 0, `Empty evidence: ${file}`)
    links += checkDocumentLinks(file, text, published)
  }
  assert.match(read(requirementsPath), /\| Estado \| Draft \|/, 'Feature must remain Draft')
  assert.match(read(`${featureRoot}/planning/research.md`), /preparaci.n hist.rica/i)
  assert.match(read(`${featureRoot}/planning/research.md`), /excepci.n del laboratorio/i)
  const clarifications = read('specs/clarification-summary.md')
  for (const question of ['PA-06', 'PA-14', 'PA-26']) {
    const row = clarifications.split(/\r?\n/).find((line) => new RegExp(`^\\|\\s*${question}\\s*\\|`).test(line))
    assert.match(row || '', /\|\s*Abierta\.?\s*\|\s*$/i, `${question} must remain open in the published clarification table`)
  }
  assert.ok(read('docs/work-management/legacy-checks-adaptation.md').includes('#74'), 'Workflow change traceability missing')
  return { documents: documents.length, links }
}

function run(mode) {
  assert.ok(['contracts', 'documentation'].includes(mode), 'Use contracts or documentation')
  const root = path.resolve(__dirname, '../..')
  const git = (args) => execFileSync('git', args, { cwd: root, encoding: 'utf8' })
  const ref = process.env.CHECK_REF || 'HEAD'
  assert.ok(ref === 'HEAD' || /^[0-9a-f]{40}$/i.test(ref), 'Invalid immutable inspection ref')
  const files = git(['ls-tree', '-r', '--name-only', ref]).trim().split(/\r?\n/)
  const read = (file) => git(['show', `${ref}:${file}`])
  const result = mode === 'contracts' ? checkContracts(files, read) : checkDocumentation(files, read)
  const summary = [`## ${mode === 'contracts' ? 'Contract traceability' : 'Project documentation governance'}`, '', `PASS: ${JSON.stringify(result)}`]
  if (mode === 'contracts') {
    summary.push('', 'Formal schemas: NOT CONFIGURED; this is not OpenAPI validation.', 'Gherkin: tag traceability only, not syntax validation or BDD execution.', 'API behavior is verified by the separate .NET integration test job.')
    const base = process.env.PR_BASE_SHA
    if (base) {
      assert.match(base, /^[0-9a-f]{40}$/i, 'Invalid PR base SHA')
      const changes = git(['diff', '--name-status', base, ref, '--', 'contracts', featureRoot, architecturePath, endpointPath])
      summary.push('', 'Changed contract/specification surfaces (informative, not a breaking-change verdict):', '', '```text', changes.trim() || '(none)', '```')
    } else {
      summary.push('', 'No PR base supplied; no comparison against an assumed branch.')
    }
  } else {
    summary.push('', 'Inline local links and required F-006 evidence checked on the published tree.', 'External URL availability, inherited framework ownership/cadences and client approval are not asserted.', 'No automatic commits, PR comments or synchronisation writes.')
  }
  const output = summary.join('\n') + '\n'
  process.stdout.write(output)
  if (process.env.GITHUB_STEP_SUMMARY) fs.appendFileSync(process.env.GITHUB_STEP_SUMMARY, output)
}

module.exports = { checkContracts, checkDocumentLinks, checkDocumentation }

if (require.main === module) {
  try { run(process.argv[2]) } catch (error) {
    console.error(error.message)
    process.exitCode = 1
  }
}
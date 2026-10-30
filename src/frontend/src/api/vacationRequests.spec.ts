import { afterEach, describe, expect, it, vi } from 'vitest'
import { getVacationRequest, rejectVacationRequest, type VacationRequest } from './vacationRequests'

const request: VacationRequest = {
  id: 'LAB-001',
  personName: 'Persona Ficticia A',
  startDate: '2026-07-01',
  endDate: '2026-07-15',
  status: 'Pending',
}

function respond(status: number, body?: unknown) {
  const fetchMock = vi
    .fn()
    .mockResolvedValue(new Response(body === undefined ? null : JSON.stringify(body), { status }))
  vi.stubGlobal('fetch', fetchMock)
  return fetchMock
}

afterEach(() => {
  vi.unstubAllGlobals()
})

describe.each([
  { name: 'GET', operation: getVacationRequest },
  { name: 'POST', operation: rejectVacationRequest },
])('$name response reading', ({ operation }) => {
  it('returns an error for malformed JSON without retrying', async () => {
    const fetchMock = vi.fn().mockResolvedValue(new Response('{invalid', { status: 200 }))
    vi.stubGlobal('fetch', fetchMock)

    await expect(operation('LAB-001')).resolves.toEqual({ kind: 'error' })
    expect(fetchMock).toHaveBeenCalledTimes(1)
  })

  it('returns an error when the response body cannot be read', async () => {
    const response = new Response('{}', { status: 200 })
    vi.spyOn(response, 'json').mockRejectedValue(new TypeError('response interrupted'))
    const fetchMock = vi.fn().mockResolvedValue(response)
    vi.stubGlobal('fetch', fetchMock)

    await expect(operation('LAB-001')).resolves.toEqual({ kind: 'error' })
    expect(fetchMock).toHaveBeenCalledTimes(1)
  })
})

describe('getVacationRequest', () => {
  it('requests the encoded id and returns the request on 200', async () => {
    const fetchMock = respond(200, request)

    const result = await getVacationRequest('LAB 001/x')

    expect(fetchMock).toHaveBeenCalledWith('/api/vacation-requests/LAB%20001%2Fx', {
      headers: { Accept: 'application/json' },
    })
    expect(result).toEqual({ kind: 'ok', request })
  })

  it('returns not-found on 404', async () => {
    respond(404, { status: 404 })

    expect(await getVacationRequest('NO-EXISTE')).toEqual({ kind: 'not-found' })
  })

  it('returns error on other statuses', async () => {
    respond(500, { status: 500 })

    expect(await getVacationRequest('LAB-001')).toEqual({ kind: 'error' })
  })

  it('returns error when the network fails', async () => {
    vi.stubGlobal('fetch', vi.fn().mockRejectedValue(new TypeError('network')))

    expect(await getVacationRequest('LAB-001')).toEqual({ kind: 'error' })
  })
})

describe('rejectVacationRequest', () => {
  it('posts to the rejection resource and returns the rejected request on 200', async () => {
    const rejected = { ...request, status: 'Rejected' }
    const fetchMock = respond(200, rejected)

    const result = await rejectVacationRequest('LAB-001')

    expect(fetchMock).toHaveBeenCalledWith('/api/vacation-requests/LAB-001/rejection', {
      method: 'POST',
      headers: { Accept: 'application/json', 'X-Laboratory-Request': '1' },
    })
    expect(result).toEqual({ kind: 'ok', request: rejected })
  })

  it('returns not-found on 404', async () => {
    respond(404, { status: 404 })

    expect(await rejectVacationRequest('NO-EXISTE')).toEqual({ kind: 'not-found' })
  })

  it('returns not-pending on 409', async () => {
    respond(409, { status: 409 })

    expect(await rejectVacationRequest('LAB-001')).toEqual({ kind: 'not-pending' })
  })

  it('returns error on other statuses', async () => {
    respond(500, { status: 500 })

    expect(await rejectVacationRequest('LAB-001')).toEqual({ kind: 'error' })
  })

  it('returns error when the network fails', async () => {
    vi.stubGlobal('fetch', vi.fn().mockRejectedValue(new TypeError('network')))

    expect(await rejectVacationRequest('LAB-001')).toEqual({ kind: 'error' })
  })
})

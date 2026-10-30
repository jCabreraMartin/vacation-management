export type VacationRequestStatus = 'Pending' | 'Rejected'

export interface VacationRequest {
  id: string
  personName: string
  startDate: string
  endDate: string
  status: VacationRequestStatus
}

export type GetResult =
  { kind: 'ok'; request: VacationRequest } | { kind: 'not-found' } | { kind: 'error' }

export type RejectResult = GetResult | { kind: 'not-pending' }

const headers = { Accept: 'application/json' }

function resourceUrl(id: string): string {
  return `/api/vacation-requests/${encodeURIComponent(id)}`
}

async function send(url: string, init: RequestInit): Promise<Response | undefined> {
  try {
    return await fetch(url, init)
  } catch {
    return undefined
  }
}

export async function getVacationRequest(id: string): Promise<GetResult> {
  try {
    const response = await send(resourceUrl(id), { headers })
    if (response?.status === 200) {
      return { kind: 'ok', request: (await response.json()) as VacationRequest }
    }
    return response?.status === 404 ? { kind: 'not-found' } : { kind: 'error' }
  } catch {
    return { kind: 'error' }
  }
}

export async function rejectVacationRequest(id: string): Promise<RejectResult> {
  try {
    const response = await send(`${resourceUrl(id)}/rejection`, {
      method: 'POST',
      headers: { ...headers, 'X-Laboratory-Request': '1' },
    })
    switch (response?.status) {
      case 200:
        return { kind: 'ok', request: (await response.json()) as VacationRequest }
      case 404:
        return { kind: 'not-found' }
      case 409:
        return { kind: 'not-pending' }
      default:
        return { kind: 'error' }
    }
  } catch {
    return { kind: 'error' }
  }
}

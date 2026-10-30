import { flushPromises, mount } from '@vue/test-utils'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import VacationRequestReview from './VacationRequestReview.vue'
import {
  getVacationRequest,
  rejectVacationRequest,
  type GetResult,
  type RejectResult,
  type VacationRequest,
} from '../api/vacationRequests'

vi.mock('../api/vacationRequests', () => ({
  getVacationRequest: vi.fn(),
  rejectVacationRequest: vi.fn(),
}))

const pending: VacationRequest = {
  id: 'LAB-001',
  personName: 'Persona Ficticia A',
  startDate: '2026-07-01',
  endDate: '2026-07-15',
  status: 'Pending',
}
const rejected: VacationRequest = { ...pending, status: 'Rejected' }

const getMock = vi.mocked(getVacationRequest)
const rejectMock = vi.mocked(rejectVacationRequest)

function deferred<T>() {
  let resolve!: (value: T) => void
  const promise = new Promise<T>((r) => {
    resolve = r
  })
  return { promise, resolve }
}

async function mountLoaded(result: GetResult = { kind: 'ok', request: pending }) {
  getMock.mockResolvedValue(result)
  const wrapper = mount(VacationRequestReview, { props: { requestId: 'LAB-001' } })
  await flushPromises()
  return wrapper
}

function rejectButton(wrapper: Awaited<ReturnType<typeof mountLoaded>>) {
  return wrapper.find('button')
}

beforeEach(() => {
  getMock.mockReset()
  rejectMock.mockReset()
})

describe('VacationRequestReview', () => {
  it('shows a loading state while the request is fetched', async () => {
    const pendingGet = deferred<GetResult>()
    getMock.mockReturnValue(pendingGet.promise)

    const wrapper = mount(VacationRequestReview, { props: { requestId: 'LAB-001' } })

    expect(getMock).toHaveBeenCalledWith('LAB-001')
    expect(wrapper.get('[role="status"]').text()).toBe('Cargando solicitud…')
    pendingGet.resolve({ kind: 'ok', request: pending })
    await flushPromises()
    expect(wrapper.find('[role="status"]').exists()).toBe(false)
  })

  it('shows the request data, its pending status and the reject action', async () => {
    const wrapper = await mountLoaded()

    expect(wrapper.text()).toContain('LAB-001')
    expect(wrapper.text()).toContain('Persona Ficticia A')
    expect(wrapper.text()).toContain('2026-07-01')
    expect(wrapper.text()).toContain('2026-07-15')
    expect(wrapper.get('[data-testid="status"]').text()).toBe('Pendiente')
    expect(rejectButton(wrapper).text()).toBe('Rechazar solicitud')
    expect(rejectButton(wrapper).attributes('disabled')).toBeUndefined()
  })

  it('asks for no reason and offers no alternative dates (BL-RF-014)', async () => {
    const wrapper = await mountLoaded()

    expect(wrapper.findAll('input, textarea, select')).toHaveLength(0)
  })

  it('identifies the data as fictitious laboratory data', async () => {
    const wrapper = await mountLoaded()

    expect(wrapper.get('[data-testid="lab-notice"]').text()).toBe(
      'Datos ficticios de laboratorio. Sin autenticación ni integración corporativa.',
    )
  })

  it('rejects the request and shows the rejected status without the action', async () => {
    rejectMock.mockResolvedValue({ kind: 'ok', request: rejected })
    const wrapper = await mountLoaded()

    await rejectButton(wrapper).trigger('click')
    await flushPromises()

    expect(rejectMock).toHaveBeenCalledWith('LAB-001')
    expect(wrapper.get('[data-testid="status"]').text()).toBe('Rechazada')
    expect(wrapper.get('[data-testid="result"]').text()).toBe('Solicitud rechazada.')
    expect(rejectButton(wrapper).exists()).toBe(false)
  })

  it('disables the action and shows progress while rejecting', async () => {
    const pendingReject = deferred<RejectResult>()
    rejectMock.mockReturnValue(pendingReject.promise)
    const wrapper = await mountLoaded()

    await rejectButton(wrapper).trigger('click')

    expect(rejectButton(wrapper).attributes('disabled')).toBeDefined()
    expect(rejectButton(wrapper).text()).toBe('Rechazando…')
    pendingReject.resolve({ kind: 'ok', request: rejected })
    await flushPromises()
  })

  it('informs when the request is no longer pending and shows its current status', async () => {
    rejectMock.mockResolvedValue({ kind: 'not-pending' })
    const wrapper = await mountLoaded()
    getMock.mockResolvedValue({ kind: 'ok', request: rejected })

    await rejectButton(wrapper).trigger('click')
    await flushPromises()

    expect(wrapper.get('[role="alert"]').text()).toBe(
      'La solicitud no está pendiente y no se puede rechazar.',
    )
    expect(getMock).toHaveBeenCalledTimes(2)
    expect(wrapper.get('[data-testid="status"]').text()).toBe('Rechazada')
    expect(rejectButton(wrapper).exists()).toBe(false)
  })

  it('informs when the request to reject no longer exists', async () => {
    rejectMock.mockResolvedValue({ kind: 'not-found' })
    const wrapper = await mountLoaded()

    await rejectButton(wrapper).trigger('click')
    await flushPromises()

    expect(wrapper.get('[role="alert"]').text()).toBe('La solicitud LAB-001 no existe.')
    expect(rejectButton(wrapper).exists()).toBe(false)
  })

  it('does not confirm or retry a rejection whose response is unknown', async () => {
    rejectMock.mockResolvedValue({ kind: 'error' })
    const wrapper = await mountLoaded()

    await rejectButton(wrapper).trigger('click')
    await flushPromises()

    expect(wrapper.get('[role="alert"]').text()).toBe(
      'No se ha podido confirmar el rechazo. El resultado es desconocido.',
    )
    expect(wrapper.get('[data-testid="status"]').text()).toBe('Pendiente')
    expect(wrapper.find('[data-testid="result"]').exists()).toBe(false)
    expect(rejectButton(wrapper).text()).toBe('Comprobar estado')
    expect(rejectButton(wrapper).attributes('disabled')).toBeUndefined()
    expect(rejectMock).toHaveBeenCalledTimes(1)
    expect(getMock).toHaveBeenCalledTimes(1)
  })

  it.each([
    { current: pending, label: 'Pendiente', canReject: true },
    { current: rejected, label: 'Rechazada', canReject: false },
  ])(
    'explicitly reads the current $label status before allowing another rejection',
    async ({ current, label, canReject }) => {
      rejectMock.mockResolvedValue({ kind: 'error' })
      const wrapper = await mountLoaded()
      await rejectButton(wrapper).trigger('click')
      await flushPromises()
      getMock.mockResolvedValue({ kind: 'ok', request: current })

      await rejectButton(wrapper).trigger('click')
      await flushPromises()

      expect(getMock).toHaveBeenCalledTimes(2)
      expect(rejectMock).toHaveBeenCalledTimes(1)
      expect(wrapper.get('[data-testid="status"]').text()).toBe(label)
      expect(wrapper.find('[role="alert"]').exists()).toBe(false)
      expect(wrapper.find('[data-testid="result"]').exists()).toBe(false)
      expect(rejectButton(wrapper).exists()).toBe(canReject)
      if (canReject) {
        expect(rejectButton(wrapper).attributes('disabled')).toBeUndefined()
      }
    },
  )

  it('shows not found without the action when the request does not exist', async () => {
    const wrapper = await mountLoaded({ kind: 'not-found' })

    expect(wrapper.get('[role="alert"]').text()).toBe('La solicitud LAB-001 no existe.')
    expect(rejectButton(wrapper).exists()).toBe(false)
  })

  it('shows an error without the action when loading fails', async () => {
    const wrapper = await mountLoaded({ kind: 'error' })

    expect(wrapper.get('[role="alert"]').text()).toBe(
      'No se ha podido completar la operación. Inténtalo de nuevo.',
    )
    expect(rejectButton(wrapper).exists()).toBe(false)
  })

  it('does not offer the action for an already rejected request', async () => {
    const wrapper = await mountLoaded({ kind: 'ok', request: rejected })

    expect(wrapper.get('[data-testid="status"]').text()).toBe('Rechazada')
    expect(rejectButton(wrapper).exists()).toBe(false)
    expect(wrapper.find('[data-testid="result"]').exists()).toBe(false)
  })
})

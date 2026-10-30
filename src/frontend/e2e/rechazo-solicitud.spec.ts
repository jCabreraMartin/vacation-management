import { expect, test } from '@playwright/test'

// specs/006-rechazo-solicitudes/tests/rechazo-solicitud.feature · escenarios @ui (AC-LAB-04/05)
test.describe('F-006 rechazar una solicitud pendiente @ui', () => {
  test('rechazar desde la interfaz sin motivo ni alternativas @smoke', async ({ page }) => {
    await page.goto('/?id=LAB-001')

    await expect(page.getByTestId('lab-notice')).toBeVisible()
    await expect(page.getByText('Persona Ficticia A')).toBeVisible()
    await expect(page.getByText('2026-07-01')).toBeVisible()
    await expect(page.getByText('2026-07-15')).toBeVisible()
    await expect(page.getByTestId('status')).toHaveText('Pendiente')
    await expect(page.locator('input, textarea, select')).toHaveCount(0)

    await page.getByRole('button', { name: 'Rechazar solicitud' }).click()

    await expect(page.getByTestId('status')).toHaveText('Rechazada')
    await expect(page.getByTestId('result')).toHaveText('Solicitud rechazada.')
    await expect(page.getByRole('button', { name: 'Rechazar solicitud' })).toHaveCount(0)

    await page.reload()
    await expect(page.getByTestId('status')).toHaveText('Rechazada')
    await expect(page.getByRole('button', { name: 'Rechazar solicitud' })).toHaveCount(0)
  })

  test('error al consultar una solicitud inexistente @regression', async ({ page }) => {
    await page.goto('/?id=NO-EXISTE')

    await expect(page.getByRole('alert')).toHaveText('La solicitud NO-EXISTE no existe.')
    await expect(page.getByRole('button', { name: 'Rechazar solicitud' })).toHaveCount(0)
  })

  test('impide una escritura de origen ajeno @regression', async ({ request }) => {
    const response = await request.post('/api/vacation-requests/LAB-002/rejection', {
      headers: { Origin: 'https://audit.invalid', 'X-Laboratory-Request': '1' },
    })

    expect(response.status()).toBe(403)
    const current = await request.get('/api/vacation-requests/LAB-002')
    expect(await current.json()).toMatchObject({ status: 'Pending' })
  })

  test('muestra error y termina la carga si GET devuelve JSON ilegible @regression', async ({
    page,
  }) => {
    await page.route('**/api/vacation-requests/LAB-001', (route) =>
      route.fulfill({ status: 200, contentType: 'application/json', body: '{invalid' }),
    )

    await page.goto('/?id=LAB-001')

    await expect(page.getByRole('alert')).toBeVisible()
    await expect(page.getByText('Cargando solicitud…')).toHaveCount(0)
    await expect(page.getByRole('button', { name: 'Rechazar solicitud' })).toHaveCount(0)
  })

  test('no reintenta un POST aplicado con respuesta ilegible y consulta su estado @regression', async ({
    page,
  }) => {
    let writes = 0
    await page.route('**/api/vacation-requests/LAB-002/rejection', async (route) => {
      writes += 1
      const applied = await route.fetch()
      expect(applied.status()).toBe(200)
      await route.fulfill({ response: applied, body: '{invalid' })
    })
    await page.goto('/?id=LAB-002')
    await page.getByRole('button', { name: 'Rechazar solicitud' }).click()

    await expect(page.getByRole('alert')).toHaveText(
      'No se ha podido confirmar el rechazo. El resultado es desconocido.',
    )
    await expect(page.getByRole('button', { name: 'Rechazar solicitud' })).toHaveCount(0)
    await expect(page.getByTestId('result')).toHaveCount(0)
    await page.getByRole('button', { name: 'Comprobar estado' }).click()
    await expect(page.getByTestId('status')).toHaveText('Rechazada')
    await expect(page.getByRole('alert')).toHaveCount(0)
    expect(writes).toBe(1)
  })
})

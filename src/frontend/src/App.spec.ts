import { mount } from '@vue/test-utils'
import { afterEach, describe, expect, it } from 'vitest'
import App from './App.vue'

const ReviewStub = { name: 'VacationRequestReview', props: ['requestId'], template: '<div />' }

function mountWithUrl(search: string) {
  window.history.replaceState(null, '', `/${search}`)
  return mount(App, { global: { stubs: { VacationRequestReview: ReviewStub } } })
}

afterEach(() => {
  window.history.replaceState(null, '', '/')
})

describe('App', () => {
  it('reviews the request identified by the id query parameter', () => {
    const wrapper = mountWithUrl('?id=LAB-002')

    expect(wrapper.getComponent(ReviewStub).props('requestId')).toBe('LAB-002')
  })

  it('asks for an identifier when none is given', () => {
    const wrapper = mountWithUrl('')

    expect(wrapper.findComponent(ReviewStub).exists()).toBe(false)
    expect(wrapper.get('[role="alert"]').text()).toBe(
      'Indica el identificador de la solicitud en la dirección, por ejemplo ?id=LAB-001.',
    )
  })

  it('treats a blank identifier as missing', () => {
    const wrapper = mountWithUrl('?id=%20')

    expect(wrapper.findComponent(ReviewStub).exists()).toBe(false)
  })
})

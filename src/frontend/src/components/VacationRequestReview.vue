<script setup lang="ts">
import { onMounted, ref } from 'vue'
import {
  getVacationRequest,
  rejectVacationRequest,
  type VacationRequest,
  type VacationRequestStatus,
} from '../api/vacationRequests'

const props = defineProps<{ requestId: string }>()

const statusLabels: Record<VacationRequestStatus, string> = {
  Pending: 'Pendiente',
  Rejected: 'Rechazada',
}
const unexpectedError = 'No se ha podido completar la operación. Inténtalo de nuevo.'

const loading = ref(true)
const request = ref<VacationRequest>()
const alertMessage = ref<string>()
const rejecting = ref(false)
const rejectedNow = ref(false)
const unknownOutcome = ref(false)

function notFoundMessage(): string {
  return `La solicitud ${props.requestId} no existe.`
}

async function load(): Promise<void> {
  loading.value = true
  alertMessage.value = undefined
  try {
    const result = await getVacationRequest(props.requestId)
    if (result.kind === 'ok') {
      request.value = result.request
      unknownOutcome.value = false
      return
    }
    request.value = undefined
    alertMessage.value = result.kind === 'not-found' ? notFoundMessage() : unexpectedError
  } finally {
    loading.value = false
  }
}

async function reject(): Promise<void> {
  rejecting.value = true
  alertMessage.value = undefined
  try {
    const result = await rejectVacationRequest(props.requestId)
    switch (result.kind) {
      case 'ok':
        request.value = result.request
        rejectedNow.value = true
        break
      case 'not-pending':
        await load()
        alertMessage.value = 'La solicitud no está pendiente y no se puede rechazar.'
        break
      case 'not-found':
        request.value = undefined
        alertMessage.value = notFoundMessage()
        break
      case 'error':
        unknownOutcome.value = true
        alertMessage.value = 'No se ha podido confirmar el rechazo. El resultado es desconocido.'
        break
    }
  } finally {
    rejecting.value = false
  }
}

onMounted(load)
</script>

<template>
  <section class="review">
    <p class="lab-notice" data-testid="lab-notice">
      Datos ficticios de laboratorio. Sin autenticación ni integración corporativa.
    </p>
    <h1>Revisar solicitud</h1>

    <p v-if="loading" role="status">Cargando solicitud…</p>
    <p v-if="alertMessage" role="alert" class="alert">{{ alertMessage }}</p>

    <dl v-if="request" class="details">
      <dt>Identificador</dt>
      <dd>{{ request.id }}</dd>
      <dt>Persona</dt>
      <dd>{{ request.personName }}</dd>
      <dt>Inicio</dt>
      <dd>{{ request.startDate }}</dd>
      <dt>Fin</dt>
      <dd>{{ request.endDate }}</dd>
      <dt>Estado</dt>
      <dd data-testid="status">{{ statusLabels[request.status] }}</dd>
    </dl>

    <p v-if="rejectedNow" role="status" data-testid="result">Solicitud rechazada.</p>

    <button
      v-if="request?.status === 'Pending' && !unknownOutcome"
      type="button"
      :disabled="rejecting"
      @click="reject"
    >
      {{ rejecting ? 'Rechazando…' : 'Rechazar solicitud' }}
    </button>
    <button v-if="unknownOutcome" type="button" :disabled="loading" @click="load">
      Comprobar estado
    </button>
  </section>
</template>

<style scoped>
.review {
  max-width: 40rem;
  margin: 0 auto;
  padding: 1.5rem;
  font-family: system-ui, sans-serif;
}
.lab-notice {
  padding: 0.5rem 0.75rem;
  border: 1px solid #d97706;
  background: #fffbeb;
  font-size: 0.875rem;
}
.alert {
  padding: 0.5rem 0.75rem;
  border: 1px solid #b91c1c;
  background: #fef2f2;
}
.details {
  display: grid;
  grid-template-columns: max-content 1fr;
  gap: 0.25rem 1rem;
}
.details dt {
  font-weight: 600;
}
button {
  min-height: 2.75rem;
  padding: 0 1.25rem;
  border: 1px solid #27272a;
  background: #27272a;
  color: #fff;
  cursor: pointer;
}
button:disabled {
  opacity: 0.6;
  cursor: progress;
}
</style>

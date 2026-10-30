<script setup lang="ts">
import VacationRequestReview from './components/VacationRequestReview.vue'

// Routing is not decided (PA-24); the request is selected through ?id= for this Bolt.
const requestId = new URLSearchParams(window.location.search).get('id')?.trim() ?? ''
</script>

<template>
  <main>
    <VacationRequestReview v-if="requestId" :request-id="requestId" />
    <p v-else role="alert">
      Indica el identificador de la solicitud en la dirección, por ejemplo ?id=LAB-001.
    </p>
  </main>
</template>

<template>
  <div class="timer-container" :class="{ running: isRunning }" @click.stop>
    <div class="time-display">
      <span>{{ String(minutes).padStart(2, '0') }}</span>
      <span>:</span>
      <span>{{ String(seconds).padStart(2, '0') }}</span>
    </div>
    <div class="controls" v-if="!isRunning && totalSeconds === 0">
      <span class="finished-text">Time's up!</span>
    </div>
    <div class="controls" v-else>
      <button @click="start" :disabled="isRunning">Start</button>
      <button @click="pause" :disabled="!isRunning">Pause</button>
      <button @click="reset">Reset</button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onUnmounted } from 'vue'
import { $slidev } from '@slidev/client/nav.ts'

const props = defineProps({
  startAtClick: {
    type: Number,
    required: true,
  },
})

const totalSeconds = ref(120)
const isRunning = ref(false)
let intervalId: ReturnType<typeof setInterval> | null = null

const start = () => {
  if (isRunning.value || totalSeconds.value <= 0) return
  isRunning.value = true
  intervalId = setInterval(() => {
    if (totalSeconds.value > 0) {
      totalSeconds.value--
    } else {
      pause()
    }
  }, 1000)
}

const pause = () => {
  isRunning.value = false
  if (intervalId) {
    clearInterval(intervalId)
    intervalId = null
  }
}

const reset = () => {
  pause()
  totalSeconds.value = 120
}

const minutes = computed(() => Math.floor(totalSeconds.value / 60))
const seconds = computed(() => totalSeconds.value % 60)

// This watcher will print every click change to the console.
watch(
  () => $slidev.nav.clicks,
  (newClickCount, oldClickCount) => {
    console.log(`DIAGNOSTIC: Click count changed from ${oldClickCount} to ${newClickCount}. Timer expects to start at click #${props.startAtClick}.`);
    if (newClickCount === props.startAtClick) {
      console.log('CONDITION MET: Starting timer!');
      start();
    }
  }
)

onUnmounted(pause)
</script>

<style scoped>
/* Styles are unchanged from the version with buttons */
.timer-container {
  text-align: center; background-color: rgba(34, 34, 34, 0.9); color: white; padding: 2rem; border-radius: 15px;
  width: fit-content; margin: 2rem auto; border: 1px solid rgba(255, 255, 255, 0.2); transition: all 0.3s ease;
  position: relative; z-index: 100;
}
.timer-container.running {
  border-color: rgba(110, 231, 183, 0.7); box-shadow: 0 0 25px 5px rgba(52, 211, 153, 0.4);
}
.time-display { font-size: 5rem; font-family: 'Courier New', Courier, monospace; font-weight: bold; margin-bottom: 1rem; }
.controls { height: 50px; } /* Give controls a fixed height to prevent layout shift */
.controls button {
  font-size: 1.2rem; margin: 0 10px; padding: 10px 20px; border-radius: 8px; border: none; cursor: pointer;
  background-color: #444; color: white; transition: all 0.1s ease; pointer-events: auto !important;
}
.controls button:disabled { opacity: 0.5; cursor: not-allowed; }
.controls button:not(:disabled):hover { background-color: #666; }
.controls button:not(:disabled):active { background-color: #888; transform: scale(0.97); }
.finished-text { color: #f87171; font-size: 1.5rem; margin-top: 0.5rem; }
</style>

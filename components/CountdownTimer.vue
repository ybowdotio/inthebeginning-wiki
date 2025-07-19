<template>
  <div class="timer-container">
    <div class="time-display">
      <span>{{ String(minutes).padStart(2, '0') }}</span>
      <span>:</span>
      <span>{{ String(seconds).padStart(2, '0') }}</span>
    </div>
    <div class="controls">
      <button @click="start" :disabled="isRunning">Start</button>
      <button @click="pause" :disabled="!isRunning">Pause</button>
      <button @click="reset">Reset</button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onUnmounted } from 'vue'

const props = defineProps({
  duration: { type: Number, default: 5 },
})

const totalSeconds = ref(props.duration * 60)
const isRunning = ref(false)
let intervalId: any = null

const start = () => {
  if (isRunning.value || totalSeconds.value === 0) return
  isRunning.value = true
  intervalId = setInterval(() => {
    if (totalSeconds.value > 0) {
      totalSeconds.value--
    } else {
      pause()
      new Audio('https://www.online-stopwatch.com/sound/finish-sound.mp3').play()
    }
  }, 1000)
}

const pause = () => {
  isRunning.value = false
  clearInterval(intervalId)
}

const reset = () => {
  pause()
  totalSeconds.value = props.duration * 60
}

const minutes = computed(() => Math.floor(totalSeconds.value / 60))
const seconds = computed(() => totalSeconds.value % 60)

onUnmounted(() => {
  clearInterval(intervalId)
})
</script>

<style scoped>
.timer-container {
  text-align: center;
  background-color: rgba(34, 34, 34, 0.8);
  color: white;
  padding: 2rem;
  border-radius: 15px;
  width: fit-content;
  margin: 2rem auto;
  border: 1px solid rgba(255, 255, 255, 0.2);
}
.time-display {
  font-size: 5rem;
  font-family: 'Courier New', Courier, monospace;
  font-weight: bold;
  margin-bottom: 1rem;
}
.controls button {
  font-size: 1.2rem;
  margin: 0 10px;
  padding: 10px 20px;
  border-radius: 8px;
  border: none;
  cursor: pointer;
  background-color: #444;
  color: white;
}
</style>


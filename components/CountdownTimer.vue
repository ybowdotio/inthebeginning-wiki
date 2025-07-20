<template>
  <div class="timer-container" :class="{ running: isRunning }">
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
import { ref, computed, onUnmounted, watch } from 'vue'

const props = defineProps({
  duration: { type: Number, default: 2 },
})

const totalSeconds = ref(0)
const isRunning = ref(false)
let intervalId: ReturnType<typeof setInterval> | null = null

// Use a 'watcher' to robustly sync the timer's state with the passed-in duration.
// The { immediate: true } option ensures this runs once as soon as the component is created.
watch(() => props.duration, (newDuration) => {
  if (isRunning.value) {
    pause();
  }
  totalSeconds.value = newDuration * 60;
}, { immediate: true });

const start = () => {
  if (isRunning.value || totalSeconds.value <= 0) return;
  isRunning.value = true;
  intervalId = setInterval(() => {
    if (totalSeconds.value > 0) {
      totalSeconds.value--;
    } else {
      pause();
      // Play a sound when finished, with error handling
      const audio = new Audio('https://www.online-stopwatch.com/sound/finish-sound.mp3');
      audio.play().catch(e => console.error("Error playing sound:", e));
    }
  }, 1000);
}

const pause = () => {
  isRunning.value = false;
  if (intervalId) {
    clearInterval(intervalId);
    intervalId = null;
  }
}

const reset = () => {
  pause();
  totalSeconds.value = props.duration * 60;
}

const minutes = computed(() => Math.floor(totalSeconds.value / 60))
const seconds = computed(() => totalSeconds.value % 60)

// Ensure the timer is always cleaned up when the slide changes
onUnmounted(() => {
  pause();
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
  transition: all 0.3s ease;
}

/* NEW: This class will be added when the timer is running */
.timer-container.running {
  border-color: rgba(110, 231, 183, 0.7);
  box-shadow: 0 0 25px 5px rgba(52, 211, 153, 0.4);
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
.controls button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
</style>

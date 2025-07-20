<template>
  <div class="timer-container" @click.stop>
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
import { ref, computed, onUnmounted, watch, onMounted } from 'vue'

const props = defineProps({
  duration: { type: Number, default: 2 },
})

const totalSeconds = ref(0)
const isRunning = ref(false)
let intervalId: ReturnType<typeof setInterval> | null = null

// --- DIAGNOSTIC LOGS ---

onMounted(() => {
  console.log('LIFECYCLE: Component has been mounted.');
});

onUnmounted(() => {
  console.log('LIFECYCLE: Component is unmounting, calling pause().');
  pause();
})

watch(() => props.duration, (newDuration) => {
  console.log('WATCHER: Watcher is now running.');
  if (isRunning.value) {
    console.log('WATCHER: isRunning is true, calling pause().');
    pause();
  }
  totalSeconds.value = newDuration * 60;
}, { immediate: true });

// --- CORE FUNCTIONS ---

const start = () => {
  console.log('CLICK: Start button clicked.');
  if (isRunning.value || totalSeconds.value <= 0) return;
  isRunning.value = true;
  intervalId = setInterval(() => {
    if (totalSeconds.value > 0) {
      totalSeconds.value--;
    } else {
      pause();
      const audio = new Audio('https://www.online-stopwatch.com/sound/finish-sound.mp3');
      audio.play().catch(e => console.error("Error playing sound:", e));
    }
  }, 1000);
}

const pause = () => {
  console.log('ACTION: pause() function was executed.');
  isRunning.value = false;
  if (intervalId) {
    clearInterval(intervalId);
    intervalId = null;
  }
}

const reset = () => {
  console.log('CLICK: Reset button clicked, calling pause().');
  pause();
  totalSeconds.value = props.duration * 60;
}

const minutes = computed(() => Math.floor(totalSeconds.value / 60))
const seconds = computed(() => totalSeconds.value % 60)

</script>

<style scoped>
/* Styles are unchanged, you can leave them as they were */
.timer-container {
  text-align: center;
  background-color: rgba(34, 34, 34, 0.9);
  color: white;
  padding: 2rem;
  border-radius: 15px;
  width: fit-content;
  margin: 2rem auto;
  border: 1px solid rgba(255, 255, 255, 0.2);
  transition: all 0.3s ease;
  position: relative;
  z-index: 100;
}
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
  transition: all 0.1s ease;
  pointer-events: auto !important;
}
.controls button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
.controls button:not(:disabled):hover {
  background-color: #666;
}
.controls button:not(:disabled):active {
  background-color: #888;
  transform: scale(0.97);
}
</style>

<template>
  <div class="slidev-layout verse">
    <div class="my-auto w-full">
      <h2 class="verse-title">Memory Verse</h2>
      <slot />
    </div>
  </div>
</template>

<style>
.slidev-layout.verse {
  background-color: #1e293b; /* A nice dark blue */
  color: #cbd5e1;
  text-align: center;
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 2rem;
}
.verse-title {
  font-weight: 300;
  text-transform: uppercase;
  letter-spacing: 0.2em;
  font-size: 1.5rem;
  margin-bottom: 2rem;
}
.slidev-layout.verse blockquote {
  font-size: 2.5rem;
  font-style: italic;
  font-weight: 500;
  line-height: 1.4;
  border: none;
  color: white;
}
.slidev-layout.verse blockquote footer {
  font-size: 1.5rem;
  font-style: normal;
  margin-top: 1.5rem;
  color: #94a3b8;
}
</style>

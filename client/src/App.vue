<template>
  <nav>
    <div class="bg-white mb-4 p-2">
      <router-link class="m-3 fl" to="/">Home</router-link>
      <router-link class="m-3" to="/overview">Car Overview</router-link>
      <router-link class="m-3" to="/addToBalance">Balance</router-link>
    </div>
  </nav>
  <router-view/>
</template>

<style>
</style>

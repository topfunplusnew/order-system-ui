<script>
export default {
  name: "Item",
  data() {
    return {
      name: ''
    }
  },
  props: {
    title: {
      type: String,
    }
  },
  created() {
    console.log('Item::attrs', this.$attrs.name);
    console.log('created::Item::props', this.$props);
  },
  mounted() {
    console.log('mounted::Item::props', this.$props);
  },
  methods: {},
  watch: {

  },
  computed: {},
  filters: {},
  provide() {
    return {}
  },
}
</script>

<template>
  <div>
    <h1>
      {{ title }}
    </h1>
  </div>
</template>

<style scoped lang="scss">

</style>

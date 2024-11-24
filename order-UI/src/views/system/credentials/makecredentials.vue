<script>
  import SubjectOption from '../../../components/SubjectOption.vue';
  import CrendentMake from '../../dashboard/components/voucher/CrendentMake.vue';

  export default {
    name: 'Makecredentials',
    components: { CrendentMake, SubjectOption },
    data() {
      return {}
    },
    methods: {}
  }
</script>

<template>
  <div>
    <div style="margin: 19px 19px">
      <CrendentMake />
    </div>
  </div>
</template>

<style scoped lang="scss">

</style>

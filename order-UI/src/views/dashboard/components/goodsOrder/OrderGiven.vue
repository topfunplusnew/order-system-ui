<template>
  <div>
    <el-row>
      <!--      发货单1-->
      <ChatForm v-if="givenType === 1" :order-info="orderGivenInfo" />
      <!--      发货单2-->
      <ChatForm2 v-if="givenType === 2" :order-info="orderGivenInfo" />
      <!--      发货单3-->
      <ChatForm3 v-if="givenType===3" :order-info="orderGivenInfo" />
    </el-row>
  </div>
</template>
<script>
  import ChatForm from '@/views/dashboard/components/goodsOrder/ChatForm.vue'
  import ChatForm2 from '@/views/dashboard/components/goodsOrder/ChatForm2.vue';
  import ChatForm3 from '@/views/dashboard/components/goodsOrder/ChatForm3.vue';

  export default {
    name: 'OrderGiven',
    components: { ChatForm3, ChatForm2, ChatForm },
    props: {
      Order1Visible: {},
      // 发货的类型
      type: {
        type: Number,
      },
      // 发货单相关订单的信息
      orderGivenInfo: {
        type: Object
      }
    },
    computed: {
      givenType() {
        return this.type
      }
    },
    methods: {
      handleProcess() {

      },
      handleReject() {

      },
    }
  }
</script>

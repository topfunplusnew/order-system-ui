import { ref } from 'vue'
import { layer } from '@layui/layui-vue'
import { AxiosPromise } from 'axios'

//表单Hook
export function usePopForm(action: () => AxiosPromise) {
  const visiblePop = ref(false)
  const modelPop = ref({})
  const actionPop = ref([
    {
      text: '确认',
      //这里发送请求 更改数据库信息
      callback: () => {
        layer.confirm('确定要这样操作吗', {
          btn: [
            {
              text: '确认',
              callback: (id) => {
                layer.msg('确定')
                action()
                layer.close(id)
              },
            },
            {
              text: '取消',
              callback: (id) => {
                layer.msg('取消')
                layer.close(id)
              },
            },
          ],
        })
      },
    },
    {
      text: '取消',
      callback: () => {
        layer.confirm('操作取消', {
          btn: [
            {
              text: '确认',
              callback: (id) => {
                layer.msg('确定')
                layer.close(id)
              },
            },
            {
              text: '取消',
              callback: (id) => {
                layer.msg('取消')
                layer.close(id)
              },
            },
          ],
        })
      },
    },
  ])

  return {
    visiblePop,
    actionPop,
    modelPop,
  }
}

export function useAddForm(action: () => AxiosPromise) {
  const visibleAdd = ref(false)
  const modelAdd = ref({})
  const actionAdd = ref([
    {
      text: '确认',
      //这里发送请求 更改数据库信息
      callback: () => {
        layer.confirm('确定要这样操作吗', {
          btn: [
            {
              text: '确认',
              callback: (id) => {
                layer.msg('确定')
                action()
                layer.close(id)
              },
            },
            {
              text: '取消',
              callback: (id) => {
                layer.msg('取消')
                layer.close(id)
              },
            },
          ],
        })
      },
    },
    {
      text: '取消',
      callback: () => {
        layer.confirm('操作取消', {
          btn: [
            {
              text: '确认',
              callback: (id) => {
                layer.msg('确定')
                layer.close(id)
              },
            },
            {
              text: '取消',
              callback: (id) => {
                layer.msg('取消')
                layer.close(id)
              },
            },
          ],
        })
      },
    },
  ])
  return {
    visibleAdd,
    modelAdd,
    actionAdd,
  }
}

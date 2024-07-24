import { ref } from 'vue'

//测试hooks
export function useGetWidth(): {} {
  const data = ref({
    width: 0,
    height: 0,
  })

  const getWidthAndHeight = () => {
    data.value.width = document.body.clientWidth
    data.value.height = document.body.clientHeight
  }

  return {
    data,
    getWidthAndHeight,
  }
}

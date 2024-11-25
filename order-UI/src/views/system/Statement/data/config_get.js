import { Message } from 'element-ui'
import { listConfig } from '../../../../api/system/config'
import { listSubject } from '../../../../api/system/subject'
/**
 * 查询科目名称
 * @param {any} key
 * @returns {any}
 */
export async function getConfigValue(key) {
  try {
    // 查询配置
    const res = await listConfig(key)
    const data = res.rows || res.data

    // 校验配置数据
    if (!data) {
      Message.error('配置参数不存在')
      throw new Error('配置参数不存在')
    }

    const configValue = data[0].configValue
    const body = { subjectNo: configValue }

    // 查询科目
    const subjectRes = await listSubject(body)
    const result = subjectRes.data || subjectRes.rows
    const total = subjectRes.total

    // 校验科目数据
    if (total <= 0 || typeof result !== 'object') {
      Message.error('科目不存在')
      throw new Error('科目不存在')
    }

    // 返回科目名称和配置值
    return {
      subjectName: result[0].title,
      configValue
    }
  } catch (error) {
    console.error(error)
    return Promise.reject(error.message || '获取配置失败')
  }
}

import { PAGE_CONFIG } from '../config';
/**
 * ${root.nameZh}
 *
 */
export const NAME_SPACE = PAGE_CONFIG.namespace;
/**
 * 初始化list
 */
export const initList = () => {
  return { 
    type: `<#noparse>${NAME_SPACE}</#noparse>/initList`
  }
}
/**
 * 获取列表
 * @param {*} payload 
 */
export const getList = (payload) => {
  return { 
    type: `<#noparse>${NAME_SPACE}</#noparse>/getList`,
    payload
  }
}
/**
 * 获取
 * @param {*} payload 
 */
export const get = (payload) => {
  return { 
    type: `<#noparse>${NAME_SPACE}</#noparse>/get`,
    payload
  }
}
/**
 * 保存
 * @param {*} payload 
 */
export const save = (payload) =>{
  return{
    type: `<#noparse>${NAME_SPACE}</#noparse>/save`,
    payload
  }
}
/**
 * 更新
 * @param {*} payload 
 */
export const update = (payload) =>{
  return{
    type: `<#noparse>${NAME_SPACE}</#noparse>/update`,
    payload
  }
}

/**
 * 删除
 * @param {*} payload 
 */
export const remove = (payload) =>{
  return{
    type: `<#noparse>${NAME_SPACE}</#noparse>/remove`,
    payload
  }
}
/**
 * 清理
 */
export const clear = () =>{
  return{
    type: `<#noparse>${NAME_SPACE}</#noparse>/clear`
  }
}
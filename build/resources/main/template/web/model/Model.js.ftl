import modelEnhance from '@/utils/modelEnhance';
import PageHelper from '@/utils/pageHelper';
import _ from 'lodash'
import { PAGE_CONFIG } from '../config';

const apiBaseUri = PAGE_CONFIG.apiBaseUri;
const namespace = PAGE_CONFIG.namespace;

/**
 * ${root.nameZh}
 *
 */

export default modelEnhance({
  namespace: namespace,

  state: {
    pageData: PageHelper.create(),
    data:{},
    select:[],
  },

  subscriptions: {
    setup({ dispatch, history }) {
      history.listen(({ pathname }) => {
      });
    }
  },

  effects: {
    /**
     * 初始化
     * @param {*} param0 
     * @param {*} param1 
     */
    *initList({ payload }, { call, put, select }) {
      const { pageData } = yield select(state => state[namespace]);
      yield put({
        type: 'getList',
        payload: {
          pageData: pageData.startPage(1, 10)
        }
      });
    },
    /**
     * 获取列表数据
     * @param {*} param0 
     * @param {*} param1 
     */
    *getList({ payload }, { call, put }) {
      const { pageData } = payload;
      yield put.resolve({
        type: '@request',
        payload: {
          valueField: 'pageData',
          url: `/<#noparse>${apiBaseUri}</#noparse>`,
          method: 'GET', 
          pageInfo: pageData
        }
      });
    },
    /**
     * 获取
     * @param {*} param0 
     * @param {*} param1 
     */
    *get({ payload }, { call, put }) {
      const { id } = payload;
      yield put.resolve({
        type: '@request',
        payload: {
          valueField: 'data',
          url: `/<#noparse>${apiBaseUri}</#noparse>/<#noparse>${id}</#noparse>`,
          method: 'GET', 
        }
      });
    },
    
    /**
     * 保存
     * @param {*} param0 
     * @param {*} param1 
     */
    *save({ payload }, { call, put, select,take }) {
      const { value, success } = payload;
      const { pageData } = yield select(state => state[namespace]);
      yield put.resolve({
        type: '@request',
        payload: {
          notice: true,
          url: `/<#noparse>${apiBaseUri}</#noparse>`,
          data: value
        }
      });
      yield put({
        type: 'getList',
        payload: { pageData }
      });
      success();
    },
    /**
     * 修改
     * @param {*} param0 
     * @param {*} param1 
     */
    *update({ payload }, { call, put, select,take }) {
      const { value, success } = payload;
      const { pageData } = yield select(state => state[namespace]);
      yield put.resolve({
        type: '@request',
        payload: {
          method: 'PUT',
          notice: true,
          url: `/<#noparse>${apiBaseUri}</#noparse>`,
          data: value
        }
      });
      yield put({
        type: 'getList',
        payload: { pageData }
      });
      success();
    },
    /**
     * 删除
     * @param {*} param0 
     * @param {*} param1 
     */
    *remove({ payload }, { call,take , put, select }) {
      const { records, success } = payload;
      const { pageData } = yield select(state => state[namespace]);
      yield put.resolve({
        type: '@request',
        payload: {
          method: 'DELETE',
          notice: true,
          url: `/<#noparse>${apiBaseUri}</#noparse>`,
          data: records.map(item => item.rowKey)
        }
      });
      yield put({
        type: 'getList',
        payload: { pageData }
      });
      success();
    },
  },
  reducers: {
    clear(state){
      return {
        ...state,
        data:{},
      }
    },
  }
})
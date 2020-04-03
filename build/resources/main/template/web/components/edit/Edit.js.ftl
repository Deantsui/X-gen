<#function camelToMid(s)>
    <#return s
    <#-- "fooBar" to "foo_bar": -->
    ?replace('([a-z])([A-Z])', '$1-$2', 'r')
    <#-- "FOOBar" to "FOO_Bar": -->
    ?replace('([A-Z])([A-Z][a-z])', '$1-$2', 'r')
    <#-- All of those to "FOO_BAR": -->
    ?lower_case
    >
</#function>
import React from 'react';
import { connect } from 'dva';
import { Layout, Button, Card, PageHeader } from 'antd';
import BaseComponent from 'components/BaseComponent';
import Form from 'components/Form';
import PageLoading from 'components/Loading/PageLoading';
import './Edit.less';
import * as action from '../../action/Action';
import { PAGE_CONFIG } from '../../config';

const { Content, Header } = Layout;

const { namespace } = PAGE_CONFIG;
const { sourceName } = PAGE_CONFIG;
// const { idKey } = PAGE_CONFIG;
// const { pathBase } = PAGE_CONFIG;

/**
 * ${root.nameZh} 编辑
 */
@connect(props => ({
  modelData: props[namespace],
  loading: props.loading.effects[`<#noparse>${action.NAME_SPACE}/get</#noparse>`],
  saveLoading: props.loading.effects[`<#noparse>${action.NAME_SPACE}/save</#noparse>`]
}))
export default class extends BaseComponent {
  // 表单
  createColumns = self => [
          <#list root.fieldPos as fieldPo>
              <#if (fieldPo.editShow)>
    {
      title:'${fieldPo.nameZh}',
      name:'${fieldPo.name}',
      formItem:{
        col:{span:12},
        rules:[
          <#if (fieldPo.required)>
          {
            required:true,
            message:'请输入${fieldPo.nameZh}'
          },
          </#if>
        ]
      }
    },
              </#if>
          </#list>
  ];
  state = {
    /**
     * 记录
     */
    record: null
  };
  componentDidMount() {
    // 获取路由中状态
    const {
      dispatch,
      history: {
        location: { state }
      }
    } = this.props;
    // 获取路由中的用户id，并请求次用户数据
    if (state) {
      const id = state.id;
      this.setState({
        record: { id }
      });
      dispatch(action.get({ id }));
    }
  }
  componentWillUnmount() {
    const { dispatch } = this.props;
    dispatch(action.clear());
  }

  /**
   * 保存
   */
  handlerSave(value) {
    const { dispatch, history } = this.props;
    dispatch(
      action.save({
        value,
        success: () => {
          this.setState({
            record: null
          });
          history.goBack();
        }
      })
    );
  }
  /**
   * 更新
   */
  handlerUpdate(value) {
    const { dispatch, history } = this.props;
    dispatch(
      action.update({
        value,
        success: () => {
          this.setState({
            record: null
          });
          history.goBack();
        }
      })
    );
  }

  render() {
    const columns = this.createColumns(this);
    const { loading, saveLoading, history } = this.props;
    const { data } = this.props.modelData;
    let { record } = this.state;
    const title = record ? `<#noparse>${sourceName}</#noparse>编辑` : `<#noparse>${sourceName}</#noparse>新增`;

    /**
     * 新增、修改都会进到这个方法中，
     * 可以使用主键或是否有record来区分状态
     */
    const onSubmit = () => {
      this.refs.form.validateFields((error, value) => {
        if (error) {
          console.warn(error);
          return;
        }
        value = {
          ...value,
          parent: value.parent || { code: value.parent }
        };
        if (record) {
          this.handlerUpdate({
            id: record.id,
            ...value
          });
        } else {
          this.handlerSave(value);
        }
      });
    };
    /**
     * 头部组件
     */
    const headerTools = (
      <div>
        <PageHeader
          ghost={false}
          title={title}
          onBack={() => history.goBack()}
          extra={[
            <Button
              key="1"
              type="primary"
              loading={saveLoading}
              onClick={onSubmit}
            >
              {record?'更新':'新建'}
            </Button>
          ]}
        ></PageHeader>
      </div>
    );
    const formProps = {
      ref: 'form',
      columns,
      onSubmit,
      record: data,
      footer: false,
      formItemLayout: {
        // labelCol: { span: 4 },
        wrapperCol: { span: 24 }
      }
    };
    /**
     * 渲染
     */
    return (
      <Layout className="full-layout ${camelToMid(root.name)}-edit">
        <Header className="header">{headerTools}</Header>
        <Content className="content">
          <PageLoading loading={loading}>
            <Card title="基本信息" className="card">
              <Form {...formProps} />
            </Card>
          </PageLoading>
        </Content>
      </Layout>
    );
  }
}

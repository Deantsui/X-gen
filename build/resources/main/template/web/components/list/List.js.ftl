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
import { Layout, Button, PageHeader, Col } from 'antd';
import BaseComponent from 'components/BaseComponent';
import Toolbar from 'components/Toolbar';
import Icon from 'components/Icon';
import DataTable from 'components/DataTable';
import { Link } from 'dva/router';
import SearchBar from 'components/SearchBar';
import { PAGE_CONFIG } from '../../config';

import * as action from '../../action/Action';

import './List.less';
import _ from 'lodash';

const { Content, Header, Footer } = Layout;
const Pagination = DataTable.Pagination;

const { pathBase } = PAGE_CONFIG;
const { namespace } = PAGE_CONFIG;
const { sourceName } = PAGE_CONFIG;
const { idKey } = PAGE_CONFIG;

/**
 * ${root.nameZh}
 *
 */
@connect(props => ({
  modelData: props[namespace],
  loading: props.loading.effects[`<#noparse>${namespace}/getList</#noparse>`]
}))
export default class extends BaseComponent {
  /**
   * 列
   */
  createColumns(self) {
    return [
    <#list root.fieldPos as fieldPo>
      <#if (fieldPo.listShow)>
      {
        title: '${fieldPo.nameZh}',
        name: '${fieldPo.name}',
        tableItem: {},
      },
      </#if>
    </#list>
      {
        title: '操作',
        tableItem: {
          width: 180,
          render: (text, record) => (
            <DataTable.Oper>
              <Button tooltip="修改">
                <Link
                  to={{
                    pathname: <#noparse>`/${pathBase}/edit`,</#noparse>
                    state: { id: record[idKey] }
                  }}
                >
                  <Icon type="edit" />
                </Link>
              </Button>
              <Button tooltip="删除" onClick={e => self.onDelete(record)}>
                <Icon type="trash" />
              </Button>
            </DataTable.Oper>
          )
        }
      }
    ];
  }
  
  state = {
    /**
     * 选中的行
     */
    rows: []
  };

  componentDidMount() {
    const { dispatch } = this.props;
    dispatch(action.initList());
  }
  
  /**
   * 删除处理
   */
  handleDelete = records => {
    const { rows } = this.state;

    this.props.dispatch(
      action.remove({
        records,
        success: () => {
          // 如果操作成功，在已选择的行中，排除删除的行
          this.setState({
            rows: rows.filter(
              item => !records.some(jtem => jtem.rowKey === item.rowKey)
            )
          });
        }
      })
    );
  };
  /**
   * 搜索处理
   */
  handleSearch = values => {
    const { dispatch, modelData } = this.props;
    const pageData = modelData.pageData;
    dispatch(
      action.getList({
        pageData: pageData.filter(values).jumpPage(1, 10)
      })
    );
  };
  /**
   * 分页改变处理
   */
  handleChange = ({ pageNum, pageSize }) => {
    const { dispatch, modelData } = this.props;
    const pageData = modelData.pageData;

    dispatch(
      action.getList({
        pageData: pageData.jumpPage(pageNum, pageSize)
      })
    );
  };

  render() {
    const { loading, history, modelData } = this.props;

    const pageData = modelData.pageData;
    const columns = this.createColumns(this);
    const { rows } = this.state;
    const searchBarProps = {
      columns,
      onSearch: this.handleSearch
    };
    /**
     * 头部工具栏
     */
    const PageToolbar = (
      <PageHeader
        ghost={false}
        title={`<#noparse>${sourceName}</#noparse>列表`}
        extra={[
          <Button.Group key="topbuttons">
            <Button
              type="primary"
              icon="plus"
              onClick={() => history.push(`/<#noparse>${pathBase}</#noparse>/edit`)}
            >
              新增
            </Button>
            <Button
              disabled={!rows.length}
              onClick={e => this.onDelete(rows)}
              icon="delete"
            >
              删除
            </Button>
          </Button.Group>
        ]}
      >
        <Col>
          <SearchBar group="abc" {...searchBarProps} />
        </Col>
      </PageHeader>
    );

    /**
     * List渲染参数
     */
    const dataTableProps = {
      loading: loading,
      columns,
      rowKey: idKey,
      dataItems: pageData,
      bordered: true,
      selectType: 'checkbox',
      showNum: true,
      isScroll: true,
      selectedRowKeys: rows.map(item => item.rowKey),
      onChange: this.handleChange,
      onSelect: (keys, rows) => this.setState({ rows })
    };

    return (
      <Layout className="full-layout ${camelToMid(root.name)}-list">
        <Header>{PageToolbar}</Header>
        <Content>
          <DataTable {...dataTableProps} />
        </Content>
        <Footer>
          <Pagination {...dataTableProps} />
        </Footer>
      </Layout>
    );
  }
}

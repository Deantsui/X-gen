<#function camelToDashed(s)>
    <#return s
    <#-- "fooBar" to "foo_bar": -->
    ?replace('([a-z])([A-Z])', '$1_$2', 'r')
    <#-- "FOOBar" to "FOO_Bar": -->
    ?replace('([A-Z])([A-Z][a-z])', '$1_$2', 'r')
    <#-- All of those to "FOO_BAR": -->
    ?lower_case
    >
</#function>
/**
 * ${root.nameZh} 模块基本配置
 *
 */
export  const PAGE_CONFIG ={
  // 相对路径
  pathBase : '${camelToDashed(root.name)}',
  // 模块名称
  sourceName:'${root.nameZh}',
  //主键key
  idKey:'${root.pk}',
  // Model命名空间
  namespace:'${camelToDashed(root.name)}',
  // api接口资源基地址。如“/api/test/xxx”的资源基地址为”test“
  apiBaseUri:'${camelToDashed(root.name)}',
}

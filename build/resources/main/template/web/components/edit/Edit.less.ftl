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
// 页面样式
.${camelToMid(root.name)}-edit {
  
  .content {
    padding: 10px 21px;

  }
  
}

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
const localMenu=
[
    {
      name: '生成模块',
      icon: 'bulb',
      path: '/gen',
      children: [
<#list root as item>
        {
          name: '${item.nameZh}',
          path: '/${camelToDashed(item.name)}/:detail?',
        },
</#list>
      ]
    },
]
<#list root as item>
import ${item.name} from './${item.name}';
</#list>

{
    path: '/',
    title: '系统中心',
    component: BasicLayout,
    indexRoute: '/dashboard',
    childRoutes: [
      <#list root as item>
              ${item.name}(app),
      </#list>
    ]
}
import { dynamicWrapper, createRoute } from '@/utils/core';
import EmptyLayout from '@/layouts/EmptyLayout';
import { PAGE_CONFIG } from './config';
/**
 * ${root.nameZh}
 *
 */
const routesConfig = app => ({
  path: `/<#noparse>${PAGE_CONFIG.pathBase}</#noparse>`,
  title: `<#noparse>${PAGE_CONFIG.sourceName}</#noparse>`,
  indexRoute: `/<#noparse>${PAGE_CONFIG.pathBase}</#noparse>/list`,
  component: EmptyLayout,
  childRoutes: [ListApp(app), EditApp(app)]
});

const ListApp = app =>
  createRoute(app, app => ({
    path: `/<#noparse>${PAGE_CONFIG.pathBase}</#noparse>/list`,
    title: `<#noparse>${PAGE_CONFIG.sourceName}</#noparse>`,
    component: dynamicWrapper(app, [import('./model/Model')], () =>
      import('./components/list/List')
    )
  }));
const EditApp = app =>
  createRoute(app, app => ({
    path: `/<#noparse>${PAGE_CONFIG.pathBase}</#noparse>/edit`,
    title: `<#noparse>${PAGE_CONFIG.sourceName}</#noparse>编辑`,
    component: dynamicWrapper(app, [import('./model/Model')], () =>
      import('./components/edit/Edit')
    )
  }));

export default app => createRoute(app, routesConfig);

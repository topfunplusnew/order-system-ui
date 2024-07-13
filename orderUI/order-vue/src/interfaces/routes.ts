//路由规则类型 对应数据库的列
export interface RoutesRuleInfo {
    menu_id: number,
    menu_name: string,
    path: string,   //请求路径
    redirect?: string,  //是否重定向
    component: object,
    parent_id: number, //父菜单id
    order_num: number,//显示顺序 用于排序
    query?: string, //路由参数
    menu_type: string, //菜单类型 M目录 C菜单 F按钮
    visible: string,//菜单状态 0显示 1隐藏
    status: string,//菜单状态 0显示 1隐藏
    perms: string,//权限标识
    icon?: string //菜单图标
}

//路由信息
// export interface RoutesInfo {
//     path: string,
//     name?: string,
//     meta?: object,
//     redirect?: string,
//     component?: object,
//     children?: []
// }

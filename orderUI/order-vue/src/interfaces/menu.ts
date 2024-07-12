//菜单
export interface MenuInfo {
    id: number,
    title: string,
    children: [],
    closable: boolean,
    open: boolean,
    path: string,
    component: object
}

<template>
    <div>
        <lay-header>
            <lay-row>
                <lay-col md="20" sm="20" xs="20">
                    <div class="grid-demo">
                        <lay-row space="5">
                            <lay-col style="width:200px;float: left"><h1>订单管理</h1>
                            </lay-col>
                            <!--  切换状态-->
                            <lay-col class="buttons">
                                <slot></slot>
                            </lay-col>
                            <lay-col class="buttons">
                                <lay-button type="normal">
                                    <lay-icon type="layui-icon-screen-full"></lay-icon>
                                </lay-button>
                            </lay-col>
                        </lay-row>
                    </div>
                </lay-col>
                <lay-col md="4" sm="4" xs="4" class="self">
                    <div class="grid-demo">
                        <lay-dropdown updateAtScroll style="float: right;margin-top:10px;margin-right: 3px">
                            <lay-button type="primary">
                                <lay-icon type="layui-icon-friends"></lay-icon>
                                admin，欢迎您~
                                <lay-icon type="layui-icon-down"></lay-icon>
                            </lay-button>
                            <template #content>
                                <lay-dropdown-menu>
                                    <lay-dropdown-menu-item>
                                        <template #prefix>
                                            <lay-icon type="layui-icon-logout"></lay-icon>
                                        </template>
                                        <template #default>退出登录</template>
                                    </lay-dropdown-menu-item>
                                </lay-dropdown-menu>
                            </template>
                        </lay-dropdown>
                    </div>
                </lay-col>
            </lay-row>
        </lay-header>
    </div>
</template>

<script setup lang="ts">

</script>

<style scoped>
.layui-header {
    line-height: 60px;
    text-align: center;
    background: white;
    color: black;
}

.grid-demo {
    line-height: 60px;
    text-align: center;
    background-color: white;
    color: black;
}

.buttons {
    float: left;
}

.self {
    float: right;
}

@media screen and (max-width: 380px) {
    .buttons {
        float: left;
        display: none;
    }
}

@media screen and (max-width: 227px) {
    .buttons {
        float: left;
        display: none;
    }

    .self {
        display: none;
    }
}
</style>

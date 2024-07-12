<template>
    <div>
        <lay-header>
            <lay-row space="10">
                <lay-col md="20" sm="20" xs="20">
                    <div class="grid-demo">
                        <lay-row space="10">
                            <lay-col style="background-color: red;width:200px;float: left"><h1>订单管理</h1>
                            </lay-col>
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
                    <div class="grid-demo">2</div>
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
    background: #87ca9a;
    color: white;
}

.grid-demo {
    line-height: 50px;
    border-radius: 2px;
    text-align: center;
    background-color: var(--global-checked-color);
    color: #fff;
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

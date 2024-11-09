<script>
export default {
  name: "FileItems",
  props: {
    fileName: {
      type: String,
      default: "无名称"
    }
  },
  data() {
    return {
      show: false,
    }
  },
  computed: {
    _fileName() {
      return this.fileName
    }
  },
  methods: {
    // 点击某一个文件
    handleCheckFile(item) {
      window.open(item)
    },

    // 点击删除文件
    handleDeleteFile() {
      this.$emit('handleFile', this.fileName)
    }
  }
}
</script>

<template>
  <div>

    <div class="file-container" @mouseover="show = true" @mouseleave="show = false" >

      <div class="file-icon">
        <el-icon class="el-icon-document">
        </el-icon>
      </div>

      <div class="file-name" @click="handleCheckFile(fileName)">
        {{ _fileName }}...
      </div>

      <div class="options" v-show="show">
        <el-button type="danger" size="mini" round @click="handleDeleteFile">删除</el-button>
      </div>

    </div>
  </div>

</template>

<style scoped lang="scss">
.file-container {
  margin: 0 4px;
  width: 98px;
  height: 98px;
  background-color: #f7f2f8;
  border-radius: 15px;
  display: flex;
  justify-content: center;
  flex-direction: column;
  box-shadow: 0px 0px 5px 0px rgba(0, 0, 0, 0.25);
  text-align: center;

  &:hover {
    cursor: pointer;
    background-color: #e6e6e6;
    transition: all 0.7s ease-in-out;
    box-shadow: 0px 0px 10px 0px rgba(0, 0, 0, 0.45);
  }

  .file-icon {
    font-size: 27px;
    color: #171717;
  }

  .file-name {
    text-align: center;
    font-weight: bold;
    font-size: 14px;
    text-overflow: ellipsis;
    white-space: nowrap;
    overflow: hidden;

  }

  .file-name:hover {
    transition: all 0.3s ease-in-out;
    color: #c31212;
  }

  .options {
    margin: 10px;
  }

}
</style>

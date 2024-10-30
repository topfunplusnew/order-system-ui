<script>
export default {
  name: "FileItems",
  props: {
    fileName: {
      type: String,
      default: "无名称"
    }
  },
  computed: {
    _fileName() {
      return this.fileName
    }
  }
}
</script>

<template>
  <div class="file-container">
    <div class="file-icon">
      <el-icon class="el-icon-document">
      </el-icon>
    </div>
    <div class="file-name">
      {{ _fileName }}...
    </div>
  </div>
</template>

<style scoped lang="scss">
.file-container {
  margin: 8px 10px;
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
    transition: all 0.5s;
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
}
</style>

<template>
  <el-container>
    <el-main style="padding:0px 10px;">
      
    </el-main>
  </el-container>
</template>

<script>



export default {
  name: "MainView",
  props: {
    global: Object
  },
  components:{
    
  },
  data() {
    return {
      
    };
  }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

.el-header {
  height: 40px!important;
  padding: 0px;
}

.el-main {
  padding: 0px;
  overflow: hidden;
}
.el-input-group__prepend > .el-select {
  width: 120px;
}
</style>

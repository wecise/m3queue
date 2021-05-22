<template>
  <el-container>
    <el-main>
        <Split :gutterSize="5">
            <SplitArea :size="20" :minSize="0" style="overflow:hidden;">
                <el-tree :data="tree.data" @node-click="onNodeClick"></el-tree>
            </SplitArea>
            <SplitArea :size="80" :minSize="0" style="overflow:hidden;padding:20px;">
              <el-container>
                
                <el-main>
                  
                    <Editor
                          v-model="editor.data"
                          @init="onEditorInit"
                          :lang="editor.lang.value"
                          :theme="editor.theme.value"
                          width="99.8%"
                          height="calc(100% - 90px)"
                          style="border:1px solid #f2f2f2;"
                      ></Editor>
                  
                </el-main>
                
              </el-container>
            </SplitArea>
        </Split>
      
    </el-main>
  </el-container>
</template>

<script>
import $ from 'jquery';
export default {
  name: "MainView",
  props: {
    global: Object
  },
  components:{
    Editor:require("vue2-ace-editor"),
  },
  data() {
    return {
        tree: {
          data: [
            { label: "General Server Information", url: "varz"},
            { label: "Connections", url: "connz"},
            { label: "Routing", url: "routez"},
            { label: "Gateways", url: "gatewayz"},
            { label: "Leaf Nodes", url: "leafz"},
            { label: "Subscription Routing", url: "subsz"},
            { label: "Account Information", url: "accountz"},
            { label: "JetStream Information", url: "jsz"}
          ]
        },
        editor: {
              data: null,
              loading: false,
              lang: {
                  value: "json",
                  list: []
              },
              theme: {
                  value: "chrome",
                  list: this.m3.EDITOR_THEME
              }
          },
    };
  },
  methods: {
    onNodeClick(treeNode){
        let hostname = "47.92.151.165";
        let api = `http://${hostname}:8222/${treeNode.url}`;
        $.get({
          url:api,
          dataType: "jsonp",
          success:(data)=>{
            this.editor.data = JSON.stringify(data,null,2);
          },
          error: (err)=>{
            this.editor.data = "";
          }
        })
    },
    onEditorInit(){
          require("brace/ext/language_tools"); //language extension prerequsite...
          require(`brace/mode/${this.editor.lang.value}`); //language
          require(`brace/snippets/${this.editor.lang.value}`); //snippet
          require(`brace/theme/${this.editor.theme.value}`); //language
      },
  }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

  .el-container{
    height: 100vh;
  }
  .el-main{
    padding: 0px;
  }
</style>

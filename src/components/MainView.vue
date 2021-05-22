<template>
  <el-container>
    <el-main>
        <Split :gutterSize="5">
            <SplitArea :size="20" :minSize="0" style="overflow:hidden;">
                <el-tree :data="tree.data" @node-click="onNodeClick">
                  <span slot-scope="{ data }">
                    {{data.title}}
                  </span>
                </el-tree>
            </SplitArea>
            <SplitArea :size="80" :minSize="0" style="overflow:hidden;">
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
            { label: "General Server Information", title:"服务器信息", url: "varz"},
            { label: "Connections", title:"连接信息", url: "connz"},
            { label: "Routing", title:"路由信息", url: "routez"},
            { label: "Gateways", title:"网关信息", url: "gatewayz"},
            { label: "Leaf Nodes", title:"子节点信息", url: "leafz"},
            { label: "Subscription Routing", title:"路由订阅", url: "subsz"},
            { label: "Account Information", title:"账户信息", url: "accountz"},
            { label: "JetStream Information", title:"JetStream", url: "jsz"}
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
            this.editor.data = err;
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
    height:calc(100vh - 120px);
    background:#f2f2f2;
  }
  
</style>

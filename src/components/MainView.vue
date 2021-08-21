<template>
  <el-container>
    <el-main>
        <Split :gutterSize="5">
            <SplitArea :size="20" :minSize="0" style="overflow:hidden;">
                <el-tree :data="tree.data" @node-click="onNodeClick" style="height:100%;overflow:auto;">
                  <span slot-scope="{ data }">
                    <span v-if="data.children && data.children.length > 0">{{data.title}} ({{data.children.length}})</span>
                    <span v-else>{{data.title}}</span>
                  </span>
                </el-tree>
            </SplitArea>
            <SplitArea :size="80" :minSize="0" style="overflow:hidden;">
              <el-container style="width:100%;">
                
                <el-main style="padding-top: 0px;padding-bottom: 0px;">
                    <Split :gutterSize="5" direction="vertical" @onDragEnd="onDragEnd">
                      <SplitArea :size="60" :minSize="0" style="overflow:hidden;">
                        <connz :model="tree.selected" v-if="tree.selected && tree.selected.url==='connz'"></connz>
                        <channelsz :model="tree.selected" v-if="tree.selected && tree.selected.url==='/streaming/channelsz'"></channelsz>
                      </SplitArea>
                      <SplitArea :size="40" :minSize="0" style="overflow:hidden;">
                          <Editor
                                v-model="editor.data"
                                @init="onEditorInit"
                                :lang="editor.lang.value"
                                :theme="editor.theme.value"
                                width="100%"
                                height="calc(100% - 0px)"
                                style="border:1px solid #f2f2f2;"
                                v-if="editor.data">
                          </Editor>
                    </SplitArea>
                  </Split>
                </el-main>
                
              </el-container>
            </SplitArea>
        </Split>
      
    </el-main>
  </el-container>
</template>

<script>
import _ from 'lodash';
import $ from 'jquery';
import Connz from './summary/Connz';
import Channelsz from './summary/Channelsz'

export default {
  name: "MainView",
  props: {
    global: Object
  },
  components:{
    Editor:require("vue2-ace-editor"),
    Connz,
    Channelsz
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
            { label: "JetStream Information", title:"JetStream", url: "", children:[
                { label: "serverz", title:"serverz", url: "/streaming/serverz", children:[]},
                { label: "storez", title:"storez", url: "/streaming/storez", children:[]},
                { label: "clientsz", title:"clientsz", url: "/streaming/clientsz", children:[]},
                { label: "channelsz", title:"channelsz", url: "/streaming/channelsz", children:[]},
            ]}
          ],
          selected: null
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
        }
    };
  },
  methods: {
    onNodeClick(treeNode){

        let hostname = process.env.NODE_ENV === "development" ? "47.92.151.165" : window.location.hostname;
        let api = `http://${hostname}:8222/${treeNode.url}`;

        $.get({
          url:api,
          dataType: "jsonp",
          success:(data)=>{

            this.editor.data = JSON.stringify(data,null,2);

            if(treeNode.url === '/streaming/clientsz'){
                treeNode.children = _.map(data.clients, v=>{
                  return _.extend(v, { label: v.id, title: v.id, url: `${treeNode.url}?client=${v.id}&subs=1.`});
                })
            } 
            else if(treeNode.url === '/streaming/channelsz'){
                treeNode.children = _.map(data.names, v=>{
                  return _.extend(v, { label: v, title: v, url: `${treeNode.url}?channel=${v}&subs=1`});
                })
            }

            this.tree.selected = _.extend( treeNode, {data: data} );
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
    onDragEnd(){
      this.eventHub.$emit("WINDOW-RESIZE-EVENT");
    }
  }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

  .el-container{
    height:calc(100vh - 80px);
    background:#f2f2f2;
  }
  
</style>

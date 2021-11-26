<template>
  <el-container style="height: calc(100vh - 60px);">
    <el-main>
        <Split :gutterSize="5" style="border:1px solid #dddddd;">
            <SplitArea :size="20" :minSize="0" style="overflow:hidden;background:#f2f2f2;">
                <el-tree :data="tree.data" @node-click="onNodeClick" style="height:100%;overflow:auto;background:#f2f2f2;">
                  <span slot-scope="{ data }">
                    <span v-if="data.children && data.children.length > 0">{{data.title}} ({{data.children.length}})</span>
                    <span v-else>{{data.title}}</span>
                  </span>
                </el-tree>
            </SplitArea>
            <SplitArea :size="80" :minSize="0" style="overflow:hidden;">
              <el-container  style="height:calc(100vh - 102px);" v-if="tree.selected">
                <el-header style="height:40px!important;line-height:40px;background:#f2f2f2;">
                  <span style="font-size:14px;">{{tree.selected.title}}</span>
                  <i class="el-icon-loading" v-if="editor.loading"></i>
                  <span style="float:right;">
                      {{ control.ifRefresh ? '自动刷新' : '刷新关闭' }}
                      <el-switch
                          v-model="control.ifRefresh"
                          active-color="#13ce66"
                          inactive-color="#dddddd"
                          :active-value="true"
                          :inactive-value="false">
                      </el-switch>
                  </span>
                </el-header>
                <el-main style="padding:0px;">
                    <Split :gutterSize="5" direction="vertical" @onDragEnd="onDragEnd">
                      <!--SplitArea :size="0" :minSize="0" style="overflow:hidden;">
                        <connz :model="tree.selected" v-if="tree.selected && tree.selected.url==='connz'"></connz>
                        <channelsz :model="tree.selected" v-if="tree.selected && tree.selected.url==='/streaming/channelsz'"></channelsz>
                      </SplitArea-->
                      <SplitArea :size="100" :minSize="0" style="overflow:hidden;">
                          <div>
                            <el-input v-model="editor.queryJson" placeholder="根据属性过滤" clearable></el-input>
                          </div>
                          <Editor
                                v-model="editor.data"
                                @init="onEditorInit"
                                :lang="editor.lang.value"
                                :theme="editor.theme.value"
                                width="100%"
                                height="calc(100vh - 215px)"
                                style="border:1px solid #f2f2f2;"
                                v-if="editor.data">
                          </Editor>
                    </SplitArea>
                  </Split>
                </el-main>
                <el-footer style="background:#f2f2f2;height:40px;line-height:40px;background:#f2f2f2;">
                  <span style="float:right;" v-if="control.ifRefresh">
                      <countdown 
                          :left-time="5000"
                          @finish="onCountDownS" ref="vac" v-if="control.ifRefresh"> 
                          <span
                          slot="process"
                          slot-scope="{ timeObj }">
                              {{ `距离下次刷新：${timeObj.ceil.s} 秒` }}
                          </span>
                      </countdown>
                  </span>
                </el-footer>
              </el-container>
            </SplitArea>
        </Split>
      
    </el-main>
  </el-container>
</template>

<script>
import _ from 'lodash';
import $ from 'jquery';
import Vue from 'vue';
import vueAwesomeCountdown from 'vue-awesome-countdown';
Vue.use(vueAwesomeCountdown, 'vac');

const jsonata = require("jsonata");

export default {
  name: "MainView",
  props: {
    global: Object
  },
  components:{
    Editor:require("vue2-ace-editor")
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
            { label: "JetStream Information", title:"JetStream", url: "/jsz", children:[
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
              },
              queryJson: ""
        },
        control:{
            ifRefresh: true
        }
    };
  },
  watch:{
    'editor.queryJson'(val){
        if(!_.isEmpty(val)){
          this.onCountDownS();
        }
    }
  },
  methods: {
    /* 倒计时刷新 */
    onCountDownS(){
        this.$refs.vac.startCountdown(true);
        this.onNodeClick(this.tree.selected);
    },
    onNodeClick(treeNode){
        
        this.editor.loading = true;

        this.tree.selected = treeNode;
        
        let hostname = process.env.NODE_ENV === "development" ? "47.92.151.165" : window.location.hostname;
        let api = `http://${hostname}:8222/${treeNode.url}`;

        $.get({
          url:api,
          dataType: "jsonp",
          success:(data)=>{

            // json query
            try{
              if(!_.isEmpty(this.editor.queryJson)){
                var expression = jsonata(this.editor.queryJson);
                this.editor.data = JSON.stringify(expression.evaluate(data),null,2);
              }else{
                this.editor.data = JSON.stringify(data,null,2)
              }
            }catch(err){
              this.editor.data = err;
              this.editor.loading = false;
            }
            
            
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

            _.extend( this.tree.selected, {data: data} );

            this.editor.loading = false;

          },
          error: (err)=>{
            this.editor.data = err;
            this.editor.loading = false;
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

  .el-main{
    overflow: hidden;
  }

  .split /deep/ .el-input__inner{
    border:unset;
  }
  
</style>

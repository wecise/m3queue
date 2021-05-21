<template>
  <el-container class="m3 queue-console">
    <el-header>
        <Header :auth="auth" v-if="auth"></Header>
      </el-header>
    <el-main>
      <MainView :global="global" v-if="global"></MainView>
    </el-main>
  </el-container>
</template>

<script>

import MainView from './components/MainView';
import Header from './components/layout/Header';

export default {
  name: 'app',
  components: {
    Header,
    MainView
  },
  data(){
    return {
      global:null,
      auth: null
    }
  },
  mounted(){
    setTimeout(()=>{
      this.global = this.m3.global;
      this.auth = this.m3.auth.signedUser;
    },500)
  }
}
</script>

<style>
  body{
    overflow: hidden!important;
    font-size: 12px;
    font-family: "PingFang SC",Arial,"Microsoft YaHei",sans-serif;
    margin: 0px;
    padding: 0px;
  }
  
  .el-table .el-table__body td {
      padding: 3px;
  }
  
  /* mxgraph contextmenu style */
  td.mxPopupMenuIcon div {
    width:16px;
    height:16px;
  }
  html div.mxPopupMenu {
    -webkit-box-shadow:2px 2px 3px #d5d5d5;
    -moz-box-shadow:2px 2px 3px #d5d5d5;
    box-shadow:2px 2px 3px #d5d5d5;
    _filter:progid:DXImageTransform.Microsoft.DropShadow(OffX=2, OffY=2, Color='#d0d0d0', Positive='true');
    background:white;
    position:absolute;
    border:1px solid #e7e7e7;
    padding:3px;
  }
  html table.mxPopupMenu {
    border-collapse:collapse;
    margin:0px;
  }
  html td.mxPopupMenuItem {
    padding:7px 30px 7px 30px;
    font-family: "微软雅黑";/* Microsoft YaHei,Helvetica Neue,Helvetica,Arial Unicode MS,Arial;*/
    font-size:12px;
  }
  html td.mxPopupMenuIcon {
    background-color:white;
    padding:0px;
  }
  td.mxPopupMenuIcon .geIcon {
    padding:2px;
    padding-bottom:4px;
    margin:2px;
    border:1px solid transparent;
    opacity:0.5;
    _width:26px;
    _height:26px;
  }
  td.mxPopupMenuIcon .geIcon:hover {
    border:1px solid gray;
    border-radius:2px;
    opacity:1;
  }
  html tr.mxPopupMenuItemHover {
    background-color: #f5f5f5;
    color: black;
  }
  table.mxPopupMenu hr {
    color:#cccccc;
    background-color:#f5f5f5;
    border:none;
    height:1px;
  }
  table.mxPopupMenu tr {
    font-size:4pt;
  }

  .el-dialog{
      width: 90vw!important;
      height:85vh;
      margin-top: 0!important;
  }
  
  /* el-checkbox */
  .el-checkbox__label {
      font-size: 12px!important;
  }
  /* el-tabs */
  .el-tabs--border-card>.el-tabs__header {
    background-color: #f2f2f2!important;
    border-bottom: unset!important;
    border-top: 1px solid #dddddd;
  }
  
  .el-menu .svg-icon{
    width: 1.2em!important;
    height: 1.2em!important;
    padding: 0px 5px 0 0;
  }
</style>
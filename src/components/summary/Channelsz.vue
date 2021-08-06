<template>
    <div style="height:100%">
        <div>
            <el-button type="success">通道总流量：{{allBytes}}</el-button>
            <el-button type="success">通道总消息：{{allMsgs}}</el-button>
        </div>
        
        <v-chart :option="option" 
            class="chart" 
            :autoresize="true">
        </v-chart>
    </div>

</template>

<script>
import _ from 'lodash';
import $ from 'jquery';
import ECharts  from "vue-echarts";
import { use } from 'echarts/core'

import {
  CanvasRenderer
} from 'echarts/renderers'
import {
  SankeyChart
} from 'echarts/charts';
import {
  GridComponent,
  TooltipComponent
} from 'echarts/components';

use([
  CanvasRenderer,
  SankeyChart,
  GridComponent,
  TooltipComponent
]);

export default{
    name: "Channelsz",
    props: {
        model: Object
    },
    components: {
        "v-chart": ECharts
    },
    data() {
        return {
            option: {
                title: {
                    text: 'Channel'
                },
                tooltip: {
                    trigger: 'item',
                    triggerOn: 'mousemove'
                },
                left: 50.0,
                top: 20.0,
                right: 150.0,
                bottom: 25.0,
                animation: false,
                series: [{
                    type: 'sankey',
                    
                    nodeAlign: 'right',
                    data: [],
                    links: [],
                    lineStyle: {
                        color: 'source',
                        curveness: 0.5
                    },
                    focusNodeAdjacency: true,
                    levels: [{
                        depth: 0,
                        itemStyle: {
                            color: '#fbb4ae'
                        },
                        lineStyle: {
                            color: 'source',
                            opacity: 0.6
                        }
                    }, {
                        depth: 1,
                        itemStyle: {
                            color: '#b3cde3'
                        },
                        lineStyle: {
                            color: 'source',
                            opacity: 0.6
                        }
                    }, {
                        depth: 2,
                        itemStyle: {
                            color: '#ccebc5'
                        },
                        lineStyle: {
                            color: 'source',
                            opacity: 0.6
                        }
                    }, {
                        depth: 3,
                        itemStyle: {
                            color: '#decbe4'
                        },
                        lineStyle: {
                            color: 'source',
                            opacity: 0.6
                        }
                    }]
                }]
            }
        };
    },
    computed:{
        allBytes(){
            return _.round(_.sumBy(this.option.series[0].links,'value') / 1024 / 1024,2) + ' MB'
        },
        allMsgs(){
            return _.round(_.sumBy(this.option.series[0].links,'msgs'),2);
        }
    },
    watch:{
        'model.data':{
            handler(){
                this.initData();
            },
            deep:true,
            immediate: true
        }
    },
    mounted() {

        setInterval(()=>{
            this.initData();
        },30 * 1000)
    },
    methods: {
        
        initData(){

            this.option.series[0].data = [];
            this.option.series[0].links = [];

            this.option.series[0].data.push({name:"matrix"});

            _.forEach(this.model.children,(v)=>{
                this.option.series[0].data.push({name:v.title});
            })

            let hostname = process.env.NODE_ENV === "development" ? "47.92.151.165" : window.location.hostname;

            _.forEach(this.model.children,(v)=>{
                
                let api = `http://${hostname}:8222/streaming/channelsz?channel=${v.title}&subs=1`;

                $.get({
                    url:api,
                    dataType: "jsonp",
                    success:(data)=>{
                        if(data.bytes < 1) return;
                        this.option.series[0].links.push( {source: 'matrix', target: data.name, value: data.bytes, msgs: data.msgs});
                    },
                    error: (err)=>{
                        console.error(err);
                    }
                })
            })
            
        }
        
    }  
}
</script>

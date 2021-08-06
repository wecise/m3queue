<template>
    <v-chart :option="options" 
        class="chart" 
        :autoresize="true">
    </v-chart>
    
</template>

<script>
import _ from "lodash";
import ECharts  from "vue-echarts";
import { use } from "echarts/core";

// import ECharts modules manually to reduce bundle size
import {
  CanvasRenderer
} from 'echarts/renderers';
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
    name: "Connz",
    props: {
        model: Object
    },
    components: {
        "v-chart": ECharts
    },
    data() {
        return {
            options: {
                tooltip: {
                    trigger: 'item',
                    triggerOn: 'mousemove'
                },
                animation: false,
                left: 50.0,
                top: 120.0,
                right: 150.0,
                bottom: 25.0,
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
    watch:{
        'model.data':{
            handler(){
                this.initData();
            },
            deep:true,
            immediate: true
        }
    },
    methods: {
        initData(){
            let data = [];
            let links = [];
            _.forEach(this.model.data.connections,(v)=>{
                data.push( {name: `${v.name} ${v.port}` } );
            });
            
            data.push({name:"North"});
            data.push({name:"Sourth"});

            _.forEach(this.model.data.connections,(v)=>{
                links.push( {source: 'North', target: `${v.name} ${v.port}`, value: v.in_msgs});
                links.push( {source: `${v.name} ${v.port}`, target: 'Sourth', value: v.out_msgs});
            });

            this.options.series[0].data = [...data];
            this.options.series[0].links = [...links];
            
        }
    }  
}
</script>

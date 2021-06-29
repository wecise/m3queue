<template>
    <div style="width:100%;height:100%;" ref="chartContainer"></div>
</template>

<script>
import _ from 'lodash';
import echarts from 'echarts';

export default{
    name: "Connz",
    props: {
        model: Object
    },
    data() {
        return {
            chart: null,
            option: {
                tooltip: {
                    trigger: 'item',
                    triggerOn: 'mousemove'
                },
                animation: false,
                series: [{
                    type: 'sankey',
                    focusNodeAdjacency: 'allEdges',
                    nodeAlign: 'right',
                    data: [],
                    links: [],
                    lineStyle: {
                        color: 'source',
                        curveness: 0.5
                    }
                }]
            }
        };
    },
    watch:{
        'model.data':{
            handler(){
                this.initData();
            },
            deep:true
        }
    },
    created(){
        // 接收窗体RESIZE事件
        this.eventHub.$on("WINDOW-RESIZE-EVENT", this.checkChart);
    },
    mounted() {

        this.$nextTick(()=>{
            setTimeout(() => {
                this.onInit();
            });
        })

        // 监听窗口发生变化，resize组件
        window.addEventListener('resize', this.checkChart)
        
        // 通过hook监听组件销毁钩子函数，并取消监听事件
        this.$once('hook:beforeDestroy', () => {
            window.removeEventListener('resize', this.checkChart)
        })
    },
    methods: {
        onInit(){
            let chart = echarts.init(this.$refs.chartContainer);
            chart.setOption(this.option);
            this.chart = chart;

            this.initData();
        },
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

            this.option.series[0].data = [...data];
            this.option.series[0].links = [...links];
            
            this.chart.setOption(this.option);
            
        },
        checkChart(){
            try{
                this.chart.resize();
            } catch(err){
                console.error(err)
            }
        },
        beforeDestroy() {
            if (!this.chart) {
                return
            }
            this.chart.dispose();
            this.chart = null;
        }
        
    }  
}
</script>

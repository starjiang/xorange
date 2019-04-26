(function (L) {
  var _this = null;
  L.ApiStat = L.ApiStat || {};
  _this = L.ApiStat = {
    data: {
    },
    init: function () {
        L.Common.loadConfigs("api_stat", _this, true);
        _this.initEvents();
    },
    initEvents:function(){
      L.Common.initSwitchBtn("api_stat", _this);
      L.Common.initSyncDialog("api_stat", _this);

      _this.initTable()
      _this.initTimeRangeEvent();
      _this.initTimeRange2Event();
      _this.initShowGraphEvent();
    },
    initTimeRangeEvent:function(){
      $(document).on("click", ".time_range", function() {
        var minutes = parseInt($(this).attr("data-minutes"));
        $('.time_range').removeClass('active');
        $(this).addClass('active');
        var $table = $('#api_stats_list');
        var ip = $("#ip-input").val();
        $table.bootstrapTable('refresh',{url:'/api_stat/list?period='+minutes+'&ip='+ip});
      });
    },
    initTimeRange2Event:function(){
      $(document).on("click", ".time_range2", function() {
        var minutes = parseInt($(this).attr("data-minutes"));
        $('.time_range2').removeClass('active');
        $(this).addClass('active');
    
        var api = $("#api").val();
        var domain = $("#domain").val();
        var ip = $("#ip-input").val();
    
        _this.getApiStatsDataAndRender(minutes,api,domain,ip);
      });
    },
    initShowGraphEvent:function(){
      $(document).on("click", ".api_stat_graph", function() {


        var api = $(this).attr("data-api");
        var domain = $(this).attr("data-domain");
      
        $("#api").val(api);
        $("#domain").val(domain);
      
        $('.time_range2').removeClass('active');
        $('.time_range2').eq(0).addClass('active');
      
        _this.initRequestStats();
        _this.getApiStatsDataAndRender(60,api,domain,"");
      
        var d = dialog({
        title: 'API【'+api+'】曲线',
        content: document.getElementById('graphbox')
        });
        d.showModal();
      });
    },
    getApiStatsDataAndRender:function(period,api,domain,ip){
      $.getJSON("/api_stat/data?period="+period+"&api="+api+"&domain="+domain+"&ip="+ip,function(res){
        statsData = {} 
        for(index in res.data){
          statsData[res.data[index].stat_time]=res.data[index];
        }
        var end = parseInt(period)
        var requestOption = _this.data.requestChart.getOption();
        var timeList = [];
        for(i=1;i<=end;i++){
          var date = new Date();
          date.setSeconds(date.getSeconds() - i*60);
          timeList.push(date.format("yyyy-MM-dd HH:mm:00"));
        }
    
        requestOption.series[0].data = [];
        requestOption.series[1].data = [];
        requestOption.series[2].data = [];
        requestOption.series[3].data = [];
        requestOption.series[4].data = [];
        requestOption.series[5].data = [];
        requestOption.series[6].data = [];
        requestOption.series[7].data = [];
    
        for(i=0;i<timeList.length;i++){
          info = statsData[timeList[i]]
          var time = new Date(timeList[i]).getTime();
          if (info) {
            var item = [timeList[i],info.total];
            requestOption.series[0].data.push([time,info['total']]);
            requestOption.series[1].data.push([time,info['2xx']]);
            requestOption.series[2].data.push([time,info['3xx']]);
            requestOption.series[3].data.push([time,info['4xx']]);
            requestOption.series[4].data.push([time,info['5xx']]);
            requestOption.series[5].data.push([time,info['avg_time']]);
            requestOption.series[6].data.push([time,info['avg_read']]);
            requestOption.series[7].data.push([time,info['avg_write']]);
    
          }else{
            requestOption.series[0].data.push([time,0]);
            requestOption.series[1].data.push([time,0]);
            requestOption.series[2].data.push([time,0]);
            requestOption.series[3].data.push([time,0]);
            requestOption.series[4].data.push([time,0]);
            requestOption.series[5].data.push([time,0]);
            requestOption.series[6].data.push([time,0]);
            requestOption.series[7].data.push([time,0]);
          }
        }
    
        _this.data.requestChart.setOption(requestOption);
    
      });
    },
    initRequestStats() {
      var option = {
          grid: {
              left: '20px',
              right: '20px',
              bottom: '30px',
              containLabel: true
          },
          tooltip: {
            trigger: 'axis',
            formatter: function (params) {
              return "["+new Date(params[0]['data'][0]).format("MM-dd HH:mm")+"] "+params[0]['data'][1]
            },
            axisPointer: {
                animation: false
            }
          },
          legend: {
              data: ['全部请求', '2xx请求', '3xx请求', '4xx请求', '5xx请求', '平均请求时间','平均请求读字节','平均请求写字节'],
              selectedMode:'single'
          },
          xAxis: [{
              type: 'time',
              splitLine: {
                show: false
              }
          }],
          yAxis: [{
              type: 'value',
              scale: true,
              name: ''
          }],
          series: [{
              name: '全部请求',
              type: 'line',
              itemStyle: {
                  normal: {
                    lineStyle:{
                      width:1
                    },
                    color: '#03A1F7'
                  }
              },
              showSymbol: false,
              hoverAnimation: false,
              data: []
          }, {
              name: '2xx请求',
              type: 'line',
              itemStyle: {
                  normal: {
                    lineStyle:{
                      width:1
                    },
                    color: '#03A1F7'
                  }
              },
              showSymbol: false,
              hoverAnimation: false,
              data: []
          }, {
              name: '3xx请求',
              type: 'line',
              itemStyle: {
                  normal: {
                    lineStyle:{
                      width:1
                    },
                    color: '#03A1F7'
                  }
              },
              showSymbol: false,
              hoverAnimation: false,
              data: []
          }, {
              name: '4xx请求',
              type: 'line',
              itemStyle: {
                  normal: {
                    lineStyle:{
                      width:1
                    },
                    color: '#03A1F7'
                  }
              },
              showSymbol: false,
              hoverAnimation: false,
              data: []
          }, {
              name: '5xx请求',
              type: 'line',
              itemStyle: {
                  normal: {
                      color: '#F75903'
                  }
              },
              showSymbol: false,
              hoverAnimation: false,
              data: []
          }, {
              name: '平均请求时间',
              type: 'line',
              itemStyle: {
                  normal: {
                    lineStyle:{
                      width:1
                    },
                    color: '#03A1F7'
                  }
              },
              showSymbol: false,
              hoverAnimation: false,
              data: []
          }, {
              name: '平均请求读字节',
              type: 'line',
              itemStyle: {
                  normal: {
                    lineStyle:{
                      width:1
                    },
                    color: '#03A1F7'
                  }
              },
              showSymbol: false,
              hoverAnimation: false,
              data: []
          }, {
              name: '平均请求写字节',
              type: 'line',
              itemStyle: {
                  normal: {
                    lineStyle:{
                      width:1
                    },
                    color: '#03A1F7'
                  }
              },
              showSymbol: false,
              hoverAnimation: false,
              data: []
          }]
      };
    
      var requestChart = echarts.init(document.getElementById('request-area'));
      requestChart.setOption(option);
      _this.data.requestChart = requestChart;
    },
    graphFormatter:function(value, row, index){
      var content = '<a class="api_stat_graph" data-api="'+row['api']+'" data-domain="'+row['domain']+'" href="javascript:void(0)" title="Graph">'+
        '<i class="fa fa-th"></i>'+
        '</a>';
      return content;
    },
    initTable:function() {
      var $table = $('#api_stats_list')
      $table.bootstrapTable('destroy').bootstrapTable({
        height:'auto',
        locale: "zh-CN",
        columns: [
          {
            title: 'domain',
            field: 'domain',
            align: 'left',
            sortable: true,
          },{
            field: 'api',
            title: 'api',
            sortable: true,
            align: 'left'
          }, {
            field: 'total',
            title: 'total_reqs',
            sortable: true,
            align: 'left',
          }, {
            field: 'avg_time',
            title: 'avg_time(ms)',
            sortable: true,
            align: 'left',
          }, {
            field: '2xx',
            title: '2xx',
            sortable: true,
            align: 'left',
          }, {
            field: '3xx',
            title: '3xx',
            sortable: true,
            align: 'left',
          }, {
            field: '4xx',
            title: '4xx',
            sortable: true,
            align: 'left',
          }, {
            field: '5xx',
            title: '5xx',
            sortable: true,
            align: 'left',
          }, {
            field: 'avg_write',
            title: 'avg_wbytes',
            sortable: true,
            align: 'left',
          }, {
            field: 'avg_read',
            title: 'avg_rbytes',
            sortable: true,
            align: 'left',
          }, {
            field: 'graph',
            title: 'graph',
            sortable: true,
            formatter: _this.graphFormatter,
            align: 'center',
          }
        ]
      })
    }
  }
}(APP));
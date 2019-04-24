(function (L) {
    var _this = null;
    L.WAF = L.WAF || {};
    _this = L.WAF = {
        data: {
        },

        init: function () {
             L.Common.loadConfigs("waf", _this, true);
            _this.initEvents();
        },

        initEvents: function () {
            var op_type = "waf";
            L.Common.initRuleAddDialog(op_type, _this);//添加规则对话框
            L.Common.initRuleDeleteDialog(op_type, _this);//删除规则对话框
            L.Common.initRuleEditDialog(op_type, _this);//编辑规则对话框
            L.Common.initRuleSortEvent(op_type, _this);

            L.Common.initSelectorAddDialog(op_type, _this);
            L.Common.initSelectorDeleteDialog(op_type, _this);
            L.Common.initSelectorEditDialog(op_type, _this);
            L.Common.initSelectorSortEvent(op_type, _this);
            L.Common.initSelectorClickEvent(op_type, _this);

            L.Common.initSelectorTypeChangeEvent();//选择器类型选择事件
            L.Common.initConditionAddOrRemove();//添加或删除条件
            L.Common.initJudgeTypeChangeEvent();//judge类型选择事件
            L.Common.initConditionTypeChangeEvent();//condition类型选择事件
            L.Common.initExtractionHasDefaultValueOrNotEvent();//提取项是否有默认值选择事件

            L.Common.initExtractionAddOrRemove();//添加或删除条件
            L.Common.initExtractionTypeChangeEvent();//extraction类型选择事件
            L.Common.initExtractionAddBtnEvent();//添加提前项按钮事件
            L.Common.initExtractionHasDefaultValueOrNotEvent();//提取项是否有默认值选择事件

            _this.initHandleTypeChangeEvent();//handle类型选择事件
            _this.initIpListTable();
            _this.initIpEditBtnEvent();
            _this.initIpAddBtnEvent();
            _this.initIpRemoveBtnEvent();
            _this.initIpRemoveSelectedEvent();

            L.Common.initViewAndDownloadEvent(op_type, _this);
            L.Common.initSwitchBtn(op_type, _this);//redirect关闭、开启
            L.Common.initSyncDialog(op_type, _this);//编辑规则对话框
        },
        initIpRemoveSelectedEvent:function(){
            
            $(document).on("click", "#btn_remove_selected", function() {
                var ip_list = _this.getSelectItems().join(',')
                var rule_id = $("#rule_id").val();
                $.getJSON("/waf/delete_ip?ip="+ip_list+"&rule_id="+rule_id,function(res){
                
                if(res.ret == 0){
                    var $table = $('#ip_list');
                    $table.bootstrapTable('refresh',{url:'/waf/ip_list?rule_id='+rule_id});
                }else{
                    alert('删除失败');
                }
                })
            })
        },
        getSelectItems:function(){
            var $table = $('#ip_list');
            return $.map($table.bootstrapTable('getSelections'), function (row) {
                return row.ip
            })
        },
        initIpEditBtnEvent:function(){
            $(document).on("click", ".edit-ip-btn", function() {
  
                var d = dialog({
                    title: '例外IP名单管理',
                    content: document.getElementById('ip-list-tpl')
                  });
                  d.showModal();
                  var rule_id = $(this).attr("data-id");
                  var $table = $('#ip_list');
                  $table.bootstrapTable('refresh',{url:'/waf/ip_list?rule_id='+rule_id});
                  $("#rule_id").val(rule_id);
            })
        },
        isValidIp:function(ip){
            var reg = /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/
            return reg.test(ip);
        },
        initIpAddBtnEvent:function(){
            $(document).on("click", "#btn_add_ip", function() {
                var ip = $("#ip_address").val()
                var rule_id = $("#rule_id").val()

                if(!_this.isValidIp(ip)){
                    alert('ip地址格式不对');
                    return
                }
                $.getJSON("/waf/add_ip?ip="+ip+"&rule_id="+rule_id,function(res){
                
                if(res.ret == 0){
                    var ip = $("#ip_address").val("")
                    var $table = $('#ip_list');
                    $table.bootstrapTable('refresh',{url:'/waf/ip_list?rule_id='+rule_id});
                }else{
                    alert('添加失败:'+res.msg);
                }
                })
            })
        },
        initIpRemoveBtnEvent:function(){
            $(document).on("click", ".ip_remove", function() {
                var ip = $(this).attr("data-ip");
                var rule_id = $(this).attr("data-rule-id");
                $.getJSON("/waf/delete_ip?ip="+ip+"&rule_id="+rule_id,function(res){
                
                if(res.ret == 0){
                    var $table = $('#ip_list');
                    $table.bootstrapTable('refresh',{url:'/waf/ip_list?rule_id='+rule_id});
                }else{
                    alert('删除失败');
                }
                })
            })
        },
        initIpListTable:function(){
            var $table = $('#ip_list')
            $table.bootstrapTable('destroy').bootstrapTable({
                height:500,
                locale: "zh-CN",
                columns: [
                {
                    checkbox: true,
                    title: '操作',
                    field: 'operate',
                    align: 'center',
                },
                {
                    title: 'ip',
                    field: 'ip',
                    align: 'left',
                },{
                    field: 'delete',
                    title: '删除',
                    align: 'center',
                    formatter: _this.operateFormatter
                }
                ]
            })
        },
        operateFormatter:function(value, row, index) {
            return '<a class="ip_remove" data-ip="'+row['ip']+'" data-rule-id="'+row['rule_id']+'" href="javascript:void(0)" title="Remove"><i class="fa fa-trash"></i></a>';
        },
        //handle类型选择事件
        initHandleTypeChangeEvent: function () {
            $(document).on("change", '#rule-handle-perform', function () {
                var handle_type = $(this).val();

                if (handle_type == "allow") {
                    $(this).parents(".handle-holder").find(".handle-code-hodler").hide();
                } else {
                    $(this).parents(".handle-holder").find(".handle-code-hodler").show();
                }
            });
        },

        buildRule: function () {
            var result = {
                success: false,
                data: {
                    name: null,
                    judge: {},
                    handle: {}
                }
            };

            //build name and judge
            var buildJudgeResult = L.Common.buildJudge();
            if (buildJudgeResult.success == true) {
                result.data.name = buildJudgeResult.data.name;
                result.data.judge = buildJudgeResult.data.judge;
            } else {
                result.success = false;
                result.data = buildJudgeResult.data;
                return result;
            }

            //build handle
            var buildHandleResult = _this.buildHandle();
            if (buildHandleResult.success == true) {
                result.data.handle = buildHandleResult.handle;
            } else {
                result.success = false;
                result.data = buildHandleResult.data;
                return result;
            }

            //enable or not
            var enable = $('#rule-enable').is(':checked');
            result.data.enable = enable;

            result.success = true;
            return result;
        },

        buildHandle: function () {
            var result = {};
            var handle = {};
            var handle_perform = $("#rule-handle-perform").val();
            if (handle_perform != "deny" && handle_perform != "allow") {
                result.success = false;
                result.data = "执行动作类型不合法，只能是deny或allow";
                return result;
            }
            handle.perform = handle_perform;

            if (handle_perform == "deny") {
                var handle_code = $("#rule-handle-code").val();
                if (!handle_code) {
                    result.success = false;
                    result.data = "执行deny的状态码不能为空";
                    return result;
                }

                handle.code = parseInt(handle_code);
            }
            handle.log = ($("#rule-handle-log").val() === "true");
            result.success = true;
            result.handle = handle;
            return result;
        },
    };
}(APP));

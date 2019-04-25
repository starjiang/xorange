(function (L) {
    var _this = null;
    L.Kafka = L.Kafka || {};
    _this = L.Kafka = {
        data: {
        },

        init: function () {
            L.Common.loadConfigs("kafka", _this, true);
            _this.initEvents();
        },

        initEvents: function(){
            L.Common.initSwitchBtn("kafka", _this);//kafka关闭、开启
            L.Common.initSyncDialog("kafka", _this);//同步数据
        }
    };
}(APP));

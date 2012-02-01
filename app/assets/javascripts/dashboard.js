function initSync() {
    $("#sync")
        .popover({ trigger:"manual", html:true, animate:true, offset:15 })
        .click(function () {
            var el = $(this);
            var _data = el.attr('alt');
            $.ajax({
                type:'GET', url:_data, dataType:'html',
                success:function (data) {
                    el.attr('data-content', data + "\n<br/>Page will be reload in 5 sec.");
                    el.attr('trigger', "hover");
                    el.popover('show');
                    window.setTimeout(function () {
                        location.reload()
                    }, 5000);
                }
            });
        });
}

function loadAjaxMetric(key, onDataReceived) {
    $.ajax({
        method:'GET', dataType:'json', success:onDataReceived,
        url:key + "/data.json"
    });
}

function timeCommonOption() {
    return {
        legend:false,
        lines:{ show:true },
        points:{ show:true },
        xaxis:{ mode:"time" },
        yaxis:{ min:0 }
    };
}

function timeOption() {
    var p = {
        crosshair:{ mode:"x" },
        selection:{ mode:"x" },
        grid:{ hoverable:true, autoHighlight:false }
    };
    $.extend(p, timeCommonOption());
    return p;
}

//---------------------------------------------------------------------------
function setCheckboxes(container, value) {
    choiceContainer = $("#" + container);
    choiceContainer.find("input").click(plotAccordingToChoices);

    $.extend(p, commonTableParams());
    $('#' + tableName).dataTable(p);
}


function installPlotFunc(options, plot_placeholder, loadKey) {
    var data = [];
    var datasets = {};

    // plotter
    function doPlot() {
        showPlot(plot_placeholder, data)
    }

    // loading
    function onDataReceived(series) {
        if (!datasets[series.key]) {
            data.push(series);
            datasets[series.key] = series;
            doPlot();
        }
    }

    // worker
    return function (keys) {
        data = [];
        $.each(keys, function (index, value) {
            key = value;
            if (key.length > 0)
                if (datasets[key])
                    data.push(datasets[key]);
                else
                    loadKey(key, onDataReceived);
        });
        doPlot();
    };
}

function installKeyPlot(plot_placeholder, keys) {
    var plotter = installPlotFunc(timeOption(), plot_placeholder, loadAjaxMetric);

    plotter(keys);
}

function installSmallKeyPlot(plot_placeholder, keys) {
    var plotter = installPlotFunc(timeCommonOption(), plot_placeholder, loadAjaxMetric);
    plotter(keys);
}

function installChoicePlot(plot_placeholder, choiceTable, key) {
    var plotter = installPlotFunc(timeOption(), plot_placeholder, loadAjaxMetric);

    var choiceContainer = $("#" + choiceTable);
    choiceContainer.find("input").click(plotAccordingToChoices);
    $("#" + choiceTable + "_update").click(plotAccordingToChoices);
    $("#" + choiceTable + "_checkall").click(checkAll(choiceContainer, '', true));
    $("#" + choiceTable + "_uncheckall").click(checkAll(choiceContainer, '', false));

    function checkAll(table, name, flag) {
        return function () {
            var selector = ':checkbox' + (name ? '[@name=' + name + ']' : '');
            $(selector, table).attr('checked', flag);
            canUpdate = true;
            plotAccordingToChoices();
        };
    }

    function plotAccordingToChoices() {
        keys = [];
        choiceContainer.find("input:checked").each(function () {
            var key = $(this).attr("name");
            if (key.length > 0)
                keys.push(key);
        });
        plotter(keys);
    }

}

function installReleasePlot(plot_placeholder, table_name, start, stop) {
    // setup background areas
    d1 = Date.parse(start).valueOf()
    d2 = Date.parse(stop).valueOf()
    var markings = [
        { color:'#000', lineWidth:1, xaxis:{ from:d1, to:d1 } },

        { color:'#000', lineWidth:1, xaxis:{ from:d2, to:d2 } }
    ];
    var plotter = installPlotFunc("oldoptions", plot_placeholder, loadAjaxMetric);

    $('#' + table_name + ' tr').click(function (event) {
        keys = $("a", $(this)).map(function () {
            s = $(this).attr("href")
            return s.substr(0, s.length - 1)
        })
        plotter(keys);
    });
}

function showPlot(placeholder, data) {
    // define the options
    var options = {
        title:{ text:""},
        chart:{
            renderTo:placeholder,
            zoomType:'x',
            defaultSeriesType:'line'
        },
        xAxis:{
            type:'datetime',
            gridLineWidth:1,
            labels:{
                align:'left',
                x:3,
                y:3
            },
            plotLines:[
                {value:Date.parse("2011-06-01"), width:1, color:'#ff8080'}
            ],
            maxZoom: 7 * 24 * 3600000 // 7 days
        },
        yAxis:{
            title:"",
            min:0
        },
        legend:{ enabled:false },
        tooltip:{
            formatter:function () {
                return this.y;
            }
        },
        series:[]
    };
    options.series = data
    chart = new Highcharts.Chart(options);
    return chart
}

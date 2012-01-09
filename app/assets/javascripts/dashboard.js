function initSync() {
    $("#sync")
        .twipsy({ trigger:"manual", html:true, animate:true })
        .click(function () {
            var  el   = $(this);
            var _data = el.attr('alt');
            $.ajax({
                type: 'GET', url: _data, dataType: 'html',
                success:function (data) {
                    el.attr('data-content', data);
                    el.attr('trigger', "hover");
                    el.twipsy('show');
                }
            });
        });
}

function loadAjaxMetric(key, onDataReceived) {
    $.ajax({
        method: 'GET', dataType: 'json', success: onDataReceived,
        url: key + "/data.json"
    });
}

function timeCommonOption() {
    return { legend: false,
        lines: { show: true },  points: { show: true },
        xaxis: { mode: "time" }, yaxis: { min: 0 }
    };
}

function timeOption() {
    var p = {
        crosshair: { mode:"x" },
        selection: { mode:"x" },
        grid: { hoverable:true, autoHighlight:false }
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

//---------------------------------------------------------------------------
function updateLegend(plot, legends, latestPosition) {
    if (plot == null)
        return;
    var pos = latestPosition;

    var axes = plot.getAxes();
    if (pos.x < axes.xaxis.min || pos.x > axes.xaxis.max ||
        pos.y < axes.yaxis.min ||
        pos.y > axes.yaxis.max)
        return;

    var i, j, dataset = plot.getData();
    for (i = 0; i < dataset.length; ++i) {
        var series = dataset[i];

        // find the nearest points, x-wise
        for (j = 0; j < series.data.length; ++j)
            if (series.data[j][0] > pos.x)
                break;

        // now interpolate
        var y, p1 = series.data[j - 1], p2 = series.data[j];
        if (p1 == null)
            y = p2[1];
        else if (p2 == null)
            y = p1[1];
        else
            y = p1[1] + (p2[1] - p1[1]) * (pos.x - p1[0]) / (p2[0] - p1[0]);

        legends.eq(i).text(series.label.replace(/=.*/, "= " + y.toFixed(1)));
    }
}


function installPlotFunc(options, plot_placeholder, loadKey) {
    var data = [];
    var datasets = {};
    var placeholder = $("#" + plot_placeholder);
    var plot = null;
    var legends = null;

    // plotter
    function doPlot() {
        plot = $.plot(placeholder, data, options);

        legends = $("#" + plot_placeholder + " .legendLabel");
        legends.each(function () {
            // fix the widths so they don't jump around
            $(this).css('width', $(this).width());
        });
    }

    // hover for legends
    var updateLegendTimeout = null;
    var latestPosition = null;
    placeholder.bind("plothover", function (event, pos, item) {
        latestPosition = pos;
        if (!updateLegendTimeout)
            updateLegendTimeout = setTimeout(updatePlotLegend, 50);
    });
    function updatePlotLegend() {
        updateLegendTimeout = null;
        updateLegend(plot, legends, latestPosition);
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
    $("#" + choiceTable + "update").click(plotAccordingToChoices);
    $("#" + choiceTable + "checkall").click(checkAll(choiceContainer, '', true));
    $("#" + choiceTable + "uncheckall").click(checkAll(choiceContainer, '', false));

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

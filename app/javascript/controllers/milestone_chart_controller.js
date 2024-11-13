// app/javascript/controllers/milestone_chart_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    // Get tasks data from data attribute and parse it
    const tasks = JSON.parse(this.data.get("tasks"));
    const milestoneId = this.data.get("id");

    // Prepare chart data based on task statuses
    const chartData = this.prepareChartData(tasks);

    // Render the chart
    this.renderChart(milestoneId, chartData);
  }

prepareChartData(tasks) {
    const statusCounts = this.countTaskStatuses(tasks);
    return this.convertCountsToChartData(statusCounts, tasks.length);
}

countTaskStatuses(tasks) {
    const statusCounts = {
        'Not Started': 0,
        'In-Progress': 0,
        'Completed': 0,
        'Not Completed': 0
    };

    tasks.forEach(task => {
        if (statusCounts.hasOwnProperty(task.status)) {
            statusCounts[task.status]++;
        }
    });

    console.log("STATUS COUNTS ", statusCounts);
    return statusCounts;
}

convertCountsToChartData(statusCounts, totalTasks) {
    const statuses = [
        { name: 'Not Started', color: '#EC7A08' },
        { name: 'In-Progress', color: '#009596' },
        { name: 'Completed', color: '#4CB140' },
        { name: 'Not Completed', color: '#f45b5b' }
    ];

    return statuses.map(status => {
        return {
            name: status.name,
            y: (statusCounts[status.name] / totalTasks) * 100,
            color: status.color
        };
    });
}


  renderChart(milestoneId, chartData) {
    const Highcharts = window.Highcharts;
    Highcharts.chart(`milestone-chart-${milestoneId}`, {
        chart: {
            type: 'pie'
        },
        title: {
            text: 'Task Status Distribution'
        },
        plotOptions: {
            pie: {
                innerSize: '30%',
                dataLabels: {
                    enabled: true,
                    format: '<b>{point.name}</b>: {point.y} ({point.percentage:.1f}%)'
                }
            }
        },
        series: [{
            name: 'Tasks',
            colorByPoint: true,
            data: chartData
        }]
    });
  }
}

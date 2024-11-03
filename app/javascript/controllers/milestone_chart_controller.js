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
    // Define possible statuses and corresponding colors
    const statuses = [
        { name: 'Not Started', color: '#EC7A08' },
        { name: 'In-Progress', color: '#009596' },
        { name: 'Completed', color: '#4CB140' },
        { name: 'Not Completed', color: '#f45b5b' }
    ];

    // Initialize a count object for each status
    const statusCounts = {
        'Not Started': 0,
        'In-Progress': 0,
        'Completed': 0,
        'Not Completed': 0
    };

    // Count each task's status
    tasks.forEach(task => {
        if (statusCounts.hasOwnProperty(task.status)) {
            statusCounts[task.status]++;
        }
    });

    // Calculate the total number of tasks
    const totalTasks = tasks.length;

    // Convert counts to percentage data for the pie chart
    const chartData = statuses.map(status => {
        return {
            name: status.name,
            y: (statusCounts[status.name] / totalTasks) * 100,
            color: status.color
        };
    });
    console.log("STATUS COUNTS ", statusCounts);
    return chartData;
}


  renderChart(milestoneId, chartData) {
    const Highcharts = window.Highcharts;
    //   chart: {
    //     type: "pie",
    //   },
    //   title: {
    //     text: "Task Status Distribution",
    //   },
    //   tooltip: {
    //     pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>',
    //   },
    //   accessibility: {
    //     point: {
    //       valueSuffix: '%'
    //     }
    //   },
    //   plotOptions: {
    //     pie: {
    //       allowPointSelect: true,
    //       cursor: 'pointer',
    //       dataLabels: {
    //         enabled: true,
    //         format: '<b>{point.name}</b>: {point.percentage:.1f} %'
    //       }
    //     }
    //   },
    //   series: [
    //     {
    //       name: "Tasks",
    //       colorByPoint: true,
    //       data: chartData,
    //     },
    //   ],
    // });

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

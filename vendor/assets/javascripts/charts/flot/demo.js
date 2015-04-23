$(function () {

  $("#flot-1ine").length && $.plot($("#flot-1ine"), [
        {
          //data: []
        }
      ],
      {
        tooltip: true,
        tooltipOpts: {
          content: "chart: %x.1 is %y.4",
          defaultTheme: false,
          shifts: {
            x: 0,
            y: 20
          }
        }
      }
  );



});

$(document).ready(function() {
    if($("#flot-1ine").length > 0)
    {
        LoadCharts();
    }
});

var LoadCharts = function(){
    $.ajax("/staff/statistics_data/customers_vital_data", {
        success: function (data) {
            $('#obesity').html(data.obese)
            $('#overweight').html(data.over_weight)
            $('#healthy').html(data.healthy_count)
            var customer_vitals = [
                {
                    label: "Overweight",
                    data: data.over_weight,
                    color: '#65b5c2'
                },
                {
                    label: "Obese",
                    data: data.obese,
                    color: '#3993bb'
                },
                {
                    label: "Healthy",
                    data: data.healthy_count,
                    color: '#23649e'
                }
            ];
            $("#flot-pie-donut").length && $.plot($("#flot-pie-donut"), customer_vitals, {
                series: {
                    pie: {
                        innerRadius: 0.4,
                        show: true,
                        stroke: {
                            width: 0
                        },
                        label: {
                            show: true,
                            threshold: 0.05
                        }
                    }
                },
                colors: ["#65b5c2", "#4da7c1", "#3993bb", "#2e7bad", "#23649e"],
                grid: {
                    hoverable: true,
                    clickable: false
                },
                tooltip: true,
                tooltipOpts: {
                    content: "%s: %p.0%"
                }
            });

        },
        error: function() {
            $('#notification-bar').text('An error occurred');
        }
    });





    $.ajax("/staff/statistics_data/index", {
        success: function(data) {
            var dk = [];
            var labels=[]
            var customer_data=data.data
            var count=0;
            for (var key in customer_data) {
                dk.push([count,customer_data[key]])
                labels.push([count,key]);
                count++;
            }

            $("#flot-1ine").length && $.plot($("#flot-1ine"), [
                    {
                        data: dk
                    }
                ],
                {
                    series: {
                        lines: {
                            show: true,
                            lineWidth: 1,
                            fill: true,
                            fillColor: {
                                colors: [
                                    {
                                        opacity: 0.3
                                    },
                                    {
                                        opacity: 0.3
                                    }
                                ]
                            }
                        },
                        points: {
                            radius: 3,
                            show: true
                        },
                        grow: {
                            active: true,
                            steps: 50
                        },
                        shadowSize: 2
                    },
                    grid: {
                        hoverable: true,
                        clickable: true,
                        tickColor: "#f0f0f0",
                        borderWidth: 1,
                        color: '#f0f0f0'
                    },
                    colors: ["#1bb399"],
                    xaxis: {
                        ticks: labels
                    },
                    yaxis: {
                        ticks: 2
                    },
                    tooltip: true,
                    tooltipOpts: {
                        content: "%y.4 customers",
                        defaultTheme: false,
                        shifts: {
                            x: 0,
                            y: 20
                        }
                    }
                }
            );

            $('.easypiechart').easyPieChart({

            });
            health_data = [
                {
                    label: "CVD",
                    data: data.cvds
                },
                {
                    label: "Hypertension",
                    data: data.hypertensions
                },
                {
                    label: "Diabetes",
                    data: data.diabetics
                },
            ];
            $("#health-pie").length && $.plot($("#health-pie"), health_data, {
                series: {
                    pie: {
                        combine: {
                            color: "#999",
                            threshold: 0.05
                        },
                        show: true
                    }
                },
                colors: ["#65b5c2", "#4da7c1", "#3993bb", "#2e7bad", "#23649e"],
                legend: {
                    show: false
                },
                grid: {
                    hoverable: true,
                    clickable: false
                },
                tooltip: true,
                tooltipOpts: {
                    content: "%s: %p.0%"
                }
            });
            appointments_data = [
                {
                    label: "Dental",
                    data: data.dental
                },
                {
                    label: "Body",
                    data: data.body_count
                },
                {
                    label: "Vision",
                    data: data.vision
                },
            ];
            $("#appoint-pie").length && $.plot($("#appoint-pie"), appointments_data, {
                series: {
                    pie: {
                        combine: {
                            color: "#999",
                            threshold: 0.05
                        },
                        show: true
                    }
                },
                colors: ["#65b5c2", "#4da7c1", "#3993bb", "#2e7bad", "#23649e"],
                legend: {
                    show: false
                },
                grid: {
                    hoverable: true,
                    clickable: false
                },
                tooltip: true,
                tooltipOpts: {
                    content: "%s: %p.0%"
                }
            });

        },
        error: function() {
            $('#notification-bar').text('An error occurred');
        }
    });


    $.ajax("/staff/statistics_data/document_upload_status_data", {
        success: function (data) {
            $('#uploaded_customers').html(data.uploaded_customers)
            $('#not_uploaded_customers').html(data.not_uploaded_customers)
            var document_data = [
                {
                    label: "Uploaded Document",
                    data: data.uploaded_customers
                },
                {
                    label: "Not Uploaded",
                    data: data.not_uploaded_customers
                }
            ];
            $("#flot-pie").length && $.plot($("#flot-pie"), document_data, {
                series: {
                    pie: {
                        combine: {
                            color: "#999",
                            threshold: 0.05
                        },
                        show: true
                    }
                },
                colors: ["#65b5c2", "#4da7c1", "#3993bb", "#2e7bad", "#23649e"],
                legend: {
                    show: false
                },
                grid: {
                    hoverable: true,
                    clickable: false
                },
                tooltip: true,
                tooltipOpts: {
                    content: "%s: %p.0%"
                }
            });
        },
        error: function() {
            $('#notification-bar').text('An error occurred');
        }
    });
    $.ajax("/staff/staff_charts/assessments_not_done", {
        success: function (data) {
            $('#assessments_not_done_count').html(data.not_done_count);
            $('#assessments_not_done_piechart').find('.easypiechart').data('easyPieChart').update(data.not_done_percentage);
            $('#assessments_not_done_percentage').html(data.not_done_percentage);
        },
        error: function() {
            $('#notification-bar').text('An error occurred');
        }
    });
    $.ajax("/staff/staff_charts/unverified_emails", {
        success: function (data) {
            $('#unverified_email_count').html(data.unverified_email_count);
            $('#unverified_email_piechart').find('.easypiechart').data('easyPieChart').update(data.unverified_email_percentage);
            $('#unverified_email_percentage').html(data.unverified_email_percentage);
        },
        error: function() {
            $('#notification-bar').text('An error occurred');
        }
    });
    $.ajax("/staff/staff_charts/abnormal_bp", {
        success: function (data) {
            $('#abnormal_bp_count').html(data.abnormal_bp_count);
            $('#abnormal_bp_piechart').find('.easypiechart').data('easyPieChart').update(data.abnormal_bp_percentage);
            $('#abnormal_bp_percentage').html(data.abnormal_bp_percentage);
        },
        error: function() {
            $('#notification-bar').text('An error occurred');
        }
    });

}
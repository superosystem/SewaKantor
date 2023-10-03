import { Doughnut } from "react-chartjs-2";
import { CategoryScale, Chart } from "chart.js/auto";
import React from "react";
const plugins = [
  {
    beforeDraw: function (chart) {
      var width = chart.width,
        height = chart.height,
        ctx = chart.ctx;
      ctx.restore();
      var fontSize = (height / 160).toFixed(2);
      ctx.font = fontSize + "em sans-serif";
      ctx.textBaseline = "top";
      var text = "100%",
        textX = Math.round((width - ctx.measureText(text).width) / 3),
        textY = height / 2.1;
      ctx.fillText(text, textX, textY);
      ctx.save();
    },
  },
];
const DoughnutChart = ({ chartData }) => {
  return (
    <Doughnut
      data={chartData}
      options={{
        responsive: true,
        plugins: {
          datalabels: {
            display: true,
            align: "bottom",
            backgroundColor: "#ccc",
            borderRadius: 3,
            font: {
              size: 16,
            },
          },
          legend: {
            position: "right",
            labels: {
              usePointStyle: true,
            },
            fullSize: true,
          },
        },
      }}
      plugins={plugins}
    />
  );
};

export default DoughnutChart;

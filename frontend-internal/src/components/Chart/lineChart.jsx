import React from "react";
import { Line } from "react-chartjs-2";
import { CategoryScale, Chart } from "chart.js/auto";

const BarChart = ({ chartData }) => {
  return (
    <Line
      data={chartData}
      options={{
        responsive: true,
        plugins: {
          legend: {
            position: "bottom",
            labels: {
              usePointStyle: true,
            },
          },
        },
      }}
    />
  );
};

export default BarChart;

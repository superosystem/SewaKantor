import React, { useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import {
  Box,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Typography,
} from "@mui/material";
import { getVaksinList } from "../../store/features/dashboard/dashboardSlice";

const cell = [
  {
    id: 1,
    label: "Vaccine Name",
  },
  {
    id: 2,
    label: "1st Vaccination",
  },
  {
    id: 3,
    label: "2nd Vaccination",
  },
  {
    id: 4,
    label: "3th Vaccination",
  },
];

const TableVaksinTersedia = () => {
  const dispatch = useDispatch();

  const { dataVaksin } = useSelector((state) => state.dashboard);

  const result = dataVaksin.reduce((acc, item) => {
    const foundDose = acc.find((x) => x.name === item.Name);
    if (foundDose) {
      foundDose[`dosis${item.Dose}`] = item.Stock;
    } else {
      acc.push({
        name: item.Name,
        [`dosis${item.Dose}`]: item.Stock,
      });
    }
    return acc;
  }, []);

  result.forEach((item) => {
    for (let i = 1; i <= 3; i++) {
      if (!item[`dosis${i}`]) {
        item[`dosis${i}`] = 0;
      }
    }
  });

  useEffect(() => {
    dispatch(getVaksinList());
  }, [dispatch]);

  return (
    <Box sx={{ my: 4 }}>
      <TableContainer>
        <Typography variant="h5">Available Vaccine Statistics</Typography>
        <Table>
          <TableHead>
            <TableRow sx={{ backgroundColor: "#EEF6ED" }} height={52}>
              {cell.map(({ id, label }) => {
                return (
                  <TableCell
                    key={id}
                    sx={{ fontWeight: 700 }}
                    align={
                      label.toLowerCase().includes("dosis") ? "center" : "left"
                    }
                  >
                    {label}
                  </TableCell>
                );
              })}
            </TableRow>
          </TableHead>
          <TableBody>
            {result.map((item, id) => {
              const { name, dosis1, dosis2, dosis3 } = item;
              return (
                <TableRow key={id} height={52}>
                  <TableCell>{name}</TableCell>
                  <TableCell align="center">{dosis1} dose</TableCell>
                  <TableCell align="center">{dosis2} dose</TableCell>
                  <TableCell align="center">{dosis3} dose</TableCell>
                </TableRow>
              );
            })}
          </TableBody>
        </Table>
      </TableContainer>
    </Box>
  );
};

export default TableVaksinTersedia;

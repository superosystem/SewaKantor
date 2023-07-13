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
import { fetchUserStatic } from "../../store/features/dashboard/dashboardSlice";

const cell = [
  {
    id: 1,
    label: "Range Ages",
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

const TablePendaftar = () => {
  const dispatch = useDispatch();

  const { data: DataDashboard } = useSelector((state) => state.dashboard);

  useEffect(() => {
    dispatch(fetchUserStatic());
  }, [dispatch]);

  return (
    <Box sx={{ my: 4 }}>
      <TableContainer>
        <Typography variant="h5">Vaccine Registrant Statistics</Typography>
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
            {DataDashboard?.RegisteredStat?.map((item, id) => {
              const { Name, DoseOne, DoseTwo, DoseThree } = item;
              return (
                <TableRow key={id} height={52}>
                  <TableCell>{Name}</TableCell>
                  <TableCell align="center">{DoseOne} dose</TableCell>
                  <TableCell align="center">{DoseTwo} dose</TableCell>
                  <TableCell align="center">{DoseThree} dose</TableCell>
                </TableRow>
              );
            })}
          </TableBody>
        </Table>
      </TableContainer>
    </Box>
  );
};

export default TablePendaftar;

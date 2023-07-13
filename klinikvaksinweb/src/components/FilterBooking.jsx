import React from "react";
import moment from "moment";
import {
  Button,
  MenuItem,
  Select,
  Stack,
  TextField,
  Typography,
} from "@mui/material";
import { DesktopDatePicker } from "@mui/x-date-pickers";
import MoreFilter from "./MoreFilter";
import CloseIcon from "@mui/icons-material/Close";

const FilterBooking = ({
  resetFilter,
  selectedFilter,
  handleFilterDate,
  handleFilterVaksin,
  handleFilterStatus,
  setFilter,
}) => {
  const { date, vaksin, status } = selectedFilter;

  return (
    <>
      <Stack direction={"row"} spacing={2}>
        <Stack
          direction={"row"}
          sx={{
            alignItems: "center",
            flexBasis: "30%",
          }}
          spacing={1}
        >
          <Typography>Date</Typography>
          <DesktopDatePicker
            name="tanggal"
            inputFormat="DD/MM/YYYY"
            value={date || moment()}
            onChange={handleFilterDate}
            renderInput={(params) => (
              <TextField size="small" fullWidth {...params} />
            )}
          />
        </Stack>

        <Stack
          direction={"row"}
          sx={{
            alignItems: "center",
            flexBasis: "30%",
          }}
          spacing={1}
        >
          <Typography>Vaccine</Typography>
          <Select
            fullWidth
            size="small"
            value={vaksin || "All"}
            onChange={handleFilterVaksin}
          >
            <MenuItem value="All">All</MenuItem>
            <MenuItem value="AstraZeneca">AstraZeneca</MenuItem>
            <MenuItem value="Janssen">Janssen</MenuItem>
            <MenuItem value="Moderna">Moderna</MenuItem>
            <MenuItem value="Sinovac">Sinovac</MenuItem>
            <MenuItem value="Novavax">Novavax</MenuItem>
            <MenuItem value="Sputnik">Sputnik</MenuItem>
            <MenuItem value="Pfizer">Pfizer</MenuItem>
          </Select>
        </Stack>

        <Stack
          direction={"row"}
          sx={{
            alignItems: "center",
            flexBasis: "30%",
          }}
          spacing={1}
        >
          <Typography>Status</Typography>
          <Select
            fullWidth
            size="small"
            value={status || "All"}
            onChange={handleFilterStatus}
          >
            <MenuItem value="All">All</MenuItem>
            <MenuItem value="Going On">Going On</MenuItem>
            <MenuItem value="Available">Available</MenuItem>
            <MenuItem value="Full">Full</MenuItem>
          </Select>
        </Stack>
        <MoreFilter selectedFilter={selectedFilter} setFilter={setFilter} />
      </Stack>
      <Button
        color="danger"
        variant="outlined"
        onClick={resetFilter}
        sx={{
          width: "max-content",
        }}
        startIcon={<CloseIcon />}
      >
        Reset Filter
      </Button>
    </>
  );
};

export default FilterBooking;

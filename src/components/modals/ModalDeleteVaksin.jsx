import React, { useState } from "react";
import { useDispatch } from "react-redux";
import {
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  Divider,
  IconButton,
  Typography,
} from "@mui/material";
import DeleteOutlinedIcon from "@mui/icons-material/DeleteOutlined";
import ErrorOutlineOutlinedIcon from "@mui/icons-material/ErrorOutlineOutlined";
import { deleteVaksin } from "../../store/features/vaksin/vaksinSlice";

const ModalDeleteVaksin = ({ id }) => {
  const [open, setOpen] = useState(false);
  const dispatch = useDispatch();

  const handleOpen = () => setOpen(true);
  const handleClose = () => setOpen(false);
  const handleSubmit = () => {
    dispatch(deleteVaksin(id));
    setOpen(false);
  };

  return (
    <>
      <IconButton
        color="danger"
        onClick={handleOpen}
        aria-label="delete"
        sx={{ border: "1px solid" }}
      >
        <DeleteOutlinedIcon />
      </IconButton>

      <Dialog fullWidth maxWidth="xs" open={open} onClose={handleClose}>
        <DialogTitle sx={{ display: "flex", alignItems: "end", gap: 1 }}>
          <ErrorOutlineOutlinedIcon color="danger" fontSize="large" />
          <Typography variant="h5">
            Are you sure you want to delete the vaccine?
          </Typography>
        </DialogTitle>
        <Divider />
        <DialogContent>Deleted data cannot be recovered.</DialogContent>
        <DialogActions>
          <Button onClick={handleClose}>Cancel</Button>
          <Button onClick={() => handleSubmit()} color="danger">
            Delete
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
};

export default ModalDeleteVaksin;

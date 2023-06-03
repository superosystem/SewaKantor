import React from "react";
import { useNavigate } from "react-router-dom";
import {
  Avatar,
  MenuItem,
  Menu,
  IconButton,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
} from "@mui/material";
import AccountCircleIcon from "@mui/icons-material/AccountCircle";
import ErrorOutlineOutlinedIcon from "@mui/icons-material/ErrorOutlineOutlined";
import Auth from "../utils/Auth";

const UserAvatar = () => {
  const [showAlert, setShowAlert] = React.useState(false);
  const [anchorEl, setAnchorEl] = React.useState(null);
  const open = Boolean(anchorEl);
  const navigate = useNavigate();

  const handleClick = (event) => {
    setAnchorEl(event.currentTarget);
  };

  const handleClose = () => {
    setAnchorEl(null);
  };

  const handleLogout = () => {
    setShowAlert(false);
    Auth.logout(navigate);
  };

  return (
    <div>
      <IconButton
        onClick={handleClick}
        id="basic-button"
        aria-controls={open ? "basic-menu" : undefined}
        aria-haspopup="true"
        aria-expanded={open ? "true" : undefined}
      >
        <Avatar>
          <AccountCircleIcon />
        </Avatar>
      </IconButton>
      <Menu
        id="basic-menu"
        anchorEl={anchorEl}
        open={open}
        onClose={handleClose}
        transformOrigin={{ horizontal: "right", vertical: "top" }}
        anchorOrigin={{ horizontal: "right", vertical: "bottom" }}
        MenuListProps={{
          "aria-labelledby": "basic-button",
        }}
      >
        <MenuItem onClick={handleClose}>Setting</MenuItem>
        <MenuItem
          onClick={() => {
            setShowAlert(true);
          }}
        >
          Logout
        </MenuItem>
      </Menu>

      {/* dialog confirm logout */}
      <Dialog open={showAlert} maxWidth="xs" fullWidth align={"center"}>
        <DialogTitle>
          <ErrorOutlineOutlinedIcon color="danger" fontSize="large" />
        </DialogTitle>
        <DialogContent>Are you sure you want to Exit?</DialogContent>
        <DialogActions sx={{ px: 2 }}>
          <Button
            onClick={() => {
              setShowAlert(false);
              setAnchorEl(null);
            }}
          >
            Cancel
          </Button>
          <Button color="danger" onClick={() => handleLogout()}>
            Logout
          </Button>
        </DialogActions>
      </Dialog>
    </div>
  );
};

export default UserAvatar;

import React from "react";
import { NavLink as NavLinkBase, useLocation } from "react-router-dom";
import { useSelector } from "react-redux";
import {
  Box,
  darken,
  Link,
  List,
  ListItem,
  ListItemButton,
  ListItemIcon,
  ListItemText,
  Stack,
  Typography,
} from "@mui/material";
import DashboardOutlinedIcon from "@mui/icons-material/DashboardOutlined";
import ConfirmationNumberOutlinedIcon from "@mui/icons-material/ConfirmationNumberOutlined";
import EventOutlinedIcon from "@mui/icons-material/EventOutlined";
import TimelineOutlinedIcon from "@mui/icons-material/TimelineOutlined";
import VaccinesOutlinedIcon from "@mui/icons-material/VaccinesOutlined";
import theme from "../../themes";
import vaccinePartnersLogo from "../../assets/img/vaccine-partners-logo-name.png";

// override react-router-dom's Link component to the MUI's ListItem component
const NavLink = React.forwardRef((props, ref) => {
  return (
    <NavLinkBase
      ref={ref}
      {...props}
      className={({ isActive }) =>
        `${props.className} ${isActive ? props.activeClassName : ""}`
      }
    />
  );
});

const Sidebar = ({ width }) => {
  const { open } = useSelector((state) => state.sidebar);
  const { pathname } = useLocation();

  // add sidebar list item here
  const sidebarComponents = [
    {
      label: "Home",
      route: "/dashboard",
      icon: <DashboardOutlinedIcon />,
    },
    {
      label: "Booking",
      route: "/manage-booking",
      icon: <ConfirmationNumberOutlinedIcon />,
    },
    {
      label: "Session",
      route: "/manage-session",
      icon: <EventOutlinedIcon />,
    },
    {
      label: "Vaccine Stock",
      route: "/vaccine-stock",
      icon: <TimelineOutlinedIcon />,
    },
    {
      label: "Vaccine Brand",
      route: "/vaccine-brand",
      icon: <VaccinesOutlinedIcon />,
    },
  ];

  return (
    <Stack
      sx={{
        width: width,
        position: "fixed",
        top: 0,
        bottom: 0,
        background: theme.color.greenOpaque,
        transition: "1s ease",
        px: 2,
        zIndex: 9999,
      }}
    >
      <Stack alignItems={"center"} sx={{ mt: 4 }}>
        <img
          src={vaccinePartnersLogo}
          alt="vaccine-partners"
          width={100}
          height={100}
        />
      </Stack>
      <Box>
        <List>
          {sidebarComponents.map((item, idx) => {
            const { label, route, icon } = item;
            return (
              <ListItem key={idx} disablePadding>
                <ListItemButton
                  selected={pathname.includes(route)}
                  component={NavLink}
                  sx={{
                    borderRadius: 2,
                    my: 1,
                    "&.Mui-selected": {
                      bgcolor: "#006D39",
                      color: theme.color.neutral,
                      "&:hover": {
                        bgcolor: darken("#006D39", 0.125),
                        color: theme.color.neutral,
                      },
                    },
                  }}
                  to={route}
                >
                  <ListItemIcon sx={{ color: "inherit" }}>{icon}</ListItemIcon>
                  {open && (
                    <ListItemText
                      primary={label}
                      sx={{ transition: ".5s ease" }}
                    />
                  )}
                </ListItemButton>
              </ListItem>
            );
          })}
        </List>
      </Box>
      <Stack
        sx={{
          alignItems: "center",
          position: "fixed",
          bottom: 0,
          left: 0,
          transform: "translate(25%,0)",
        }}
      >
        <Link underline="hover">About Us</Link>
        <Typography>&copy; 2021 - {new Date().getFullYear().toString()} Vaccine Partners</Typography>
      </Stack>
    </Stack>
  );
};

export default Sidebar;

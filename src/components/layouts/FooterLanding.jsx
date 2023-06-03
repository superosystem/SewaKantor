import React from "react";
import {
  Box,
  Typography,
  Container,
  Stack,
  Link,
  lighten,
  IconButton,
} from "@mui/material";
import FacebookRoundedIcon from "@mui/icons-material/FacebookRounded";
import InstagramIcon from "@mui/icons-material/Instagram";
import TwitterIcon from "@mui/icons-material/Twitter";
import useCurrentScreen from "../../hooks/useCurrentScreen";
import theme from "../../themes";
import Logo from "../../assets/img/vaccine-partners-logo-name.png";

const FooterLanding = () => {
  const { mobile, tablet } = useCurrentScreen();
  return (
    <>
      <Box
        sx={{
          background: theme.color.greenOpaque,
          mt: 6,
        }}
      >
        <Container>
          <Stack
            direction="row"
            sx={{
              justifyContent: "space-between",
              alignItems: "start",
              py: 6,
            }}
          >
            <Stack direction={mobile || tablet ? "column" : "row"} spacing={2}>
              <Link underline="hover">Terms and Conditions</Link>
              <Link underline="hover">Privacy Policy</Link>
            </Stack>

            <img
              width={68}
              height={68}
              src={Logo}
              alt="logo-vaccine-partners"
            />

            <Stack
              spacing={3}
              sx={{ alignItems: "end", color: "primary.main" }}
            >
              <Stack direction={"row"} spacing={1}>
                <IconButton color="inherit">
                  <TwitterIcon />
                </IconButton>
                <IconButton color="inherit">
                  <FacebookRoundedIcon />
                </IconButton>
                <IconButton color="inherit">
                  <InstagramIcon />
                </IconButton>
              </Stack>
              <Typography sx={{ color: lighten("#000", 0.2) }}>
                &copy; Vaccine Partners. All rights reserved.
              </Typography>
            </Stack>
          </Stack>
        </Container>
      </Box>
    </>
  );
};

export default FooterLanding;
